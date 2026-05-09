//
//  calculateAdmissionProbability.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/12.
//

import Foundation

func calculateAdmissionProbability(
    userWeightingScore: Double,
    lastWeightingScore: Double,
    maxWeightingScore: Double,
    slope: Double = 15.0,
    midpoint: Double = 0.0
) -> Double {
    guard maxWeightingScore > 0 else { return 0.0 }
    
    // 分差百分比（例如 +0.02 表示比 last 多 2% 滿分）
    let diffPercent = (userWeightingScore - lastWeightingScore) / maxWeightingScore
    
    // Logistic function
    let exponent = -slope * (diffPercent - midpoint)
    let probability = 1.0 / (1.0 + exp(exponent))
    
    return 100 * probability
}
