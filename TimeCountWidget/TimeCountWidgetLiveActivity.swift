//
//  TimeCountWidgetLiveActivity.swift
//  TimeCountWidget
//
//  Created by Muhammad Aliffandy on 12/09/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimeCountWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TimeCountWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimeCountWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TimeCountWidgetAttributes {
    fileprivate static var preview: TimeCountWidgetAttributes {
        TimeCountWidgetAttributes(name: "World")
    }
}

extension TimeCountWidgetAttributes.ContentState {
    fileprivate static var smiley: TimeCountWidgetAttributes.ContentState {
        TimeCountWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TimeCountWidgetAttributes.ContentState {
         TimeCountWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TimeCountWidgetAttributes.preview) {
   TimeCountWidgetLiveActivity()
} contentStates: {
    TimeCountWidgetAttributes.ContentState.smiley
    TimeCountWidgetAttributes.ContentState.starEyes
}
