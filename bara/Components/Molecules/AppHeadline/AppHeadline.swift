//
//  AppHeadline.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

struct AppHeadline: View {
    
    var title: String = "title default"
    var subtitle: String = "subtitle default"
    var titleColor: Color = .black
    var subtitleColor: Color = Color.textColorSecondaryBlackGrey
    var titleStyle: Font = .appHeadline
    var subtitleStyle: Font = .appSubHeadline
    var alignment: HorizontalAlignment = .center
    var textAlignment: TextAlignment = .leading
    var spacing: CGFloat = AppSpacing.regular / 2

    
    var body: some View{
        VStack(
            alignment: alignment,
            spacing: spacing,
        ){
            AppText(
                text: title,
                textColor: titleColor,
                fontStyle: titleStyle,
                textAlignment: textAlignment,
            )
            AppText(
                text: subtitle,
                textColor: subtitleColor,
                fontStyle: subtitleStyle,
                textAlignment: textAlignment,
            )
        
        }
    }
}


#Preview {
    AppHeadline()
}
