//
//  PredictionResult.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/14.
//

import Foundation

struct PredictionResult: Identifiable { // 落點分析的結果，包含 [PredictedPlacement]
    
    var id: UUID = UUID()
    var predictedPlacement: [PredictedPlacement]
    var convertedPlacementScores: [String: Double]
    var convertedGsatScores: [String: Double]
    var convertedGsatPercentiles: [String: GsatPercentile]
    
}
