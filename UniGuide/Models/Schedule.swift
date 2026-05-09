//
//  Schedule.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/1/26.
//

import Foundation

struct Schedule: Codable, Identifiable {
    
    var id: String
    var title: String
    var startDate: Date
    var endDate: Date?
    var isPin: Bool = false
    
    init(title: String, startDate: Date, endDate: Date?, isPin: Bool) {
        self.id = UUID().uuidString
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.isPin = isPin
    }
    
    init(id: String, title: String, startDate: Date, endDate: Date?, isPin: Bool) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.isPin = isPin
    }
    
    func isDefaultSchedule() -> Bool {
        if let _ = Int(id) {
            return true
        } else {
            return false
        }
    }
    
}
