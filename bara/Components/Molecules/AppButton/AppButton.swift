//
//  AppButton.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

struct AppButton: View{
    
    var action: () -> Void
    var textButton: String = "Text Default"
    var textColor: Color = .white
    var backgroundColor: Color = Color.black
    
    
    var body: some View{
        AppWrapButton(
            action: action
        )
            {
                Spacer()
                
                AppText(
                    text: textButton,
                    textColor: textColor,
                    fontStyle: .appHeadline
                )
                .bold()
                
                Spacer()
            }
        
            .buttonStyle(.borderedProminent)
            .tint(backgroundColor)
            .controlSize(.large)
            .buttonBorderShape(.roundedRectangle(radius: AppRadius.regular / 1.2))
            
    }
}


#Preview {
    AppButton(
        action: {
            print("test")
        },
              textButton: "Default",
              textColor: .white,
              backgroundColor: .black
    )
}
