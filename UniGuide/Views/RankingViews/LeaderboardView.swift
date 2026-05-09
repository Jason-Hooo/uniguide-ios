//
//  LeaderboardView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/2/23.
//

import SwiftUI

struct LeaderboardView: View {
    
    @State private var selected = 0
    private let rankingChoices = ["熱門志願排行", "瀏覽量排行"]
    private let screenWidth = UIScreen.main.bounds.width
    @EnvironmentObject private var rankingDepartmentsManager: RankingDepartmentsManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(0..<rankingChoices.count, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                selected = index
                            }
                        }) {
                            Text(rankingChoices[index])
                                .font(.custom(
                                    selected == index ? "GenJyuuGothicX-Bold" : "GenJyuuGothicX-Medium",
                                    size: 17
                                ))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .foregroundColor(selected == index ? .brown : Color(.systemGray3))
                        }
                    }
                }
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(height: 2)
                    Rectangle()
                        .fill(.brown)
                        .frame(width: screenWidth / CGFloat(rankingChoices.count), height: 2)
                        .offset(x: CGFloat(selected) * screenWidth / CGFloat(rankingChoices.count))
                        .animation(.easeInOut, value: selected)
                }
                if rankingDepartmentsManager.isDataLoading {
                    ScrollView {
                        LazyVStack {
                            ForEach(0..<10, id: \.self) { _ in
                                RankingSkeletonCardView()
                            }
                        }
                    }
                    .scrollDisabled(true)
                } else if selected == 0 {
                    RankingScrollView(
                        rankingDepartments: rankingDepartmentsManager.favoriteRankingDepartments,
                        isFavoriteRanking: true
                    )
                } else {
                    RankingScrollView(
                        rankingDepartments: rankingDepartmentsManager.visitRankingDepartments,
                        isFavoriteRanking: false
                    )
                }
            }
        }
    }
}

#Preview {
    LeaderboardView()
}
