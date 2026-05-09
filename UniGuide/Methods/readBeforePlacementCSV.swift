//
//  readBeforePlacementCSV.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/5.
//

import Foundation
import SwiftUI
import SwiftCSV

func readBeforePlacementCSV(csvName: String) -> [BeforePlacement] {
    var beforePlacements = [BeforePlacement]()
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
        return beforePlacements
    }
    do {
        let csv = try CSV<Named>(url: URL(fileURLWithPath: filePath))
        for (index, row) in csv.rows.enumerated()  {
            beforePlacements.append(BeforePlacement(
                id: index,
                schoolName: row["校名"] ?? "錯誤",
                departmentName: row["系組名"] ?? "錯誤",
                weighting: row["採計及加權"] ?? "錯誤",
                generalScore: row["普通生錄取分數"] ?? "錯誤",
                generalTieScore: row["普通生同分參酌"] ?? "錯誤",
                indigenousScore: row["原住民錄取分數"] ?? "錯誤",
                veteranScore: row["退伍軍人錄取分數"] ?? "錯誤",
                overseasStudentScore: row["僑生錄取分數"] ?? "錯誤",
                mongolianScore: row["蒙藏生錄取分數"] ?? "錯誤",
                overseasChildScore: row["派外子女錄取分數"] ?? "錯誤",
                subjectCriteria: row["檢定科目及標準-學科能力測驗"] ?? "錯誤",
                englishListening: row["檢定科目及標準-英聽"] ?? "錯誤",
                tieSubjectOrder: row["同分參酌順序"] ?? "錯誤",
                approvedQuota: row["核定名額"] ?? "錯誤",
                returnQuota: row["回流名額"] ?? "錯誤",
                admissionQuota: row["招生名額"] ?? "錯誤",
                admittedMale: row["錄取人數-男"] ?? "錯誤",
                admittedFemale: row["錄取人數-女"] ?? "錯誤",
                extraMale: row["外加錄取-男"] ?? "錯誤",
                extraFemale: row["外加錄取-女"] ?? "錯誤",
                totalAdmitted: row["錄取總人數（含外加）"] ?? "錯誤"
            ))
        }
    } catch {
        print("讀取 CSV 失敗: \(error)")
    }
    return beforePlacements
}

