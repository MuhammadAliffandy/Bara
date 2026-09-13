//
//  WorkSession.swift
//  bara
//
//  Created by Muhammad Aliffandy on 13/09/26.
//

import Foundation
import SwiftData

@Model
final class WorkSession {
    @Attribute(.unique) var id:String
    var timerDuration: TimeInterval
    var status: String
    var familyApps: [String]
    var createdAt: Date
    var updatedAt: Date
    
    
    init(
        id: String = UUID().uuidString,
        timerDuration: TimeInterval,
        status: String = "commit",
        familyApps: [String] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ){
        self.id = id
        self.timerDuration = timerDuration
        self.status = status
        self.familyApps = familyApps
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
