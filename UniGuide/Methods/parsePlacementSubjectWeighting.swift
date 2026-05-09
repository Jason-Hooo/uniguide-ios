//
//  parsePlacementSubjectWeighting.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/10.
//

func parsePlacementSubjectWeighting(_ input: String) -> [String: Double] {
    
    var result: [String: Double] = [:]
    let subjectWeightings = input.split(separator: " ")
    
    for subjectWeighting in subjectWeightings {
        let parts = subjectWeighting.split(separator: "x")
        var subject = String(parts[0])
        subject = convertSubjectToFullName(subject)
        let weighting = Double(parts[1])
        result[subject] = weighting
    }
    
    return result
}

private func convertSubjectToFullName(_ subject: String) -> String {
    switch subject {
    case "國":
        return "國文"
    case "英":
        return "英文"
    case "數A":
        return "數學A"
    case "數B":
        return "數學B"
    case "社":
        return "社會"
    case "自":
        return "自然"
    case "數甲":
        return "數學甲"
    case "數乙":
        return "數學乙"
    case "物":
        return "物理"
    case "化":
        return "化學"
    case "生":
        return "生物"
    case "歷":
        return "歷史"
    case "地":
        return "地理"
    case "公":
        return "公民與社會"
    default:
        print("convertSubjectToFullName 發生錯誤：\(subject)")
        return subject
    }
}
