//
//  AppFamilyControlService.swift
//  bara
//
//  Created by Muhammad Aliffandy on 13/09/26.
//

import SwiftUI
import Foundation
import FamilyControls
import ManagedSettings

@Observable
final class AppFamilyControlService {
    static let shared = AppFamilyControlService()
    
    var isAuthorized: Bool = false
    
    private let selectionKey = "SavedFamilySelection"
    
    var selectionToBlock = FamilyActivitySelection() {
        didSet { saveSelection() }
    }
    
    let store = ManagedSettingsStore()
    
    init() {
        loadSelection()
    }
    
    // MARK: - Persistence
    private func saveSelection() {
        if let data = try? JSONEncoder().encode(selectionToBlock) {
            UserDefaults.standard.set(data, forKey: selectionKey)
        }
    }
    
    private func loadSelection() {
        if let data = UserDefaults.standard.data(forKey: selectionKey),
           let saved = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
            self.selectionToBlock = saved
        }
    }
    
    // MARK: - Authorization
    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            await MainActor.run {
                self.isAuthorized = AuthorizationCenter.shared.authorizationStatus == .approved
            }
        } catch {
            
        }
    }
    
    // MARK: - Shielding (Micro Friction Gate)
    
    func startShielding() {
        let apps = selectionToBlock.applicationTokens
        let categories = selectionToBlock.categoryTokens
        store.shield.applications = apps.isEmpty ? nil : apps
        if !categories.isEmpty {
            store.shield.applicationCategories = .specific(categories, except: Set())
        }

    }
    
    func stopShielding() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil

    }
}
