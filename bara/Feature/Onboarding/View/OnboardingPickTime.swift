//
//  OnboardingPickTime.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

//
//  OnboardingIdle.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

struct OnboardingPickTimeView: View {
    
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        
        VStack(alignment:.center){
            Spacer()
        
            VStack(
                alignment: .center,
                spacing: AppSpacing.regular * 6,
            ){
                AppHeadline(
                    title: "Set your break freely!",
                    subtitle: "Take a break whenever you need. Set how long you’ll be away and what you’ll work on when you’re back.",
                    titleStyle: .appLargeTitleV2,
                    alignment: .center,
                    textAlignment: .center,
                    spacing: AppSpacing.regular * 3
                
                )
                
                AppButton(
                    action: {
                        router.push(.onboardingNotification)
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
            Image(AppImage.ImageOnboardHP)
            
                .scaledToFill()
                .offset(y: -50)
            
        )
        .ignoresSafeArea()
    }
}


#Preview {
    OnboardingPickTimeView()
}
