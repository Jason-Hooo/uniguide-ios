//
//  PredictionMainView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/7.
//

import Foundation
import SwiftUI

struct PredictionMainView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var showAnalysisOptions = false
    @State private var shouldShowAd = false
    @EnvironmentObject private var predictionRecordsManager: PredictionRecordsManager
    @StateObject private var rewardedAdManager = RewardedAdManager()
    @State private var showAddEnergySheet: Bool = false
    @State private var showNoEnergyAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if predictionRecordsManager.isDataLoading {
                        ForEach(0..<10, id: \.self) { _ in
                            PredictionSkeletonCardView()
                                .padding([.top, .horizontal])
                        }
                    } else if predictionRecordsManager.predictionRecords.isEmpty {
                        emptyStateView
                            .padding(.top, 200)
                    } else {
                        ForEach(predictionRecordsManager.predictionRecords.sorted(by: { $0.date < $1.date })) { predictionRecord in
                            PredictionRecordCardView(predictionRecord: predictionRecord)
                                .padding([.top, .horizontal])
                        }
                    }
                }
            }
            .scrollDisabled(predictionRecordsManager.isDataLoading)
            .background(
                LinearGradient(
                    colors: [Color("myOrange").opacity(colorScheme == .dark ? 0.05 : 0.1), Color("khaki").opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EnergyBarView(
                        shouldShowAd: $shouldShowAd,
                        showAddEnergySheet: $showAddEnergySheet
                    )
                }
                ToolbarItem(placement: .principal) {
                    Text("精準落點分析")
                        .font(.custom("GenJyuuGothicX-Medium", size: 20))
                        .foregroundStyle(.brown)
                }
            }
            .navigationDestination(isPresented: $showAnalysisOptions) {
                AddPredictionView()
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    if UserDataManager.shared.userData?.energies ?? 0 > 0 {
                        showAnalysisOptions = true
                    } else {
                        showNoEnergyAlert = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .frame(width: 56, height: 56)
                        .background(
                            LinearGradient(
                                colors: [Color("myOrange"), Color("myOrange").opacity(0.5)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(28)
                        .shadow(color: Color("myOrange").opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .padding()
            }
            .overlay(alignment: .center) {
                // 廣告載入時顯示 loadingView
                if !rewardedAdManager.isAdReady && shouldShowAd {
                    LoadingView(color: .brown, pointSize: 25)
                        .padding(.bottom)
                }
            }
            .alert("能量不足", isPresented: $showNoEnergyAlert) {
                Button("確認") {}
                Button("去補充能量") {
                    showAddEnergySheet = true
                }
            } message: {
                Text("目前能量不足，無法新增落點分析。請透過觀看廣告或升級 Pro 獲取無限能量。")
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 17) {
            Image(systemName: "chart.xyaxis.line")
                .font(.system(size: 80))
                .foregroundStyle(Color("khaki"))
            
            VStack(spacing: 8) {
                Text("尚無分析記錄")
                    .font(.custom("GenJyuuGothicX-Normal", size: 24))
                    .fontWeight(.bold)
                    .foregroundStyle(Color(colorScheme == .dark ? "veryLightGray" : "veryDarkBrown"))
                
                Text("點擊右下角按鈕開始你的第一次落點分析")
                    .font(.system(size: 16))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
        }
    }

}
//import SwiftUI
//
//struct HomeView: View {
//    @State private var navigationPath = [String]()
//
//    var body: some View {
//        NavigationStack(path: $navigationPath) {
//            VStack {
//                NavigationLink(destination: ResultView()) {
//                    Text("ResultView")
//                }
//                Button("新增") {
//                    navigationPath.append("AddView")
//                }
//                .navigationDestination(for: String.self) { value in
//                    if value == "AddView" {
//                        AddView(navigationPath: $navigationPath)
//                    } else if value == "ResultView" {
//                        ResultView()
//                    } else {
//                        EmptyView()
//                    }
//                }
//                .navigationTitle("首頁")
//            }
//        }
//    }
//}
//
//struct AddView: View {
//    @Binding var navigationPath: [String]
//
//    var body: some View {
//        VStack {
//            Text("新增頁面")
//            Button("完成") {
//                navigationPath.removeLast()
//                navigationPath.append("ResultView")
//            }
//        }
//        .navigationTitle("新增")
//    }
//}
//
//struct ResultView: View {
//    var body: some View {
//        VStack {
//            Text("結果頁面")
//        }
//        .navigationTitle("結果")
//    }
//}
//
//#Preview {
//    HomeView()
//}
