//
//  covertToLastPlacementScore.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/5.
//

import Foundation
import SwiftUI

func convertThisPercentToLastLevel(
    isPlacement: Bool, originalPercents: [String: String]
) -> [String: Double] {
    
    var convertedScores: [String: Double] = [:]
    
    if isPlacement {
        let lastPlacementAccumulation = readAccumulationCSV(csvName: "113PlacementAccumulation")
        for (subject, originalPercent) in originalPercents {
            if (subject == "數學乙") { continue } // 114 比 113 多考了數乙
            guard let accumulation = lastPlacementAccumulation[subject] else {
                
                return [:]
            }
            for (index, lastPercent) in accumulation.enumerated() {
                if Double(originalPercent)! <= lastPercent {
                    convertedScores[subject] = lastPlacementAccumulation["級分"]![index]

                    break;
                }
            }
        }
    } else {
        let lastGsatAccumulation = readAccumulationCSV(csvName: "113GSATaccumulation")
        for (subject, originalPercent) in originalPercents {
            guard let accumulation = lastGsatAccumulation[subject] else {
                
                return [:]
            }
            for (index, lastPercent) in accumulation.enumerated() {
                if Double(originalPercent)! <= lastPercent {
                    convertedScores[subject] = lastGsatAccumulation["級分"]![index]
                    
                    break;
                }
            }
        }
    }
    
    return convertedScores
}
