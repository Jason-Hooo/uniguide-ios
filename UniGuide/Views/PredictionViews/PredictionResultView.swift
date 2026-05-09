//
//  PredictionResultView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/14.
//

import SwiftUI
import Foundation

struct PredictionResultView: View {
    
    @EnvironmentObject private var predictionRecordsManager: PredictionRecordsManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    var predictionRecord: PredictionRecord
    var predictionResult: PredictionResult
    private var predictedPlacements: [PredictedPlacement] {
        return predictionResult.predictedPlacement 
    }
    private var convertedPlacementScores: [String: Double] {
        return predictionResult.convertedPlacementScores
    }
    private var convertedGsatScores: [String: Double] {
        return predictionResult.convertedGsatScores
    }
    private var convertedGsatPercentiles: [String: GsatPercentile] {
        return predictionResult.convertedGsatPercentiles
    }
    @State private var searchText: String = ""
    @State private var isSearchActive = false
    @State private var isShowScoresSheet: Bool = false
 
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(predictedPlacements, id: \.id) { predictedPlacement in
                        NavigationLink{
                            ResultDetailView(predictedPlacement: predictedPlacement)
                        } label: {
                            ListRowView(placement: predictedPlacement.placement)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.brown, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .bold()
                            .foregroundStyle(Color("cream"))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(predictionRecord.analysisName)
                        .font(.custom("GenJyuuGothicX-Medium", size: 20))
                        .foregroundStyle(Color("cream"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            isShowScoresSheet.toggle()
                        }
                    } label: {
                        Image(systemName: isShowScoresSheet ? "rectangle.portrait" : "inset.filled.bottomhalf.rectangle.portrait")
                            .bold()
                            .foregroundStyle(Color("cream"))
                    }
                }
            }
            .sheet(isPresented: $isShowScoresSheet) {
                expandableNavigationBar
                    .presentationDetents([.medium])
                    .presentationBackground(.brown)
                    .presentationBackgroundInteraction(.enabled)
            }
        }
    }
    
    private var expandableNavigationBar: some View {
        let items: [(String, String?, Double?, GsatPercentile?)] = [
            ("國文", predictionRecord.gsatScores["國文"], convertedGsatScores["國文"], convertedGsatPercentiles["國文"]),
            ("英文", predictionRecord.gsatScores["英文"], convertedGsatScores["英文"], convertedGsatPercentiles["英文"]),
            ("數學A", predictionRecord.gsatScores["數學A"], convertedGsatScores["數學A"], convertedGsatPercentiles["數學A"]),
            ("數學B", predictionRecord.gsatScores["數學B"], convertedGsatScores["數學B"], convertedGsatPercentiles["數學B"]),
            ("社會", predictionRecord.gsatScores["社會"], convertedGsatScores["社會"], convertedGsatPercentiles["社會"]),
            
            ("自然", predictionRecord.gsatScores["自然"], convertedGsatScores["自然"], convertedGsatPercentiles["自然"]),
            ("英聽", predictionRecord.englishListening, nil, nil),
            ("數學甲", predictionRecord.placementScores["數學甲"], convertedPlacementScores["數學甲"], nil),
            ("數學乙", predictionRecord.placementScores["數學乙"], convertedPlacementScores["數學乙"], nil),
            ("物理", predictionRecord.placementScores["物理"], convertedPlacementScores["物理"], nil),
            
            ("化學", predictionRecord.placementScores["化學"], convertedPlacementScores["化學"], nil),
            ("生物", predictionRecord.placementScores["生物"], convertedPlacementScores["生物"], nil),
            ("歷史", predictionRecord.placementScores["歷史"], convertedPlacementScores["歷史"], nil),
            ("地理", predictionRecord.placementScores["地理"], convertedPlacementScores["地理"], nil),
            ("公民與社會", predictionRecord.placementScores["公民與社會"], convertedPlacementScores["公民與社會"], nil)
        ]
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
            ForEach(items, id: \.0) { subject, userScore, convertedScore, convertedPercentile in
                SubjectScoreItem(
                    subject: subject,
                    userScore: userScore,
                    convertedScore: convertedScore,
                    convertedPercentile: convertedPercentile
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
}

struct SubjectScoreItem: View {
    
    let subject: String
    let userScore: String?
    let convertedScore: Double?
    let convertedPercentile: GsatPercentile?
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {

            Text(subject)
                .font(.system(size: 14, weight: .medium))
                
            HStack(alignment: .top, spacing: 2) {
                VStack(alignment: .center, spacing: 2) {
                    Text("原始")
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                    Text(userScore ?? "未報考")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .center, spacing: 2) {
                    Text("113")
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                    if let convertedScore = convertedScore, let convertedPercentile = convertedPercentile {
                        Text("\(Int(convertedScore))" + convertedPercentile.rawValue)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.green)
                    } else if let convertedScore = convertedScore {
                        Text(String(Int(convertedScore)))
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.green)
                    } else {
                        Text(subject == "英聽" ? userScore : "未報考")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.green)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(Color("cream"))
        .cornerRadius(10)
    }

}

