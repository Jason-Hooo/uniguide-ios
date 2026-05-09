//
//  predictAdmission.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/7.
//

import Foundation
import SwiftUI

// Percentile 與 Criteria 都指學測五標

enum GsatPercentile: String, CaseIterable, Comparable, Hashable {
    case top = "頂標"
    case high = "前標"
    case median = "均標"
    case low = "後標"
    case bottom = "底標"
    case none = "沒標"
    
    static let order: [GsatPercentile] = [.top, .high, .median, .low, .bottom, .none]
    
    static func < (lhs: GsatPercentile, rhs: GsatPercentile) -> Bool {
        // Comparable 必須要 Override 的方法，其他 > == 之類會自動實現
        // lhs = left-hand side
        return order.firstIndex(of: lhs)! > order.firstIndex(of: rhs)!
    }
}

enum EnglishListening: String, CaseIterable, Comparable {
    case a = "A級"
    case b = "B級"
    case c = "C級"
    case f = "F級"
    case none = "未報考"
    
    static let order: [EnglishListening] = [.a, .b, .c, .f, .none]
    
    static func < (lhs: EnglishListening, rhs: EnglishListening) -> Bool {
        // Comparable 必須要 Override 的方法，其他 > == 之類會自動實現
        // lhs = left-hand side
        return order.firstIndex(of: lhs)! > order.firstIndex(of: rhs)!
    }
}

enum ScoresInputType: String, CaseIterable {
    case level = "級分"
    case percent = "百分比"
    case current = "今年成績"
    
    var description: String {
        switch self {
        case .level: return "假設你 114 分科考如此的分數。"
        case .percent: return "各科排名百分比換算成 114 分科級分。"
        case .current: return "115 分科成績換算成 114 分科級分。"
        }
    }
}

func predictAdmission(
    analysisName: String,
    placementInputType: ScoresInputType,
    placementScores: [String: String],
    gsatInputType: ScoresInputType,
    gsatScores: [String: String],
    englishListening: EnglishListening
) -> PredictionResult {

    var convertedPlacementScores: [String: Double] = [:]
    
    // 分科：轉換成去年級分
    if placementInputType == .percent {
        convertedPlacementScores = convertThisPercentToLastLevel(
            isPlacement: true, originalPercents: placementScores
        )
    } else if placementInputType == .current {
        let thisPlacementPercents: [String: String] = convertThisLevelToThisPercent(
            isPlacement: true, originalLevels: placementScores
        )
        convertedPlacementScores =  convertThisPercentToLastLevel(
            isPlacement: true, originalPercents: thisPlacementPercents
        )
    } else {
        for (subject, level) in placementScores {
            convertedPlacementScores[subject] = Double(level)!
        }
    }
    
    var convertedGsatScores: [String: Double] = [:]
    
    // 學測：轉換成去年級分
    if gsatInputType == .percent {
        convertedGsatScores = convertThisPercentToLastLevel(isPlacement: false, originalPercents: gsatScores)
    } else if gsatInputType == .current {
        let thisGsatPercents: [String: String] = convertThisLevelToThisPercent(
            isPlacement: false, originalLevels: gsatScores
        )
        convertedGsatScores = convertThisPercentToLastLevel(
            isPlacement: false, originalPercents: thisGsatPercents
        )
    } else {
        for (subject, level) in gsatScores {
            convertedGsatScores[subject] = Double(level)!
        }
    }
    
    var convertedGsatPercentiles: [String: GsatPercentile] = [:]
    
    // 已轉換過的學測級分現在要換成當年五標
    convertedGsatPercentiles = convertThisGsatLevelToThisGsatPercentiles(convertedGsatScores: convertedGsatScores)

    // 開始迭代去年的每個校系
    var predictedPlacements: [PredictedPlacement] = [] // 要回傳的結果
    let lastPlacements = readBeforePlacementCSV(csvName: "113_placement")
    for placement in lastPlacements {
        if (placement.weighting.contains("術") || placement.generalScore.contains("-----")) { // 一定要先檢查這個
            // 懶得搞術科，遇到術科科系就跳過，也有可能校系爛到沒人要去，所以錄取分數是 -----
            continue
        }
        
        // 加上 englishListening 就是落點分析會用到的所有過去資料（已格式化）
        let (lastGsatSingleCriteria, lastGsatOrCriteria) = parseGsatSubjectPercentile(placement.subjectCriteria)
        let lastPlacementWeighting = parsePlacementSubjectWeighting(placement.weighting)
        
        if !placement.englishListening.isBlank && (englishListening == .none) {
            // 採英聽但使用者沒英聽成績
            continue
        }

        if !isUserSubjectsIncludeSchoolSubjects(convertedGsatPercentiles, lastGsatSingleCriteria) {
            // 使用者學測科目未包含採計學測科目（single）
            continue
        }
        
        if(!lastGsatOrCriteria.isEmpty) {
            // 使用者學測科目未包含採計學測科目（or）
            let array = Array(lastGsatOrCriteria)
            if convertedGsatPercentiles[array[0].key] == nil && convertedGsatPercentiles[array[1].key] == nil {
                continue
            }
        }
        
        let merged = convertedPlacementScores.merging(convertedGsatScores) {
            (current, new) in new
        }
        if !isUserSubjectsIncludeSchoolSubjects(merged, lastPlacementWeighting) {
            // 使用者分科科目＋學測科目未包含加權科目
            continue
        }

        // 上述根據使用者有考的科目，排除一定不可能上的校系，現在要做檢定科目及標準篩選
        var percentileAnalysisInfo: [(String, IsPassGsatPercentileKey)] = []
        let gsatSubjectsOrder = ["國文", "英文", "數學A", "數學B", "社會", "自然"]
        var isPassGsatPercentiles: Bool = true // 包含英聽
        var alreadyAnalysisGsatOrCriteria = false
        
        for subject in gsatSubjectsOrder {
            if let lastSinglePercentile = lastGsatSingleCriteria[subject] {
                if let userPercentile = convertedGsatPercentiles[subject] {
                    if userPercentile >= lastSinglePercentile {
                        percentileAnalysisInfo.append((userPercentile.rawValue, .yes))
                    } else {
                        isPassGsatPercentiles = false
                        percentileAnalysisInfo.append((userPercentile.rawValue, .no))
                    }
                }
            } else if let _ = lastGsatOrCriteria[subject], !alreadyAnalysisGsatOrCriteria {
                if lastGsatOrCriteria.count == 2 {
                    var isPassGsatOrPercentiles: Bool = false
                    for (orSubject, lastPercentile) in lastGsatOrCriteria {
                        if let userPercentile = convertedGsatPercentiles[orSubject] {
                            if userPercentile >= lastPercentile {
                                isPassGsatOrPercentiles = true
                                percentileAnalysisInfo.append((userPercentile.rawValue, .yes))
                            } else {
                                percentileAnalysisInfo.append((userPercentile.rawValue, .no))
                            }
                        } else { // 使用者未報考此科，但這是「或」的科目所以另一科有考就好
                            percentileAnalysisInfo.append(("未報考", .normal))
                        }
                    }
                    if !isPassGsatOrPercentiles {
                        isPassGsatPercentiles = false
                    }
                } else { print("發生錯誤：「或」校系數量不為 2!") }
                alreadyAnalysisGsatOrCriteria = true
            }
        }
        if !placement.englishListening.isEmpty {
            if englishListening < EnglishListening(rawValue: placement.englishListening)! {
                isPassGsatPercentiles = false
                percentileAnalysisInfo.append((englishListening.rawValue, .no))
            } else {
                percentileAnalysisInfo.append((englishListening.rawValue, .yes))
            }
        }
//        print(String(placement.id) + placement.subjectCriteria + placement.englishListening)
//        print(lastGsatSingleCriteria)
//        print(lastGsatOrCriteria)
//        print(convertedGsatPercentiles)
//        print(englishListening.rawValue)
//        print(isPassGsatPercentiles)
//        print()
        
        // 再來做加權分數比較以及計算機率
        var weightingAnalysisInfo: [WeightingAnalysisInfoKey: String] = [:]
        var probability: Double? = nil
        let totalWeighting: Double = lastPlacementWeighting.values.reduce(0, +)
        let lastWeightingScore: Double = Double(placement.generalScore)!
        
        var userWeightingScore: Double = 0.0
        for (subject, weighting) in lastPlacementWeighting {
            if let userScore = convertedPlacementScores[subject] {
                userWeightingScore += weighting * userScore
            } else if let userScore = convertedGsatScores[subject] {
                userWeightingScore += weighting * userScore
            } else {
                print("發生錯誤：使用者未輸入\(subject)的成績，但系統需要計算加權分數，前面沒攔截此校系")
            }
        }
        weightingAnalysisInfo[.generalScore] = String(
            format: "%.2f（單科平均：%.2f）",
            lastWeightingScore,
            lastWeightingScore / totalWeighting
        )
        weightingAnalysisInfo[.userScore] = String(
            format: "%.2f（單科平均：%.2f）",
            userWeightingScore,
            userWeightingScore / totalWeighting
        )
        weightingAnalysisInfo[.scoresDifference] = String(
            format: "%.2f",
            userWeightingScore - lastWeightingScore
        )
        if isPassGsatPercentiles {
            probability = calculateAdmissionProbability(
                userWeightingScore: userWeightingScore,
                lastWeightingScore: lastWeightingScore,
                maxWeightingScore: totalWeighting * 60
            )
        }
        
        // 最後加入新的 PredictedPlacement 到 predictedPlacements 陣列中
        predictedPlacements.append(
            PredictedPlacement(
                placement: placement,
                percentileAnalysisInfo: percentileAnalysisInfo,
                weightingAnalysisInfo: weightingAnalysisInfo,
                probability: probability
            )
        )
    }

    return PredictionResult(
        predictedPlacement: predictedPlacements,
        convertedPlacementScores: convertedPlacementScores,
        convertedGsatScores: convertedGsatScores,
        convertedGsatPercentiles: convertedGsatPercentiles
    )
}

private func isUserSubjectsIncludeSchoolSubjects<Key: Hashable, Value>(
    _ userDict: Dictionary<Key, Value>,
    _ schoolDict: Dictionary<Key, Value>
) -> Bool {
    let userKeySet = Set(userDict.keys)
    let schoolKeySet = Set(schoolDict.keys)

    return schoolKeySet.isSubset(of: userKeySet)
}
