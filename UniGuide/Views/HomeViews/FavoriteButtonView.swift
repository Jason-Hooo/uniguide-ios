//
//  FavoriteButtonView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/3/8.
//

import SwiftUI

struct FavoriteButtonView: View {
    
    @EnvironmentObject private var latestPlacementsManager: LatestPlacementsManager
    @EnvironmentObject private var rankingDepartmentsManager: RankingDepartmentsManager
    let placement: LatestPlacement
    @State private var showAlertFavorite = false
    @State var favoriteButtonscale: CGFloat
    
    var body: some View {
        Image(systemName: placement.isFavorite ? "bookmark.fill" : "bookmark")
            .foregroundColor(.brown)
            .scaleEffect(favoriteButtonscale)
            .onTapGesture {
                withAnimation {
                    favoriteButtonscale -= 0.2
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeIn(duration: 0.2)) {
                        favoriteButtonscale += 0.2
                    }
                }
                if placement.isFavorite {
                    showAlertFavorite.toggle()
                } else {
                    latestPlacementsManager.toggleLatestPlacement(latestPlacement: placement)
                    rankingDepartmentsManager.updateFavoriteCount(id: placement.id, isAdd: true)
                }
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
            .alert(Text("確認要將此校系從「我的志願」中移除嗎？"), isPresented: $showAlertFavorite) {
                Button("取消", role: .cancel) {}
                Button("移除", role: .destructive) {
                    latestPlacementsManager.toggleLatestPlacement(latestPlacement: placement)
                    rankingDepartmentsManager.updateFavoriteCount(id: placement.id, isAdd: false)
                }
            } message: {
                Text("\(placement.schoolName) \(placement.departmentName)")
            }
    }
    
}
