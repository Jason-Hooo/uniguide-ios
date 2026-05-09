//
//  SearchHistorysView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/3/9.
//

import SwiftUI
import SwiftData
import SwipeActions

struct SearchHistorysView: View {
    
    @Environment(\.modelContext) private var context
    @Query(sort: \SearchHistory.timestamp, order: .reverse) private var searchHistorys: [SearchHistory]
    @EnvironmentObject private var latestPlacementsManager: LatestPlacementsManager
    let beforePlacements1: [BeforePlacement]
    let beforePlacements2: [BeforePlacement]
    @State private var showDeletedAlert: Bool = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if !searchHistorys.isEmpty {
                    HStack {
                        Text("最近的搜尋")
                            .foregroundStyle(Color(.systemGray2))
                            .font(.headline)
                        Spacer()
                        Button {
                            showDeletedAlert = true
                        } label: {
                            Text("清除")
                                .foregroundStyle(Color("myOrange"))
                                .font(.subheadline)
                                .bold()
                        }
                    }
                    .padding()
                }
                SwipeViewGroup {
                    ForEach(searchHistorys) { history in
                        SwipeView {
                            Group {
                                if history.years == Year.latest {
                                    let placement = latestPlacementsManager.latestPlacements[history.id]
                                    NavigationLink{
                                        LatestDetailView(placement: placement)
                                            .onAppear {
                                                history.timestamp = Date()
                                                try? context.save()
                                            }
                                    } label: {
                                        ListRowView(placement: placement)
                                    }
                                } else if history.years == Year.before1 {
                                    let placement = beforePlacements1[history.id]
                                    NavigationLink{
                                        BeforeDetailView(years: Year.before1, placement: placement)
                                            .onAppear {
                                                history.timestamp = Date()
                                                try? context.save()
                                            }
                                    } label: {
                                        ListRowView(placement: placement)
                                    }
                                } else {
                                    let placement = beforePlacements2[history.id]
                                    NavigationLink{
                                        BeforeDetailView(years: Year.before2, placement: placement)
                                            .onAppear {
                                                history.timestamp = Date()
                                                try? context.save()
                                            }
                                    } label: {
                                        ListRowView(placement: placement)
                                    }
                                }
                            }
                            .overlay(alignment: .bottomTrailing) {
                                Text(history.years.rawValue)
                                    .foregroundStyle(.brown)
                                    .bold()
                                    .padding()
                            }
                        } trailingActions: { _ in
                            SwipeAction(systemImage: "trash", backgroundColor: .red, highlightOpacity: 1) {
                                withAnimation {
                                    context.delete(history)
                                    try? context.save()
                                }
                            }
                            .allowSwipeToTrigger()
                            .font(.title2.weight(.medium))
                            .foregroundColor(.white)
                        }
                        .swipeActionCornerRadius(0)
                        .swipeSpacing(0)
                        .swipeActionsMaskCornerRadius(0)
                        .swipeMinimumDistance(25)
                        .transition(.swipeDelete)
                    }
                }
            }
        }
        .simultaneousGesture(DragGesture().onChanged({ _ in
            UIApplication.shared.endEditing()
        }))
        .confirmationDialog("確定要清空所有搜尋紀錄嗎？", isPresented: $showDeletedAlert, titleVisibility: .visible) {
            Button("刪除", role: .destructive) {
                withAnimation {
                    for history in searchHistorys {
                        context.delete(history)
                        try? context.save()
                    }
                }
            }
            Button("取消", role: .cancel) {}
        }
    }
    
}

