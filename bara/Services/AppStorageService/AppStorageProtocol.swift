//
//  AppStorageProtocol.swift
//  bara
//
//  Created by Muhammad Aliffandy on 12/09/26.
//

import Foundation


protocol AppStorageServiceProtocol {
    var isOnboardingCompleted: Bool { get set }
    var isWorking: Bool { get set }
    var isTakingBreak: Bool { get set }
    var breakDurationSeconds: TimeInterval { get set }
    var currentTaskTitle: String { get set }
}
