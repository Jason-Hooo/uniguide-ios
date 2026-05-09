//
//  PredictionRecordCardView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/13.
//

import SwiftUI
import Foundation

struct PredictionRecordCardView: View {
    
    @EnvironmentObject private var predictionRecordsManager: PredictionRecordsManager
    @Environment(\.colorScheme) private var colorScheme
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    @State private var showDeletedAlert: Bool = false
    var predictionRecord: PredictionRecord
    
    var body: some View {
        NavigationLink {
            LazyView(
                PredictionResultView(
                    predictionRecord: predictionRecord,
                    predictionResult: predictAdmission(
                        analysisName: predictionRecord.analysisName,
                        placementInputType: ScoresInputType(rawValue: predictionRecord.placementInputType)!,
                        placementScores: predictionRecord.placementScores,
                        gsatInputType: ScoresInputType(rawValue: predictionRecord.gsatInputType)!,
                        gsatScores: predictionRecord.gsatScores,
                        englishListening: EnglishListening(rawValue: predictionRecord.englishListening)!
                    )
                )
            )
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(predictionRecord.analysisName)
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundStyle(Color(isDarkMode ? "veryLightGray" : "veryDarkBrown"))
                            .lineLimit(1)
                        
                        Text(formatDate(predictionRecord.date))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.gray.opacity(0.5))
                    }
                    
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("學測及英聽")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color("khaki"))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            Text(formatScores(getGsatScoresWithEnglishListening()).trimmingCharacters(in: .whitespaces))
                                .font(.system(size: 14))
                                .foregroundStyle(.gray.opacity(0.5))
                                .lineLimit(1)
                                .minimumScaleFactor(1.0)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("分科")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color("khaki"))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            Text(formatScores(predictionRecord.placementScores))
                                .font(.system(size: 14))
                                .foregroundStyle(.gray.opacity(0.5))
                                .lineLimit(1)
                                .minimumScaleFactor(1.0)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: isDarkMode ? .white.opacity(0.1) : .black.opacity(0.2), radius: 8, y: 3)
            .contextMenu {
                Button(role: .destructive) {
                    showDeletedAlert = true
                } label: {
                    HStack {
                        Text("刪除")
                        Image(systemName: "trash")
                    }
                }
            }
            .confirmationDialog("確認要刪除此分析嗎？此動作將無法返回", isPresented: $showDeletedAlert, titleVisibility: .visible) {
                Button("刪除", role: .destructive) {
                    withAnimation {
                        predictionRecordsManager.deletePredictionRecord(predictionRecord: predictionRecord)
                    }
                }
                Button("取消", role: .cancel) {}
            }
        }
    }
    
    private func getGsatScoresWithEnglishListening() -> [String: String] {
        var dict = predictionRecord.gsatScores
        if !(predictionRecord.englishListening == "未報考") { // 未報考就不用顯示了
            dict["英聽"] = predictionRecord.englishListening
        }
        
        return dict
    }
    
    private func formatScores(_ scores: [String: String]) -> String {
        if scores.isEmpty {
            
            return "未報考任意科目"
        } else {
            let order = [
                "國文", "英文", "數學A", "數學B", "社會", "自然", "英聽", "數學甲", "數學乙", "物理", "化學", "生物", "歷史", "地理", "公民"
            ]
            var result: String = ""
            for subject in order {
                if let score = scores[subject] {
                    result += "\(subject): "
                    if let doubleScore = Double(score) {
                        if doubleScore.truncatingRemainder(dividingBy: 1) == 0 {
                            result += "\(String(format: "%.0f", doubleScore))  "
                        } else {
                            result += "\(doubleScore)  "
                        }
                    } else {
                        result += "\(score)  "
                    }
                }
            }
            result = result.trimmingCharacters(in: .whitespaces)
            
            return result
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_TW")
        
        return formatter.string(from: date)
    }
    
}

public struct LazyView<Content: View>: View {
    private let build: () -> Content
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    public var body: Content {
        build()
    }
}
