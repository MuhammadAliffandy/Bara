import SwiftUI
import SwiftData
import Combine
import UserNotifications

struct WorkStartView: View {
    
    let fireFrames = [
        AppImage.ImageFireWork1,
        AppImage.ImageFireWork2
    ]
    
    @EnvironmentObject private var router: AppRouter
    
    @State private var dismissShowAlert = false
    @State private var currentFrameIndex = 0
    
    let AnimationTimer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 24) {
                
                AppHeadline(
                    title: "Do your task!!!! <3",
                    subtitle: "Stay focused on your task. If your attention drifts, we'll help you find your way back.",
                    titleStyle: .appLargeTitle,
                    alignment: .leading,
                    spacing: AppSpacing.regular * 2
                )
                
                
                AppText(
                    text: "Close this app, n enjoy ur work!",
                    textColor: Color.textColorSecondaryBlackGrey,
                    fontStyle: .appSubHeadline,
                    
                )
                
                Spacer()
                
                AppButton(
                    action: {
                        dismissShowAlert = true
                    },
                    textButton: "End Work",
                    textColor: .white,
                    backgroundColor: Color.primaryColorPurple
                )
                .alert("End your work session?", isPresented: $dismissShowAlert) {
                    
                    Button("Cancel", role: .cancel) {
                        
                    }
                    
                    Button("End Work", role: .none) {
                        endWorkAction()
                    }
                    
                } message: {
                    Text("Your current work session will end ")
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
            Image(fireFrames[currentFrameIndex])
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
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
    
    func endWorkAction(){
        AppStorageService.shared.isWorking = false
        
        // Hentikan shield dan batalkan semua notifikasi break yang tertunda
        AppFamilyControlService.shared.stopShielding()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["BaraBreakEnd"])
    }
    
}

#Preview {
    WorkStartView()
}
