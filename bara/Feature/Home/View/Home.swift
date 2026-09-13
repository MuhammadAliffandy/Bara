//
//  Home.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

struct HomeView: View{
    var body: some View{
        VStack(spacing : AppSpacing.regular ){
            
            Spacer()
            
            AppButton(
                action: {
                    print("test")
                },
                    textButton: "Start Work",
                    textColor: .white,
                    backgroundColor: Color.primaryColorPurple
            )
            
            HStack(alignment : .center){
                
                Image(systemName: AppIcon.MedalFillIcon)
                    .foregroundStyle(Color.textColorPrimaryOrange)
                    .font(.system(size: AppIconSize.regular * 2.5))
                
                Spacer()
                
                VStack(alignment: .leading, spacing: AppSpacing.regular){
                    AppText(
                        text: "Today's Recap",
                        textColor: .black,
                        fontStyle: .appTitle
                    )
                    
                    HStack{
                        HStack{
                            AppText(
                                text: "3",
                                textColor: .primaryColorPurple,
                                fontStyle: .appTitle
                            )
                            AppText(
                                text: "Commit",
                                textColor: .primaryColorPurple,
                                fontStyle: .appHeadline
                            )
                        }
                        
                        HStack{
                            AppText(
                                text: "7",
                                textColor: .textColorPrimaryOrange,
                                fontStyle: .appTitle
                            )
                            AppText(
                                text: "Dismiss",
                                textColor: .textColorPrimaryOrange,
                                fontStyle: .appHeadline
                            )
                        }
                        
                    }
                    
                    AppText(
                        text: "See full summary",
                        textColor: .textColorSecondaryBlackGrey,
                        fontStyle: .appCaption
                    )
                    
                }
                
                Spacer()
                
                Image(systemName: AppIcon.ChevronRightIcon)
                    .foregroundStyle(Color.primaryColorPurple)
                    .font(.system(size: AppIconSize.regular))
                
                    
            }
            .padding(AppSpacing.medium * 1.5)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.regular))
            
            
            
            
        }
        .padding(AppPadding.medium)
        .padding(.bottom, AppPadding.medium * 2)
        .background(
            Image(AppImage.ImageFireHome)
                .resizable()
                .scaledToFill()
        )
        .ignoresSafeArea()
    }
}

#Preview{
    HomeView()
}
