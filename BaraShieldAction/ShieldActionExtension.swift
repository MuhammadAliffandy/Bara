//
//  ShieldActionExtension.swift
//  BaraShieldAction
//
//  Created by Muhammad Aliffandy on 13/09/26.
//

import ManagedSettings
import Foundation

class ShieldActionExtension: ShieldActionDelegate {
    
    // App Group untuk komunikasi dengan Main App
    private let defaults = UserDefaults(suiteName: "group.com.fandy.bara.shared")
    
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            // Kasih sinyal ke Main App kalau user butuh break
            defaults?.set(true, forKey: "pendingBreakRequest")
            
            // JURUS TELEPORTASI: Langsung buka aplikasi Bara!
            completionHandler(.openParentalControlsApp)
            
        case .secondaryButtonPressed:
            completionHandler(.close)
            
        @unknown default:
            completionHandler(.close)
        }
    }
    
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        defaults?.set(true, forKey: "pendingBreakRequest")
        completionHandler(.openParentalControlsApp)
    }
}
