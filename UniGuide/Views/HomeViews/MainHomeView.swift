//
//  ContentView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2024/12/4.
//

import SwiftUI
import SwiftData
import Foundation

struct MainHomeView: View {
    
    @EnvironmentObject private var latestPlacementsManager: LatestPlacementsManager
    @State private var beforePlacements1: [BeforePlacement] = [] // 必
    @State private var beforePlacements2: [BeforePlacement] = []
    @State private var searchText: String = ""
    @State private var isSearchActive = false
    @State private var selectedYears: String = Year.latest.rawValue
    @Binding var isInDetailView: Bool
    @Binding var isSideBarOpened: Bool
    private var filteredLatestPlacements: [LatestPlacement] {
        return filterPlacements(from: latestPlacementsManager.latestPlacements)
    }
    private var filteredBeforePlacements1: [BeforePlacement] {
        return filterPlacements(from: beforePlacements1)
    }
    private var filteredBeforePlacements2: [BeforePlacement] {
        return filterPlacements(from: beforePlacements2)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if latestPlacementsManager.isDataLoading {
                    ScrollView {
                        LazyVStack {
                            ForEach(0..<10, id: \.self) { _ in
                                HomeSkeletonCardView()
                            }
                        }
                        .toolbar {
                            NonSearchToolbarItems
                        }
                    }
                    .scrollDisabled(true)
                } else if !isSearchActive { // 顯示全部校系（未搜尋時）
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            if selectedYears == Year.latest.rawValue { // 用list會UI會變卡
                                ForEach(latestPlacementsManager.latestPlacements) { placement in
                                    NavigationLink{
                                        LatestDetailView(placement: placement)
                                            .onAppear { isInDetailView = true }
                                            .onDisappear { isInDetailView = false }
                                    } label: {
                                        ListRowView(placement: placement)
                                    }
                                }
                            } else if selectedYears == Year.before1.rawValue {
                                ForEach(beforePlacements1) { placement in
                                    NavigationLink{
                                        BeforeDetailView(years: Year.before1, placement: placement)
                                            .onAppear { isInDetailView = true }
                                            .onDisappear { isInDetailView = false }
                                    } label: {
                                        ListRowView(placement: placement)
                                    }
                                }
                            } else {
                                ForEach(beforePlacements2) { placement in
                                    NavigationLink{
                                        BeforeDetailView(years: Year.before2, placement: placement)
                                            .onAppear { isInDetailView = true }
                                            .onDisappear { isInDetailView = false }
                                    } label: {
                                        ListRowView(placement: placement)
                                    }
                                }
                            }
                        }
                        .id(selectedYears)
                    }
                    .toolbar {
                        NonSearchToolbarItems
                    }
                } else if !searchText.isEmpty { // 有搜尋字詞
                    if filteredLatestPlacements.isEmpty && filteredBeforePlacements1.isEmpty && filteredBeforePlacements2.isEmpty { // 搜尋不到
                        VStack(spacing: 7) {
                            Group {
                                Text("查無此校系：")
                                    .font(.system(size: 33))
                                Text("「" + searchText + "」")
                                    .font(.system(size: 25))
                                    .padding(.horizontal, 30)
                            }
                            .bold()
                            .foregroundStyle(.brown)
                            Text("請嘗試用不同關鍵字再次搜尋")
                                .font(.system(size: 21))
                                .foregroundStyle(Color(134, 138, 147))
                        }
                    } else {
                        SearchResultListView(
                            filteredLatestPlacements: filteredLatestPlacements,
                            filteredBeforePlacements1: filteredBeforePlacements1,
                            filteredBeforePlacements2: filteredBeforePlacements2
                        )
                    }
                } else { // 無搜尋字詞，顯示搜尋紀錄
                    SearchHistorysView(beforePlacements1: beforePlacements1, beforePlacements2: beforePlacements2)
                }
            }
            .toolbarBackground(.brown, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .searchable(text: $searchText, isPresented: $isSearchActive, prompt: "大學或科系名稱...")
        .accentColor(Color("cream"))
        .task {
            if beforePlacements1.isEmpty || beforePlacements2.isEmpty {
                async let data1: [BeforePlacement] = Task.detached { readBeforePlacementCSV(csvName: "113_placement") }.value
                async let data2: [BeforePlacement] = Task.detached { readBeforePlacementCSV(csvName: "112_placement") }.value
                let (loaded1, loaded2) = await (data1, data2)
                beforePlacements1 = loaded1
                beforePlacements2 = loaded2
            }
        }
        .overlay(alignment: .topTrailing) {
            if !isSearchActive && !isInDetailView {
                SegmentControlView(
                    segments: Year.allCases.map { $0.rawValue },
                    selected: $selectedYears,
                    mainColor: Color("cream"),
                    titleSelectedColor: .brown,
                    cornerRadius: 10,
                    textSize: 17,
                    needBackground: false
                )
                .frame(width: 150, height: 25)
                .padding(.trailing, 24)
            }
        }
    }
    
    private func filterPlacements<T: Placement>(from placements: [T]) -> [T] {
        guard !searchText.isEmpty else { return [] }
        let formattedSearchText = searchText.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        return placements.filter { placement in
                var chars = formattedSearchText.map { String($0) }
                var result: Bool = true
                for i in 0..<chars.count {
                    if chars[i] == "台" {
                        chars[i] = "臺"
                    }
                    if !placement.schoolName.contains(chars[i]) && !placement.departmentName.contains(chars[i]) {
                        result = false
                        break
                    }
                }
                
                return result
            }
    }
    
    private var NonSearchToolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack(spacing: 0) {
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        isSideBarOpened = true
                    }
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.leading, 4)
                        .padding(.vertical, 12)
                }
                Text("UniGuide")
                    .font(.custom("GenJyuuGothicX-Normal", size: 25))
                    .bold()
            }
            .foregroundStyle(Color("cream"))
        }
    }
    
}


//#Preview {
//    MainHomeView()
//}

/*
 GeometryReader { geometry in // 在台大中文上創建Rectangle()並獲取其midY座標，用來判斷ovaerlay的item是否需要上移或下移
     let frame = geometry.frame(in: CoordinateSpace.global)
     withAnimation {
         DispatchQueue.main.async {
             self.midY = frame.midY
         }
     }
     return Rectangle()
 }
 .frame(height: 0)
 */


                 
 
