//
//  TimeCountWidgetBundle.swift
//  TimeCountWidget
//
//  Created by Muhammad Aliffandy on 12/09/26.
//

import WidgetKit
import SwiftUI

@main
struct TimeCountWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimeCountWidget()
        TimeCountWidgetControl()
        TimeCountWidgetLiveActivity()
    }
}
