//
//  OnboardingDistraction.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI
import FamilyControls

struct OnboardingDistractionView: View {
    
    
    @State private var isPickerPresented = false
        
    @Bindable private var familyService = AppFamilyControlService.shared
    @EnvironmentObject private var router: AppRouter
    
    var body: some View {
        
        VStack(alignment:.center){
            Spacer()
        
            VStack(
                alignment: .center,
                spacing: AppSpacing.regular * 6,
            ){
                AppHeadline(
                    title: "Know your distractions",
                    subtitle: "Choose the apps that tend to pull you of course during your breaks.",
                    titleStyle: .appLargeTitleV2,
                    alignment: .center,
                    textAlignment: .center,
                    spacing: AppSpacing.regular * 3
                
                )
                
                AppButton(
                    action: {
                        isPickerPresented = true
                    },
                        textButton: "Add Apps",
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
            Image(AppImage.ImageOnboardDistract)
            
                .scaledToFill()
                .offset(y: -150)
            
        )
        .ignoresSafeArea()
        .familyActivityPicker(
            isPresented: $isPickerPresented,
            selection: $familyService.selectionToBlock
        )

        .onChange(of: familyService.selectionToBlock) { newSelection , oldSelection in
            print("User memilih \(newSelection.applicationTokens.count) aplikasi")
            router.push(.onboardingFinish)
        }
    }
    
 
    
    
    
}


#Preview {
    OnboardingDistractionView()
}
