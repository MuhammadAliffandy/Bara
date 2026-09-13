//
//  OnboardingNotification.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

struct OnboardingNotificationView: View {
    
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        
        VStack(alignment:.center){
            Spacer()
        
            VStack(
                alignment: .center,
                spacing: AppSpacing.regular * 6,
            ){
                AppHeadline(
                    title: "Return on time",
                    subtitle: "Return to work on time to keep the fire burning and unlock badges along the way.",
                    titleStyle: .appLargeTitleV2,
                    alignment: .center,
                    textAlignment: .center,
                    spacing: AppSpacing.regular * 3
                
                )
                
                AppButton(
                    action: requestNotificationPermission,
                    textButton: "Next",
                    textColor: .white,
                    backgroundColor: Color.primaryColorPurple
                )
            }
            .padding()
            .padding(.top, 100)
            .padding(.bottom , AppPadding.regular * 2)
            .background(
                AppConcaveTopShape(dip: 90, cornerRadius: 0)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: -10)
            )
            
        }
        .background(
            Image(AppImage.ImageOnboardNotification)
            
                .scaledToFill()
                .offset(y: -50)
            
        )
        .ignoresSafeArea()
    }
    
    private func requestNotificationPermission() {
        Task {
            let center = UNUserNotificationCenter.current()
            do {

                let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
                
                DispatchQueue.main.async {
                    if granted {
                        router.push(.onboardingDynamic)
                    } else {
                        print("Notification Permission Denied. Stay on this view.")
                        // TODO: Alert to user to open settings
                    }
                }
            } catch {
                print("Error meminta izin notifikasi: \(error.localizedDescription)")
            }
        }
    }
    
}


#Preview {
    OnboardingNotificationView()
}
