//
//  Font+Extension.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

extension Font {
    static let appSuperLargeTitleBold = Font.system(size: 62, weight: .bold)
    static let appLargeTitle = Font.largeTitle.weight(.bold)
    static let appLargeTitleV2 = Font.system(size: 28, weight: .bold)
    static let appTitle = Font.title2.weight(.bold)
    static let appHeadline = Font.body.weight(.regular)
    static let appHeadlineBold = Font.headline.weight(.bold)
    static let appSubHeadline = Font.subheadline.weight(.regular)
    static let appSubHeadlineMedium = Font.subheadline.weight(.medium)
    static let appCaption = Font.caption.weight(.regular)
}
