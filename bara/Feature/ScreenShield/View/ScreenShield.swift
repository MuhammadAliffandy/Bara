//
//  ScreenShield.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

struct ScreenShieldView: View {
    @Environment(\.dismiss) var dismiss
    
    // Callback ketika user selesai setup di PlanReturnSheet
    var onConfirmBreak: (TimeInterval, String) -> Void
    
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Image(AppImage.ImageFireWork1)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                AppHeadline(
                    title: "Ready for a break?",
                    subtitle: "Set how long you’ll rest and what you’ll work on when you’re back",
                    titleStyle: .appLargeTitle,
                    alignment: .center,
                    spacing: AppSpacing.regular * 1.5
                )
            }
            
            Spacer()
            
            ZStack {
                Spacer()
                
                AppButton(
                    action: {
                        showSheet = true
                    },
                    textButton: "I wanna take a break",
                    textColor: .white,
                    backgroundColor: Color.primaryColorPurple
                )
            }
            .padding()
            
        }
        .background(Color.white) // Pastikan background tertutup penuh
        .sheet(isPresented: $showSheet) {
            PlanReturnSheet { duration, task in
                onConfirmBreak(duration, task)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(32)
        }
    }
}

#Preview {
    ScreenShieldView(onConfirmBreak: { _, _ in })
}
