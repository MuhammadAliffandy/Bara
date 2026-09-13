//
//  PlanReturnSheet.swift
//  bara
//
//  Created by Muhammad Aliffandy on 11/09/26.
//

import SwiftUI

struct PlanReturnSheet: View {
    @Environment(\.dismiss) var dismiss
    
    // Callback murni: panggil onConfirm(durasi, task) lalu caller yang putuskan logikanya
    var onConfirm: (TimeInterval, String) -> Void
    
    @State private var selectedMin = 0
    @State private var selectedSec = 0
    @State private var taskText = ""
    @State private var showAlert = false
    
    private var totalSeconds: TimeInterval {
        TimeInterval(selectedMin * 60 + selectedSec)
    }
    
    private var isValid: Bool { totalSeconds > 0 }

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
        
            HStack {
                AppIconCircleButton(
                    icon: AppIcon.XmarkIcon,
                    iconColor: .black,
                    iconSize: AppIconSize.regular / 1.3,
                    iconPadding: AppPadding.regular * 1.2,
                    backgroundColor: Color(UIColor.systemGray5),
                    action: { showAlert = true }
                )
                .alert("Leave setup?", isPresented: $showAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Leave", role: .destructive) { dismiss() }
                } message: {
                    Text("Your break won't start.")
                }
                
                Spacer()
                
                AppText(text: "Plan Your Break", textColor: .black, fontStyle: .appHeadlineBold)
                
                Spacer()
                
                AppIconCircleButton(
                    icon: AppIcon.ArrowUpIcon,
                    iconColor: .white,
                    iconSize: AppIconSize.regular / 1.3,
                    iconPadding: AppPadding.regular * 1.2,
                    backgroundColor: isValid ? Color.primaryColorPurple : Color.gray.opacity(0.4),
                    action: {
                        guard isValid else { return }
                        onConfirm(totalSeconds, taskText)
                        dismiss()
                    }
                )
            }
            .padding(.top, 16)
            
            // Set Break Time
            VStack(alignment: .leading, spacing: 12) {
                AppText(text: "Set Break Time", textColor: .black, fontStyle: .appHeadlineBold)
                
                HStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Picker("Min", selection: $selectedMin) {
                            ForEach(0..<60) { i in
                                Text(String(format: "%02d", i)).font(.system(size: 32, weight: .bold)).tag(i)
                            }
                        }
                        .pickerStyle(.wheel).frame(width: 80, height: 120).clipped()
                        AppText(text: "min", textColor: .black, fontStyle: .appSubHeadlineMedium).padding(.top, 8)
                    }
                    
                    Text(":").font(.system(size: 40, weight: .bold)).padding(.horizontal, 16).padding(.bottom, 6)
                    
                    HStack(spacing: 2) {
                        Picker("Sec", selection: $selectedSec) {
                            ForEach(0..<60) { i in
                                Text(String(format: "%02d", i)).font(.system(size: 32, weight: .bold)).tag(i)
                            }
                        }
                        .pickerStyle(.wheel).frame(width: 80, height: 120).clipped()
                        AppText(text: "sec", textColor: .black, fontStyle: .appSubHeadlineMedium).padding(.top, 8)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(16)
            }
            
            // Next Task
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    AppText(text: "Next Task", textColor: .black, fontStyle: .appHeadlineBold)
                    Spacer()
                    Text("\(taskText.count)/30").font(.caption)
                        .foregroundColor(taskText.count >= 30 ? .red : .gray)
                }
                
                HStack {
                    Text("Your Next task").foregroundColor(.black)
                    Spacer()
                    TextField("Do something", text: $taskText)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.gray)
                        .onChange(of: taskText) { _, newValue in
                            if newValue.count > 30 { taskText = String(newValue.prefix(30)) }
                        }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(16)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .onAppear {
            let defaultDuration = Int(AppStorageService.shared.breakDurationSeconds)
            selectedMin = defaultDuration / 60
            selectedSec = defaultDuration % 60
        }
    }
}

struct PlanReturnSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack { Color.black.ignoresSafeArea() }
        .sheet(isPresented: .constant(true)) {
            PlanReturnSheet(onConfirm: { _, _ in })
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(32)
        }
    }
}
