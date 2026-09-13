//
//  OnboardingIdle.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

struct OnboardingIdleView: View {
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        
        VStack(alignment:.center){
            Spacer()
        
            VStack(
                alignment: .center,
                spacing: AppSpacing.regular * 6,
            ){
                AppHeadline(
                    title: "Welcome to Bara",
                    subtitle: "A calmer way to balance work and breaks. Stay focused, take breaks on your terms, and find your way back.",
                    titleStyle: .appLargeTitleV2,
                    alignment: .center,
                    textAlignment: .center,
                    spacing: AppSpacing.regular * 3
                
                )
                
                AppButton(
                    action: {
                        router.push(.onboardingPicktime)
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
            Image(AppImage.ImageFireHome)
                .resizable()
                .scaledToFill()
                .offset(y: -110)
            
        )
        .ignoresSafeArea()
    }
}


#Preview {
    OnboardingIdleView()
       
}
