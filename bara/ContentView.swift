import SwiftUI

struct ContentView: View {
    
    @StateObject private var router = AppRouter()
    
    @AppStorage("isOnboardingCompleted", store: UserDefaults(suiteName: "group.com.fandy.bara.shared")) private var isOnboardingCompleted = false
    @AppStorage("isWorking", store: UserDefaults(suiteName: "group.com.fandy.bara.shared")) private var isWorking = false
    @AppStorage("isTakingBreak", store: UserDefaults(suiteName: "group.com.fandy.bara.shared")) private var isTakingBreak = false
    
    var body: some View {
        NavigationStack(path: $router.path) {
                Group {
                    if isOnboardingCompleted {
                        if isTakingBreak {
                            WorkBreakView()
                                .transition(.opacity)
                        } else if isWorking {
                            WorkStartView()
                                .transition(.opacity)
                        } else {
                            HomeView()
                                .transition(.opacity)
                        }
                        
                    } else {
                        OnboardingIdleView()
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: isTakingBreak)
                .animation(.easeInOut(duration: 0.5), value: isWorking)
                .navigationDestination(for: AppRoute.self) {
                    route in
                    switch route {
                    case .workStart:
                        WorkStartView()
                    case .workBreak:
                        WorkBreakView()
                    case .screenShield:
                        ScreenShieldView(onConfirmBreak: { _, _ in })
                    case .onboardingIdle:
                        OnboardingIdleView()
                    case .onboardingDynamic:
                        OnboardingDynamicIslandView()
                    case .onboardingFinish:
                        OnboardingFinishView()
                    case .onboardingPicktime:
                        OnboardingPickTimeView()
                    case .onboardingDistraction:
                        OnboardingDistractionView()
                    case .onboardingNotification:
                        OnboardingNotificationView()
                    case .onboardingScreenTime:
                        OnboardingScreenTimeView()
                    case .home:
                        HomeView()
                    }
                }
        }
        .environmentObject(router)
        .onChange(of: isTakingBreak) { _, newValue in
            // Jika masuk mode break, bersihkan tumpukan halaman agar kembali ke Root (WorkBreakView)
            if newValue {
                router.popToRoot()
            }
        }
        .onChange(of: isWorking) { _, newValue in
            // Jika berhenti kerja (Dismiss/End), bersihkan tumpukan halaman agar kembali ke Root (HomeView)
            if !newValue {
                router.popToRoot()
            }
        }
    }
}

#Preview {
    ContentView()
}
