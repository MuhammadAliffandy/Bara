//
//  TimeCountWidgetLiveActivity.swift
//  TimeCountWidget
//
//  Created by Muhammad Aliffandy on 12/09/26.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents // Diperlukan untuk tombol interaktif iOS 17

// === 1. UPDATE MODEL DATA ===
struct TimeCountWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var emoji: String
        var currentTask: String
    }

    // Ganti ClosedRange dengan 2 properti Date biasa
    var startDate: Date
    var endDate: Date
}

// === 2. UPDATE KUSTOMISASI WIDGET ===
struct TimeCountWidgetLiveActivity: Widget {
    


    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimeCountWidgetAttributes.self) { context in
            // Lock screen/banner UI (Biarkan standar atau kustom nanti)
            HStack() {
                
                Image("img_fire_widget")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.regular / 2))
                    
                    
           
                
                AppHeadline(
                    title: "Time is Up",
                    subtitle: "Creating Pitching Deck",
                    alignment: .leading,
                )
                
                Spacer()
                
                AppCircularCountdownView(
                    startDate: context.attributes.startDate,
                    endDate: context.attributes.endDate
                )
                
            }
            .padding()
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.white)

        } dynamicIsland: { context in
            DynamicIsland {
        
                DynamicIslandExpandedRegion(.leading) {
                    AppText(text: "Time is up!", textColor: .white)
                        .bold()
                        .padding(.leading, 8)
                }
                
          
                DynamicIslandExpandedRegion(.trailing) {
                    //none
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 6) {
                    
                        
                        AppText(
                            text: "It's time to do \(context.state.currentTask)!",
                            textColor: .white,
                            fontStyle: .appSubHeadline
                        )
                            .lineLimit(1)
                            .padding(.horizontal, 4)
                        
                        
                        // 2. Progress Bar & Icon Api
                        HStack(alignment: .center,spacing: 8) {
                            ProgressView(timerInterval: context.attributes.startDate...context.attributes.endDate, countsDown: true)
                                .tint(Color.primaryColorPurple)
                                .labelsHidden()
                            
                            
                            Image(systemName:AppIcon.FlameFill)
                                .font(.system(size: AppIconSize.regular / 1.4 ))
                                .foregroundColor(Color.secondaryColorPurple)
                               
                        }
                        .padding(.horizontal, 4)
                        
                        // 3. Tombol Aksi (Tinggi diperkecil)
                        HStack(spacing: 8) {
                            Link(destination: URL(string: "timecount://dismiss")!) {
                                Text("Dismiss")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(Color.primaryColorPurple)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 36) // Pakai height 36 agar tidak makan tempat
                                    .background(Color.secondaryColorPurple)
                                    .cornerRadius(10)
                            }
                            
                            Link(destination: URL(string: "timecount://continue")!) {
                                Text("Continue to work")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 36) // Pakai height 36
                                    .background(Color.primaryColorPurple)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 4)
                }
                
            } compactLeading: {
                Text(timerInterval: context.attributes.startDate...context.attributes.endDate, countsDown: true)
                    .multilineTextAlignment(.center)
                    .frame(width: 40)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
            
            } compactTrailing: {
                Image(systemName:AppIcon.FlameFill)
                    .font(.system(size: AppIconSize.regular / 1.4 ))
                    .foregroundColor(Color.secondaryColorPurple)
            } minimal: {
                Image(systemName:AppIcon.FlameFill)
                    .foregroundColor(Color.secondaryColorPurple)
            }
            .widgetURL(URL(string: "timecount://root"))

        }
    }
}

// === 3. UPDATE MOCK DATA UNTUK PREVIEW ===
extension TimeCountWidgetAttributes {
    fileprivate static var previewAttributes: TimeCountWidgetAttributes {
        let now = Date()
        let future = now.addingTimeInterval(300) // 5 menit dari sekarang
        return TimeCountWidgetAttributes(startDate: now, endDate: future)
    }
}

extension TimeCountWidgetAttributes.ContentState {
    fileprivate static var pitchDeckState: TimeCountWidgetAttributes.ContentState {
        TimeCountWidgetAttributes.ContentState(emoji: "📊", currentTask: "Creating Pitch Deck")
    }
}

// === 4. UPDATE KODE PREVIEW ===
// Preview Valid: Menampilkan Tampilan Kustom Baru
#Preview("Custom Dynamic Island", as: .dynamicIsland(.expanded), using: TimeCountWidgetAttributes.previewAttributes) {
   TimeCountWidgetLiveActivity()
} contentStates: {
    TimeCountWidgetAttributes.ContentState.pitchDeckState
}

#Preview("Compact ", as: .dynamicIsland(.compact), using: TimeCountWidgetAttributes.previewAttributes) {
   TimeCountWidgetLiveActivity()
} contentStates: {
    TimeCountWidgetAttributes.ContentState.pitchDeckState
}

#Preview("MINIMAL", as: .dynamicIsland(.minimal), using: TimeCountWidgetAttributes.previewAttributes) {
   TimeCountWidgetLiveActivity()
} contentStates: {
    TimeCountWidgetAttributes.ContentState.pitchDeckState
}

// PREVIEW KHUSUS LOCK SCREEN / BANNER NOTIFICATION
#Preview("Lock Screen Banner", as: .content, using: TimeCountWidgetAttributes.previewAttributes) {
   TimeCountWidgetLiveActivity()
} contentStates: {
    TimeCountWidgetAttributes.ContentState.pitchDeckState
}
