//
//  AppWrapButton.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

struct AppWrapButton<Content: View>:View{
    
    var action: () -> Void
    @ViewBuilder let component: Content
    
    
    var body: some View{
        Button(
            action: action
        ){
            component
        }
        
    }
    
}




#Preview{
    HStack{
        AppWrapButton(
            action: {} ,
    
        ){
            
            AppText()
                .bold()
        }
        .padding(.horizontal, AppPadding.medium * 2)
        .padding(.vertical,AppPadding.regular / 1.2 )
        .background(Color.primaryColorPurple)
        .clipShape(RoundedRectangle(cornerRadius: .infinity))
      
    }
    .frame(width: .infinity)
    
}
