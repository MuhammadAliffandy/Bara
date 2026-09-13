//
//  AppIconCircleButton.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI


struct AppIconCircleButton: View {

    var icon: String = "xmark"
    var iconColor: Color = .white
    var iconSize: CGFloat = AppIconSize.regular * 1.2
    var iconPadding: CGFloat = AppPadding.regular / 2
    var backgroundColor: Color = .blue
    var action: () -> Void
    
    
    
    var body: some View {
        AppWrapButton(action: action){
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.system(size: iconSize))
                .padding(iconPadding)

       
        }
        .buttonStyle(.borderedProminent)
        .tint(backgroundColor)
        .buttonBorderShape(.circle)
      
    }
}


#Preview {
    AppIconCircleButton(
        icon: "xmark",
        action: {
            
        }
    )
    
    AppIconCircleButton(
        icon:"xmark",
        backgroundColor: .gray,
        action: {
            
        }
    )
    .glassEffect()
    .bold()
    
}
