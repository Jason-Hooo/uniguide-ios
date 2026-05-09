//
//  readAccumulationCSV.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/5.
//

import Foundation
import SwiftUI
import SwiftCSV

func readAccumulationCSV(csvName: String) -> [String: [Double]] {
    var accumulation: [String: [Double]] = [:]
    guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
        return accumulation
    }
    do {
        let csv = try CSV<Named>(url: URL(fileURLWithPath: filePath))
        if let columns = csv.columns{
            for (columnName, stringValues) in columns {
                let doubleValues = stringValues.compactMap { Double($0) }
                accumulation[columnName] = doubleValues
            }
        }
    } catch {
        print("讀取 CSV 失敗: \(error)")
    }

    return accumulation
}
