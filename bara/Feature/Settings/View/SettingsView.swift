//
//  SettingsView.swift
//  bara
//
//  Created by Antigravity on 13/09/26.
//

import SwiftUI
import FamilyControls

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    // Binding to our singleton services
    @Bindable private var familyService = AppFamilyControlService.shared
    @State private var isPickerPresented = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Apps to Monitor"), footer: Text("Bara will silently watch these apps and show a Dynamic Island reminder when you've been using them too long.")) {
                    Button(action: {
                        isPickerPresented = true
                    }) {
                        HStack {
                            Text("Select Apps")
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(familyService.selectionToBlock.applicationTokens.count) selected")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("About"), footer: Text("Bara focuses on micro-friction and gentle reminders to keep you productive without forceful blocking.")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                }
            }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
                .familyActivityPicker(
                    isPresented: $isPickerPresented,
                    selection: $familyService.selectionToBlock
                )
            }
        }
    }

#Preview {
    SettingsView()
}
