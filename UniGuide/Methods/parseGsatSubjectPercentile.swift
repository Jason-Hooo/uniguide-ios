//
//  parseGsatSubjectCriteria.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/9.
//

import Foundation // 1.英文(前標) 2.數學A(前標) 或數學B(前標)

func parseGsatSubjectPercentile(_ input: String) -> (
    [String: GsatPercentile], [String: GsatPercentile]
) {
    // 1. 去除數字標號，例如 "1. 英文(前標)" 變成 "英文(前標)"
    let cleaned = input.replacingOccurrences(of: #"(\d+\.)"#, with: "", options: .regularExpression)
    
    // 2. 按空白切割成 tokens
    var tokens = cleaned.split(separator: " ").map { String($0) }
    
    // 3. 分類 tokens，分成 singleTokens 與 orTokens
    var singleTokens: [String] = []
    var orTokens: [String] = []
    
    var i = 0
    while i < tokens.count { // 執行一次迴圈就會重新讀 tokens.count
        if tokens[i].first == "或" {
            var orToken1 = tokens.remove(at: i) // 回傳刪除的字串值
            orToken1.removeFirst() // 去除或
            let orToken2 = tokens.remove(at: i - 1)
            orTokens.append(orToken2)
            orTokens.append(orToken1)
            i -= 1
        } else {
            i += 1
        }
    }

    singleTokens = tokens
    
    return (parseSingleOrPercentile(singleTokens), parseSingleOrPercentile(orTokens))
}

// ["數學A(底標)", "數學B(底標)"] 把五標和科目分開轉成dict
private func parseSingleOrPercentile(_ tokens: [String]) -> [String: GsatPercentile] {
    
    var result: [String: GsatPercentile] = [:]
    
    for token in tokens {
        if let subjectRange = token.range(of: #"^(.*?)\("#, options: .regularExpression),
           let percentileRange = token.range(of: #"\((.*?)\)"#, options: .regularExpression) {
            
            let subject = String(token[subjectRange].dropLast()) // 去掉 "("
            let percentile = String(token[percentileRange]).trimmingCharacters(in: CharacterSet(charactersIn: "()"))
            
            result[subject] = GsatPercentile(rawValue: percentile)
        } else {
            print("parseSingleOrPercentile 解析錯誤")
        }
    }
    
    return result
}
