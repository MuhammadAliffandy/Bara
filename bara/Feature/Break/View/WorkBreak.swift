//
//  Break.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI
import Combine
import UserNotifications
import SwiftData

struct WorkBreakView: View {
    @Environment(\.modelContext) private var modelContext
    
    let fireFrames = [
            AppImage.ImageFireBreak1,
            AppImage.ImageFireBreak2
        ]
    
    let fireFramesDismiss = [
            AppImage.ImageFireBurnout1,
            AppImage.ImageFireBurnout2
        ]
        
    let fireFrameWork = [
            AppImage.ImageFireWork1,
            AppImage.ImageFireWork2
        ]
  
    @State private var currentFrameIndex = 0
 
    @State private var isTimesUp = false
    @AppStorage("isBreakDismissed", store: UserDefaults(suiteName: "group.com.fandy.bara.shared")) private var isDismiss = false
    
    @State private var remainingTimeString = "00:00"

    let AnimationTimer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    let CountdownTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            VStack(alignment: .center, spacing:AppSpacing.regular * 3) {
            
                if isDismiss {
                    AppHeadline(
                        title: "Oops, you let the fire fade",
                        subtitle: "You dismissed the campfire, and the flame has gone out.",
                        titleStyle: .appLargeTitleV2,
                        alignment: .center,
                        textAlignment: .center,
                        spacing: AppSpacing.regular * 2
                    )
                }else{
                    AppHeadline(
                        title: remainingTimeString,
                        subtitle: "Break time remaining",
                        titleColor: .black,
                        subtitleColor: .black,
                        titleStyle: .appSuperLargeTitleBold,
                        subtitleStyle: .appHeadline,
                        alignment: .center,
                        spacing: AppSpacing.regular
                    )
                    
                    HStack{
                        AppHeadline(
                            title: "Next task:",
                            subtitle: AppStorageService.shared.currentTaskTitle.isEmpty ? "Stay focused!" : AppStorageService.shared.currentTaskTitle,
                            titleColor: Color(UIColor.systemGray2),
                            subtitleColor: .black,
                            titleStyle: .appHeadline,
                            subtitleStyle: .appHeadline,
                            alignment: .leading,
                            spacing: AppSpacing.regular / 1.5
                        )
                        Spacer()
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.regular))
                    .frame(maxWidth: .infinity)
                    .shadow(
                        color: .gray.opacity(0.5),
                        radius: 2,
                        x: 0,
                        y: 2
                    )
                }
                    
                Spacer()
                
                if isDismiss {
                    // Jika sudah dismiss, beri kesempatan lihat api gosong lalu tekan tombol untuk kembali
                    AppButton(
                        action: {
                            isDismiss = false
                            AppStorageService.shared.isTakingBreak = false
                            AppStorageService.shared.isWorking = false
                            AppFamilyControlService.shared.stopShielding()
                        },
                        textButton: "Back to Home",
                        textColor: .white,
                        backgroundColor: Color.primaryColorPurple
                    )
                } else if !isTimesUp {
                    // Waktu masih berjalan, hanya bisa Continue Work (mengakhiri break lebih awal)
                    AppButton(
                        action: {
                            // Masih dihitung sebagai commit walau kembali kerja lebih awal
                            modelContext.insert(WorkSession(timerDuration: AppStorageService.shared.breakDurationSeconds, status: "commit"))
                            
                            AppStorageService.shared.isTakingBreak = false
                            AppFamilyControlService.shared.startShielding()
                        },
                        textButton: "Continue Work",
                        textColor: .white,
                        backgroundColor: Color.primaryColorPurple
                    )
                } else {
                    // Waktu habis, muncul penilaian: Dismiss atau Continue Work
                    HStack {
                        AppButton(
                            action: {
                                isDismiss = true
                                sendBurntFireNotification()
                                
                                // Simpan point Dismiss
                                modelContext.insert(WorkSession(timerDuration: AppStorageService.shared.breakDurationSeconds, status: "dismiss"))
                            },
                            textButton: "Dismiss",
                            textColor: .primaryColorPurple,
                            backgroundColor: Color.secondaryColorPurple
                        )
                        
                        AppButton(
                            action: {
                                // Simpan point Commit (sukses menyelesaikan istirahat)
                                modelContext.insert(WorkSession(timerDuration: AppStorageService.shared.breakDurationSeconds, status: "commit"))
                                
                                AppStorageService.shared.isTakingBreak = false
                                AppFamilyControlService.shared.startShielding()
                            },
                            textButton: "Continue Work",
                            textColor: .white,
                            backgroundColor: Color.primaryColorPurple
                        )
                    }
                }
   
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .padding(.bottom, 48)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 440)
            .background(Color.white)
            
        }
        .background(
            Image(
                 isDismiss  ? fireFramesDismiss[currentFrameIndex] : fireFrames[currentFrameIndex]
            )
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 400,)
                .clipped()
                .offset(y: -190)
                .onReceive(AnimationTimer) { _ in
                    currentFrameIndex = (currentFrameIndex + 1) % fireFrames.count
                }
            
        )
        
        .background(Color.primaryColorPurple)
        .ignoresSafeArea()
        .onAppear {
            updateTimer()
        }
        .onReceive(CountdownTimer) { _ in
            updateTimer()
        }
    }
    
    private func updateTimer() {
        let endDate = Date(timeIntervalSince1970: AppStorageService.shared.breakEndDate)
        let remain = endDate.timeIntervalSince(Date())
        
        if remain <= 0 {
            isTimesUp = true
            remainingTimeString = "00:00"
        } else {
            isTimesUp = false
            let minutes = Int(remain) / 60
            let seconds = Int(remain) % 60
            remainingTimeString = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private func sendBurntFireNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Api kamu gosong! 🥺"
        content.body = "Kamu menyerah di tengah jalan. Ayo kumpulkan semangat lagi!"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))
        UNUserNotificationCenter.current().add(request)
    }
    
    
    
}



#Preview {
    WorkBreakView()
}
