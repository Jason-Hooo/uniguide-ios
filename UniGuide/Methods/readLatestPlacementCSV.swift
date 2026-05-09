//
//  readLatestPlacementCSV.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/5.
//

import Foundation
import SwiftUI
import SwiftCSV

func readLatestPlacementCSV(csvName: String) -> [LatestPlacement] {
    var latestPlacements = [LatestPlacement]()
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
        return latestPlacements
    }
    do {
        var csvString = try String(contentsOfFile: filePath, encoding: .utf8)
        csvString = csvString.replacingOccurrences(of: "<br>", with: "")
        let csv = try CSV<Named>(string: csvString)
        for (index, row) in csv.rows.enumerated() {
            let placement = LatestPlacement(
                id: index,
                schoolName: row["學校名稱"] ?? "錯誤",
                departmentName: row["系組名稱"] ?? "錯誤",
                subjectCriteriaChinese: row["學測檢定標準-國文"] ?? "錯誤",
                subjectCriteriaEnglish: row["學測檢定標準-英文"] ?? "錯誤",
                subjectCriteriaMathA: row["學測檢定標準-數學A"] ?? "錯誤",
                subjectCriteriaMathB: row["學測檢定標準-數學B"] ?? "錯誤",
                subjectCriteriaSocial: row["學測檢定標準-社會"] ?? "錯誤",
                subjectCriteriaScience: row["學測檢定標準-自然"] ?? "錯誤",
                subjectCriteriaEnglishListening: row["英聽檢定標準"] ?? "錯誤",
                weightingMathGay: row["採計科目及加權-數學甲"] ?? "錯誤",
                weightingMathChair: row["採計科目及加權-數學乙"] ?? "錯誤",
                weightingPhysics: row["採計科目及加權-物理"] ?? "錯誤",
                weightingChemistry: row["採計科目及加權-化學"] ?? "錯誤",
                weightingBiology: row["採計科目及加權-生物"] ?? "錯誤",
                weightingHistory: row["採計科目及加權-歷史"] ?? "錯誤",
                weightingGeography: row["採計科目及加權-地理"] ?? "錯誤",
                weightingCivics: row["採計科目及加權-公民"] ?? "錯誤",
                weightingChinese: row["採計科目及加權-國文"] ?? "錯誤",
                weightingEnglish: row["採計科目及加權-英文"] ?? "錯誤",
                weightingMathA: row["採計科目及加權-數學A"] ?? "錯誤",
                weightingMathB: row["採計科目及加權-數學B"] ?? "錯誤",
                weightingSocial: row["採計科目及加權-社會"] ?? "錯誤",
                weightingScience: row["採計科目及加權-自然"] ?? "錯誤",
                weightingPractical: row["採計科目及加權-術科"] ?? "錯誤",
                practicalKind: row["術科類別"] ?? "錯誤",
                tieSubject1: row["同分參酌-參酌1"] ?? "錯誤",
                tieSubject2: row["同分參酌-參酌2"] ?? "錯誤",
                tieSubject3: row["同分參酌-參酌3"] ?? "錯誤",
                tieSubject4: row["同分參酌-參酌4"] ?? "錯誤",
                tieSubject5: row["同分參酌-參酌5"] ?? "錯誤",
                illustration: row["選系說明"] ?? "錯誤"
            )
            latestPlacements.append(placement)
        }
    } catch {
        print("讀取 CSV 失敗: \(error)")
    }
    return latestPlacements
}
