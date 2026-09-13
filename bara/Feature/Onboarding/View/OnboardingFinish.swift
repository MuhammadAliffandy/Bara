//
//  OnboardingFinish.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

struct OnboardingFinishView: View {
    
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        
        VStack(alignment:.center){
            Spacer()
        
            VStack(
                alignment: .center,
                spacing: AppSpacing.regular * 6,
            ){
                AppHeadline(
                    title: "You are all set!",
                    subtitle: "Our journey starts here. Let’s build better work and break habits, one return at a time",
                    titleStyle: .appLargeTitleV2,
                    alignment: .center,
                    textAlignment: .center,
                    spacing: AppSpacing.regular * 3
                
                )
                
                AppButton(
                    action: {
                        AppStorageService.shared.isOnboardingCompleted = true
                        
                        router.push(.home)
                    },
                        textButton: "Get Started",
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
            Image(AppImage.ImageFireHome)
                .resizable()
                .scaledToFill()
                .offset(y: -110)
            
        )
        .ignoresSafeArea()
    }
}


#Preview {
    OnboardingFinishView()
}
