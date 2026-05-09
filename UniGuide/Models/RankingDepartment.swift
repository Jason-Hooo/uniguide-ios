//
//  RankingDepartment.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/3/10.
//

import Foundation

struct RankingDepartment: Codable, Identifiable {
    
    var id: Int
    var visitCount: Int
    var favoriteCount: Int
    
    init(id: Int, visitCount: Int, favoriteCount: Int) {
        self.id = id
        self.visitCount = visitCount
        self.favoriteCount = favoriteCount
    }
    
}
