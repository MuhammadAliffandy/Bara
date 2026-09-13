//
//  HomeViewModel.swift
//  bara
//
//  Created by Muhammad Aliffandy on 13/09/26.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class HomeViewModel {
    var todayCommitCount: Int = 0
    var todayDismissCount: Int = 0
    
    func updateRecap(from sessions: [WorkSession]){
        let commits = sessions.filter{
            $0.status == "commit"
        }.count
        
        let dismisses = sessions.filter{
            $0.status == "dismiss"
        }.count
        
        
        self.todayCommitCount = commits
        self.todayDismissCount = dismisses
        
    }
}
