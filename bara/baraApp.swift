//
//  baraApp.swift
//  bara
//
//  Created by Muhammad Aliffandy on 16/08/26.
//

import SwiftUI
import SwiftData
import ActivityKit
import UserNotifications

@main
struct baraApp: App {
    
    // Setup Shared SwiftData Container
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([WorkSession.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State private var showBreakSheet = false
    @State private var backgroundTaskId: UIBackgroundTaskIdentifier = .invalid
    @State private var breakTimerTask: Task<Void, Never>? = nil
    
    @Environment(\.scenePhase) private var scenePhase
    
    @AppStorage("isTakingBreak", store: UserDefaults(suiteName: "group.com.fandy.bara.shared")) private var isTakingBreak = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light) // Paksa aplikasi selalu dalam Light Mode
                .onOpenURL { url in
                    handleDeepLink(url)
                }
                // Layar ini muncul saat user mau break (teleportasi dari Shield)
                .fullScreenCover(isPresented: $showBreakSheet) {
                    ScreenShieldView { duration, task in
                        startBreak(duration: duration, task: task)
                        showBreakSheet = false // Tutup layar setelah setup selesai
                    }
                }
        }
        .modelContainer(baraApp.sharedModelContainer)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                checkPendingBreakRequest()
            }
        }
        .onChange(of: isTakingBreak) { _, isBreakNow in
            // Pastikan jika break berakhir (dari mana pun: tombol dalam app atau dynamic island)
            // semua background task dan live activity dibersihkan!
            if !isBreakNow {
                endLiveActivity()
            }
        }
    }
    
    // MARK: - Auto-Teleport Handler
    private func checkPendingBreakRequest() {
        if AppStorageService.shared.pendingBreakRequest {
            AppStorageService.shared.pendingBreakRequest = false
            showBreakSheet = true
        }
    }
    
    // MARK: - Deep Link Handler
    private func handleDeepLink(_ url: URL) {
        let urlString = url.absoluteString
        
        if urlString.starts(with: "bara://planbreak") {
            showBreakSheet = true
        } else if url.scheme == "timecount" {
            if url.host == "continue" {
                // "Continue Work" tapped on Dynamic Island
                endLiveActivity()
                
                // Simpan point Commit (sukses)
                baraApp.sharedModelContainer.mainContext.insert(WorkSession(timerDuration: AppStorageService.shared.breakDurationSeconds, status: "commit"))
                
                AppStorageService.shared.isTakingBreak = false
                AppStorageService.shared.isWorking = true
                AppFamilyControlService.shared.startShielding()
                showBreakSheet = false
            } else if url.host == "dismiss" {
                // "Dismiss" tapped on Dynamic Island (end session completely)
                endLiveActivity()
                
                // Simpan point Dismiss
                baraApp.sharedModelContainer.mainContext.insert(WorkSession(timerDuration: AppStorageService.shared.breakDurationSeconds, status: "dismiss"))
                
                // Ubah status menjadi dismissed, JANGAN end session dulu, 
                // biarkan WorkBreakView yang mengatur kepulangannya via tombol "Back to Home".
                AppStorageService.shared.isBreakDismissed = true
                showBreakSheet = false
            }
        }
    }
    
    // MARK: - Break Logic (dipanggil saat user konfirmasi di PlanReturnSheet)
    private func startBreak(duration: TimeInterval, task: String) {
        // 1. Simpan data & Set State
        AppStorageService.shared.breakDurationSeconds = duration
        AppStorageService.shared.currentTaskTitle = task
        AppStorageService.shared.breakEndDate = Date().addingTimeInterval(duration).timeIntervalSince1970
        AppStorageService.shared.isTakingBreak = true
        AppStorageService.shared.isWorking = true
        
        // 2. Lepas Shield → TikTok terbuka bebas
        AppFamilyControlService.shared.stopShielding()
        
        // 3. Akhiri Live Activity lama yang mungkin masih hidup
        endLiveActivity()
        
        // 4. Tunggu sebentar lalu nyalakan Live Activity baru
        Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // 0.3 detik
            await MainActor.run {
                startLiveActivity(duration: duration, task: task)
            }
        }
        
        // 5. Jalankan Background Timer untuk memaksa Dynamic Island mekar (.expanded)
        // C4-MIRACLE Hack: Menahan app di background menggunakan UIBackgroundTask
        // (Berfungsi sempurna untuk durasi singkat!)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["BaraBreakEnd", "BaraBreakWarning"])
    }
    
    // MARK: - Helper End Live Activity
    private func endLiveActivity() {
        // Batalkan Task sleep
        breakTimerTask?.cancel()
        breakTimerTask = nil
        
        Task {
            for activity in Activity<TimeCountWidgetAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
        
        // Matikan Background Task
        if backgroundTaskId != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
            backgroundTaskId = .invalid
        }
    }
    
    // MARK: - Live Activity
    private func startLiveActivity(duration: TimeInterval, task: String) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("⚠️ Live Activities tidak diizinkan.")
            return
        }
        
        let now = Date()
        let endDate = now.addingTimeInterval(duration)
        
        let attributes = TimeCountWidgetAttributes(startDate: now, endDate: endDate)
        let state = TimeCountWidgetAttributes.ContentState(
            emoji: "🔥",
            currentTask: task.isEmpty ? "Stay focused!" : task
        )
        let content = ActivityContent(state: state, staleDate: endDate.addingTimeInterval(60))
        
        do {
            let activity = try Activity.request(attributes: attributes, content: content, pushType: nil)
            print("✅ Dynamic Island menyala! Countdown: \(Int(duration))s | ID: \(activity.id)")
            
            // Panggil hack timer background
            startBackgroundBreakTimer(duration: duration, activity: activity)
        } catch {
            print("❌ Gagal nyalakan Dynamic Island: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Background Timer (Auto-Expand Trigger)
    private func startBackgroundBreakTimer(duration: TimeInterval, activity: Activity<TimeCountWidgetAttributes>) {
        if backgroundTaskId != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
        }
        
        breakTimerTask?.cancel()
        
        backgroundTaskId = UIApplication.shared.beginBackgroundTask(withName: "BreakTimer") {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskId)
            self.backgroundTaskId = .invalid
        }
        
        breakTimerTask = Task {
            let warningDuration = duration * 0.85
            let remain = duration - warningDuration
            
            // Tunggu sampai sisa 15% (85% terlewat)
            if warningDuration > 0 {
                try? await Task.sleep(nanoseconds: UInt64(warningDuration * 1_000_000_000))
                if Task.isCancelled { return }
                await triggerDynamicIslandAlert(activity: activity, title: "Waktumu sisa sedikit! ⏳", body: "Siap-siap kembali kerja!")
            }
            
            // Tunggu sisa waktu habis
            if remain > 0 {
                try? await Task.sleep(nanoseconds: UInt64(remain * 1_000_000_000))
                if Task.isCancelled { return }
                await triggerDynamicIslandAlert(activity: activity, title: "Break's over! 🔥", body: "Waktunya kembali kerja.")
                
                // Beri waktu 10 detik agar banner notifikasi terlihat oleh user, lalu bunuh Live Activity-nya
                try? await Task.sleep(nanoseconds: 10 * 1_000_000_000)
                if Task.isCancelled { return }
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            
            // Cleanup
            if backgroundTaskId != .invalid {
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
                backgroundTaskId = .invalid
            }
        }
    }
    
    private func triggerDynamicIslandAlert(activity: Activity<TimeCountWidgetAttributes>, title: String, body: String) async {
        // Menggunakan AlertConfiguration adalah SATU-SATUNYA cara agar ActivityKit mekarkan (expand) UI secara otomatis
        let alert = AlertConfiguration(
            title: LocalizedStringResource(stringLiteral: title),
            body: LocalizedStringResource(stringLiteral: body),
            sound: .default
        )
        let currentState = activity.content.state
        // Update dengan alertConfiguration akan memicu drop-down banner dari Dynamic Island
        await activity.update(ActivityContent(state: currentState, staleDate: nil), alertConfiguration: alert)
    }
}
