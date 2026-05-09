//
//  PredictedPlacement.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/11.
//

import Foundation

struct PredictedPlacement: Identifiable { // 預測的校系以及其相關分數比較
    
    var id: UUID = UUID()
    var placement: BeforePlacement
    var percentileAnalysisInfo: [(String, IsPassGsatPercentileKey)] // 要按照順序排列顯示
    var weightingAnalysisInfo: [WeightingAnalysisInfoKey: String] // 有 key 就好
    var probability: Double?
    
}

enum IsPassGsatPercentileKey {
    case yes
    case no
    case normal
}

enum WeightingAnalysisInfoKey {
    case generalScore
    case userScore
    case scoresDifference
}

 
