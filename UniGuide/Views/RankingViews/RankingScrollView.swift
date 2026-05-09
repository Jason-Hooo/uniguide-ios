//
//  VisitCountRankingView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/3/10.
//

import SwiftUI

struct RankingScrollView: View {
    
    @EnvironmentObject private var latestPlacementsManager: LatestPlacementsManager
    let rankingDepartments: [RankingDepartment]
    let isFavoriteRanking: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) { // 不能用迭代index，這樣排行榜更新時在某些情況會讓row跟detail不符
                ForEach(Array(rankingDepartments.enumerated()), id: \.element.id) { index, rankingDepartment in
                    let placement = latestPlacementsManager.latestPlacements[rankingDepartment.id]
                    NavigationLink {
                        LatestDetailView(placement: placement)
                    } label: {
                        HStack(alignment: .center, spacing: 0) {
                            Text("\(index + 1)")
                                .foregroundStyle(Color("myOrange"))
                                .font(.title3)
                                .bold()
                                .frame(width: 30)
                                .padding(.leading)
                                .transaction { $0.animation = nil }
                            ListRowView(placement: placement)
                        }
                        .overlay(alignment: .bottomTrailing) {
                            Text(isFavoriteRanking ?
                                 "\(rankingDepartment.favoriteCount)" :
                                    "\(rankingDepartment.visitCount)"
                            )
                            .contentTransition(.numericText())
                            .foregroundStyle(.brown)
                            .bold()
                            .padding()
                        }
                    }
                }
            }
        }
    }
    
}

