//
//  PredictionRecord.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/13.
//

import Foundation
import FirebaseFirestore

struct PredictionRecord: Codable, Identifiable { // 要存在 firebase 的預測紀錄
    
    @DocumentID var id: String?
    var date: Date = Date()
    var analysisName: String
    var placementInputType: String
    var placementScores: [String: String]
    var gsatInputType: String
    var gsatScores: [String: String]
    var englishListening: String // 就算是未報考也要儲存，之後載入資料時轉成 .none
    
}
