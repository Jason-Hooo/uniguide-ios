//
//  SearchHistory.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/3/8.
//

import Foundation
import SwiftData

@Model
class SearchHistory: Identifiable {
    
    var id: Int
    var years: Year
    var timestamp: Date
    
    init(id: Int, years: Year, timestamp: Date) {
        self.id = id
        self.years = years
        self.timestamp = timestamp
    }
    
}

enum Year: String, CaseIterable, Codable {
    case latest = "114"
    case before1 = "113"
    case before2 = "112"
}
