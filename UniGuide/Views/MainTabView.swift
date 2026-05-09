//
//  TabView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2024/12/7.
//

import SwiftUI
import Foundation

struct MainTabView: View {
    
    @State private var selectTabIndex = 0
    let sideBarWidth = UIScreen.main.bounds.size.width * 0.8
    @State private var isSideBarOpened = false
    @State var offset: CGFloat = 0
    @GestureState private var gestureOffset: CGFloat = 0
    @State private var isInDetailView = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            TabView(selection: $selectTabIndex) {
                MainHomeView(
                    isInDetailView: $isInDetailView,
                    isSideBarOpened: $isSideBarOpened
                )
                .tabItem {
                    Label("首頁", systemImage: "house")
                }
                .tag(0)
                LeaderboardView()
                    .tabItem {
                        Label("排行榜", systemImage: "chart.bar")
                    }
                    .tag(1)
                PredictionMainView()
                    .tabItem {
                        Label("落點分析", systemImage: "chart.line.text.clipboard")
                    }
                    .tag(2)
                SchedulesView()
                    .tabItem {
                        Label("升學時程", systemImage: "calendar.badge.clock")
                    }
                    .tag(3)
            }
            .tint(.brown)
            .offset(x: max(self.offset + self.gestureOffset, 0))
            .animation(.interactiveSpring(
                response: 0.25,
                dampingFraction: 1.2,
                blendDuration: 0),
                       value: gestureOffset
            )
            .overlay(
                Color.black
                    .ignoresSafeArea()
                    .opacity((offset + gestureOffset) / sideBarWidth * 0.5)
                    .animation(.spring, value: isSideBarOpened)
                // 上行解決問題：在我滑動手勢結束那一瞬間，gestureOffset會歸0，在offset變成sideBarWidth之前，.opacity會是0
                    .onTapGesture {
                        isSideBarOpened = false
                    }
                    .gesture(backMenuGesture())
            )
            
            MenuView(width: sideBarWidth)
                .frame(width: sideBarWidth)
                .animation(.interactiveSpring(
                    response: 0.25,
                    dampingFraction: 1.2,
                    blendDuration: 0),
                           value: gestureOffset
                )
                .offset(x: -sideBarWidth)
                .offset(x: max(self.offset + self.gestureOffset, 0))
                .gesture(backMenuGesture())
            
            if !isSideBarOpened && selectTabIndex == 0 && !isInDetailView {
                Color.clear
                    .frame(width: 19)
                    .contentShape(Rectangle())
                    .ignoresSafeArea(edges: .vertical)
                    .gesture(openMenuGesture())
            }
        }
        .onChange(of: isSideBarOpened) { _, newValue in
            withAnimation(.interactiveSpring(response: 0.25, dampingFraction: 1.2)) {
                if newValue {
                    offset = sideBarWidth
                } else {
                    offset = 0
                }
            }
        }
    }
    
    func openMenuGesture() -> some Gesture {
        DragGesture()
            .updating($gestureOffset) { v, out, _ in
                // $gestureOffset 手勢動作結束時會歸 0
                if v.startLocation.x <= 19 &&
                    abs(v.translation.width) > abs(v.translation.height) &&
                    v.translation.width > 0 {
                    out = min(v.translation.width, sideBarWidth)
                }
            }
            .onEnded { value in
                let translation = value.translation.width
                let predicted = value.predictedEndTranslation.width
                let threshold = sideBarWidth * 0.6
                
                if translation + predicted > threshold {
                    offset = sideBarWidth
                    // 上述解決問題讓 ui 可以即時反應：在我滑動手勢結束那一瞬間，gestureOffset會歸0，在offset變成sideBarWidth之前，.offset會變0再變sideBarWidth，所以會看到一瞬間menu縮回去
                    isSideBarOpened = true
                }
            }
    }
    
    func backMenuGesture() -> some Gesture {
        DragGesture()
            .updating($gestureOffset) { value, out, _ in
                if abs(value.translation.width) > abs(value.translation.height),
                   value.translation.width < 0 {
                    out = max(value.translation.width, -sideBarWidth)
                }
            }
            .onEnded { value in
                let translation = value.translation.width
                let predicted = value.predictedEndTranslation.width
                let threshold = sideBarWidth * 0.6

                if translation + predicted < -threshold {
                    offset = 0 // 同上一個註解的道理
                    isSideBarOpened = false
                }
            }
    }
    
}

//#Preview {
//    MainTabView()
//}

//        .onOpenURL { url in
//            print("Received deep link: \(url.absoluteString)")
//            selectTabIndex = 3
//        }
