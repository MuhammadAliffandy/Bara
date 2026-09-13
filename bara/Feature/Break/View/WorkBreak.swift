//
//  Break.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI
import Combine

struct WorkBreakView: View {
    
    let fireFrames = [
            AppImage.ImageFireBreak1,
            AppImage.ImageFireBreak2
        ]
        
  
        @State private var currentFrameIndex = 0

        let AnimationTimer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            VStack(alignment: .center, spacing:AppSpacing.regular * 3) {
                
                AppHeadline(
                    title: "13:30",
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
                        subtitle: "Creating Pitch Deck",
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
      
                
                Spacer()
                
                AppButton(
                    action: {
                        print("test")
                    },
                    textButton: "End Work",
                    textColor: .white,
                    backgroundColor: Color.primaryColorPurple
                )
                
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
        .ignoresSafeArea()
    }
}

#Preview {
    WorkBreakView()
}
