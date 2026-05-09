//
//  convertThisLevelToThisPercent.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/8.
//

func convertThisLevelToThisPercent(
    isPlacement: Bool, originalLevels: [String: String]
) -> [String: String] {
    
    var convertedPercents: [String: String] = [:]
    
    if isPlacement {
        let thisPlacementAccumulation = readAccumulationCSV(csvName: "114PlacementAccumulation")
        for (subject, originalLevel) in originalLevels {
            guard let levels = thisPlacementAccumulation["級分"] else {
                
                return [:]
            }
            for (index, thisLevel) in levels.enumerated() {
                if Double(originalLevel)! == thisLevel {
                    convertedPercents[subject] = String(thisPlacementAccumulation[subject]![index])

                    break;
                }
            }
        }
    } else {
        let thisGsatAccumulation = readAccumulationCSV(csvName: "114GSATaccumulation")
        for (subject, originalLevel) in originalLevels {
            guard let levels = thisGsatAccumulation["級分"] else {
                
                return [:]
            }
            for (index, thisLevel) in levels.enumerated() {
                if Double(originalLevel)! == thisLevel {
                    convertedPercents[subject] = String(thisGsatAccumulation[subject]![index])

                    break;
                }
            }
        }
    }
    
    return convertedPercents
}
