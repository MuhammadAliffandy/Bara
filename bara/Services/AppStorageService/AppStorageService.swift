//
//  AppStorageService.swift
//  bara
//
//  Created by Muhammad Aliffandy on 12/09/26.
//

import Foundation

final class AppStorageService: AppStorageServiceProtocol {
    
    // App Group suite name — harus sama persis dengan yang didaftarkan di Xcode
    static let appGroupSuite = "group.com.fandy.bara.shared"
    
    //singleton patter to self class instance
    static let shared = AppStorageService()
    
    //get user default for session definition
    private let userDefaults: UserDefaults
    
    private enum Keys {
        static let isOnboardingCompleted = "isOnboardingCompleted"
        static let isWorking = "isWorking"
        static let isTakingBreak = "isTakingBreak"
        static let isBreakDismissed = "isBreakDismissed"
        static let breakEndDate = "breakEndDate"
        static let breakDurationSeconds = "breakDurationSeconds"
        static let currentTaskTitle = "currentTaskTitle"
        static let pendingBreakRequest = "pendingBreakRequest"
    }
    
    // Dependency Injection dari init, defaultnya pakai App Group
    init(userDefaults: UserDefaults = UserDefaults(suiteName: AppStorageService.appGroupSuite) ?? .standard) {
        self.userDefaults = userDefaults
    }
    
    var isOnboardingCompleted: Bool {
        get { userDefaults.bool(forKey: Keys.isOnboardingCompleted) }
        set { userDefaults.set(newValue, forKey: Keys.isOnboardingCompleted) }
    }
    
    var isWorking: Bool {
        get { userDefaults.bool(forKey: Keys.isWorking) }
        set { userDefaults.set(newValue, forKey: Keys.isWorking) }
    }
    
    var isTakingBreak: Bool {
        get { userDefaults.bool(forKey: Keys.isTakingBreak) }
        set { userDefaults.set(newValue, forKey: Keys.isTakingBreak) }
    }
    
    var isBreakDismissed: Bool {
        get { userDefaults.bool(forKey: Keys.isBreakDismissed) }
        set { userDefaults.set(newValue, forKey: Keys.isBreakDismissed) }
    }
    
    var breakEndDate: Double {
        get { userDefaults.double(forKey: Keys.breakEndDate) }
        set { userDefaults.set(newValue, forKey: Keys.breakEndDate) }
    }
    
    // Durasi dalam detik. Default: 15 menit (900 detik)
    var breakDurationSeconds: TimeInterval {
        get {
            let val = userDefaults.double(forKey: Keys.breakDurationSeconds)
            return val == 0 ? 900 : val
        }
        set { userDefaults.set(newValue, forKey: Keys.breakDurationSeconds) }
    }
    
    // Judul task yang sedang dikerjakan (ditampilkan di Dynamic Island)
    var currentTaskTitle: String {
        get { userDefaults.string(forKey: Keys.currentTaskTitle) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.currentTaskTitle) }
    }
    
    // Flag penanda bahwa Shield telah ditekan dan user mau break
    var pendingBreakRequest: Bool {
        get { userDefaults.bool(forKey: Keys.pendingBreakRequest) }
        set { userDefaults.set(newValue, forKey: Keys.pendingBreakRequest) }
    }
}
