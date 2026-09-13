//
//  OnboardingScreenTime.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//
import SwiftUI
import FamilyControls

struct OnboardingScreenTimeView: View {
    
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        
        VStack(alignment:.center){
            Spacer()
        
            VStack(
                alignment: .center,
                spacing: AppSpacing.regular * 6,
            ){
                AppHeadline(
                    title: "Last thing before you start",
                    subtitle: "We'll need notifications to call you back, and app access to help you land your catch on time. All private, all on-device.",
                    titleStyle: .appLargeTitleV2,
                    alignment: .center,
                    textAlignment: .center,
                    spacing: AppSpacing.regular * 3
                
                )
                
                AppButton(
                    action: {
                        requestScreenTimePermission()
                    },
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
            Image(AppImage.ImageOnboardFamily)
            
                .scaledToFill()
                .offset(y: -150)
            
        )
        .ignoresSafeArea()
    }
    
    
    private func requestScreenTimePermission() {
        Task {
            await AppFamilyControlService.shared.requestAuthorization()
            
            // Hanya lanjut jika user mengizinkan (authorized)
            DispatchQueue.main.async {
                if AppFamilyControlService.shared.isAuthorized {
                    router.push(.onboardingDistraction)
                } else {
                    print("Screen Time Permission Denied. Stay on this view.")
                    // TODO: Jika user menolak, bisa ditambahkan alert untuk mengarahkan ke Setting
                }
            }
        }
    }
    
    
}


#Preview {
    OnboardingScreenTimeView()
}
