//
//  AppText.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

struct AppText: View{
    
    var text: String = "Text Default"
    var textColor: Color = .white
    var fontStyle: Font = .appHeadline
    var textAlignment: TextAlignment = .leading
    
    
    var body: some View{
            Text(text)
            .foregroundStyle(textColor)
            .font(fontStyle)
            .multilineTextAlignment(textAlignment)
    }
}


#Preview {
    AppText()
        .bold()
}
