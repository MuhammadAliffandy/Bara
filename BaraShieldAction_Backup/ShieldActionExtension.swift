//
//  ShieldActionExtension.swift
//  BaraShieldAction
//

import ManagedSettings

class ShieldActionExtension: ShieldActionDelegate {
    
    // Gunakan UserDefaults dengan suiteName AppGroup yang sama dengan Main App
    private let defaults = UserDefaults(suiteName: "group.com.fandy.bara.shared")
    
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            // Tandai bahwa user mau ambil break, agar saat Main App kebuka, otomatis buka PlanReturnSheet
            defaults?.set(true, forKey: "pendingBreakRequest")
            
            // AJAIB: Ini yang bikin iOS otomatis membuang Shield dan pindah ke Bara App!
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
