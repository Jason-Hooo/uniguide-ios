//
//  convertThisGsatLevelToThisGsatPercentiles.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/8.
//

import Foundation
import SwiftUI

func convertThisGsatLevelToThisGsatPercentiles(convertedGsatScores: [String: Double]
) -> [String: GsatPercentile] {
    var convertedGsatPercentiles: [String: GsatPercentile] = [:]
    
    // lastGsatPercentiles 已去掉五標那一欄
    let lastGsatPercentiles = readPercentileCSV(csvName: "113GSATpercentile")
    for (subject, convertedLevel) in convertedGsatScores {
        let gsatLevel15System = Double(ceil(convertedLevel / 4.0))
        var matched: Bool = false
        
        for (index, level) in lastGsatPercentiles[subject]!.enumerated() {
            if gsatLevel15System >= level {
                convertedGsatPercentiles[subject] = GsatPercentile.order[index]
                matched = true
                
                break;
            }
        }
        if !matched {
            convertedGsatPercentiles[subject] = GsatPercentile.none
        }
    }

    return convertedGsatPercentiles
}
