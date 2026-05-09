//
//  SearchResultListView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/3/8.
//

import Foundation
import SwiftUI
import SwiftData

struct SearchResultListView: View {
    
    @Environment(\.modelContext) private var context
    @Query(sort: \SearchHistory.timestamp, order: .reverse) private var searchHistorys: [SearchHistory]
    let filteredLatestPlacements: [LatestPlacement]
    let filteredBeforePlacements1: [BeforePlacement]
    let filteredBeforePlacements2: [BeforePlacement]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                if !filteredLatestPlacements.isEmpty {
                    Section {
                        ForEach(filteredLatestPlacements) { placement in
                            NavigationLink{
                                LatestDetailView(placement: placement)
                                    .onAppear {
                                        updateSearchHistory(
                                            SearchHistory(id: placement.id, years: Year.latest, timestamp: Date())
                                        )
                                    }
                            } label: {
                                ListRowView(placement: placement)
                            }
                        }
                    } header: {
                        SectionHeader(title: Year.latest.rawValue)
                    }
                }
                if !filteredBeforePlacements1.isEmpty {
                    Section {
                        ForEach(filteredBeforePlacements1) { placement in
                            NavigationLink{
                                BeforeDetailView(years: Year.before1, placement: placement)
                                    .onAppear {
                                        updateSearchHistory(
                                            SearchHistory(id: placement.id, years: Year.before1, timestamp: Date())
                                        )
                                    }
                            } label: {
                                ListRowView(placement: placement)
                            }
                        }
                    } header: {
                        SectionHeader(title: Year.before1.rawValue)
                    }
                }
                if !filteredBeforePlacements2.isEmpty {
                    Section {
                        ForEach(filteredBeforePlacements2) { placement in
                            NavigationLink{
                                BeforeDetailView(years: Year.before2, placement: placement)
                                    .onAppear {
                                        updateSearchHistory(
                                            SearchHistory(id: placement.id, years: Year.before2, timestamp: Date())
                                        )
                                    }
                            } label: {
                                ListRowView(placement: placement)
                            }
                        }
                    } header: {
                        SectionHeader(title: Year.before2.rawValue)
                    }
                }
            }
        }
        .simultaneousGesture(DragGesture().onChanged({ _ in
            UIApplication.shared.endEditing()
        }))
    }
    
    private func updateSearchHistory(_ history: SearchHistory) {
        for searchHistory in searchHistorys {
            if history.id == searchHistory.id && history.years == searchHistory.years {
                searchHistory.timestamp = Date()
                try? context.save()
                return
            }
        }
        context.insert(history)
    }
    
}

struct SectionHeader: View {
    
    var title: String
    
    var body: some View {
        HStack {
            Spacer()
            Text("\(title) 學年度")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(Color("myOrange"))
                .padding(11)
            Spacer()
        }
        .background(Color(.systemGray5))
        .listRowInsets(EdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0))
    }
    
}


