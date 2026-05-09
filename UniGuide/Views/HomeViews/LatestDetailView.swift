//
//  DetailView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2024/12/7.
//

import SwiftUI

struct LatestDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var latestPlacementsManager: LatestPlacementsManager
    @EnvironmentObject private var rankingDepartmentsManager: RankingDepartmentsManager
    var placement: LatestPlacement
    @State private var showAlertFavorite = false
    @State private var favoriteButtonscale = 1.0
    @State private var showCopyAlert: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                VStack(alignment: .leading) {
                    Text("學測及英聽檢定標準")
                        .font(.headline)
                    GroupBox {
                        HStack(alignment: .top) {
                            DetailColumn(title: "國文", content: placement.subjectCriteriaChinese)
                            DetailColumn(title: "英文", content: placement.subjectCriteriaEnglish)
                            DetailColumn(title: "數學A", content: placement.subjectCriteriaMathA)
                            DetailColumn(title: "數學B", content: placement.subjectCriteriaMathB)
                            DetailColumn(title: "社會", content: placement.subjectCriteriaSocial)
                            DetailColumn(title: "自然", content: placement.subjectCriteriaScience)
                            DetailColumn(title: "英聽", content: placement.subjectCriteriaEnglishListening)
                        }
                        .frame(maxWidth: .infinity) // 還是要加，如果HStack沒內容就會變超窄
                    }
                }
                .padding(.top, 25)
                VStack(alignment: .leading) {
                    Text("採計科目及加權")
                        .font(.headline)
                    GroupBox {
                        VStack {
                            HStack(alignment: .top) {
                                DetailColumn(title: "數學甲", content: placement.weightingMathGay)
                                DetailColumn(title: "數學乙", content: placement.weightingMathChair)
                                DetailColumn(title: "物理", content: placement.weightingPhysics)
                                DetailColumn(title: "化學", content: placement.weightingChemistry)
                                DetailColumn(title: "生物", content: placement.weightingBiology)
                                DetailColumn(title: "歷史", content: placement.weightingHistory)
                                DetailColumn(title: "地理", content: placement.weightingGeography)
                                DetailColumn(title: "公民", content: placement.weightingCivics)
                                DetailColumn(title: "國文", content: placement.weightingChinese)
                                DetailColumn(title: "英文", content: placement.weightingEnglish)
                                DetailColumn(title: "數學A", content: placement.weightingMathA)
                                DetailColumn(title: "數學B", content: placement.weightingMathB)
                                DetailColumn(title: "社會", content: placement.weightingSocial)
                                DetailColumn(title: "自然", content: placement.weightingScience)
                                DetailColumn(title: "術科", content: placement.practicalKind + placement.weightingPractical)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text("同分參酌順序")
                        .font(.headline)
                    GroupBox {
                        HStack(alignment: .top) {
                            DetailColumn(title: "1", content: placement.tieSubject1)
                            DetailColumn(title: "2", content: placement.tieSubject2)
                            DetailColumn(title: "3", content: placement.tieSubject3)
                            DetailColumn(title: "4", content: placement.tieSubject4)
                            DetailColumn(title: "5", content: placement.tieSubject5)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                VStack(alignment: .leading) {
                    Text("選系說明")
                        .font(.headline)
                    GroupBox {
                        if placement.illustration != "" {
                            Text(placement.illustration)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                        } else {
                            Text("無")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.brown)
                        .bold()
                }
            }
            ToolbarItem(placement: .principal) {
                Button {
                    UIPasteboard.general.string = placement.schoolName + " " + placement.departmentName
                    withAnimation(.spring(duration: 0.3)) {
                        showCopyAlert = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showCopyAlert = false
                        }
                    }
                } label: {
                    VStack(alignment: .center, spacing: 2) {
                        Text(Year.latest.rawValue + " " + placement.schoolName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.brown)
                        Text(placement.departmentName)
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray2))
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                FavoriteButtonView(placement: placement, favoriteButtonscale: 1.0)
            }
        }
        .overlay(alignment: .center) {
            if showCopyAlert {
                BlackAlertView(alert: "已成功複製校系至剪貼簿。", imageName: "checkmark.circle", showAlert: $showCopyAlert)
            }
        }
        .alert(Text("確認要將此校系從「我的志願」中移除嗎？"), isPresented: $showAlertFavorite) {
            Button("取消", role: .cancel) {}
            Button("移除", role: .destructive) {
                withAnimation {
                    latestPlacementsManager.toggleLatestPlacement(latestPlacement: placement)
                }
            }
        } message: {
            Text("\(placement.schoolName) \(placement.departmentName)")
        }
        .onAppear {
            rankingDepartmentsManager.addVisitCount(id: placement.id)
        }
    }
}

struct DetailColumn: View {
    
    let title: String
    let content: String
    
    var body: some View {
        if content != "" {
            VStack(alignment: .center, spacing: 5) {
                Text(title)
                    .foregroundStyle(.secondary)
                Text(content)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
    
}

#Preview {
    LatestDetailView(placement: LatestPlacement(
        id: 0,
        schoolName: "國立政治大學",
        departmentName: "資訊管理學系(自然組)",
        subjectCriteriaChinese: "前標",
        subjectCriteriaEnglish: "前標",
        subjectCriteriaMathA: "前標",
        subjectCriteriaMathB: "",
        subjectCriteriaSocial: "",
        subjectCriteriaScience: "前標",
        subjectCriteriaEnglishListening: "B",
        weightingMathGay: "2.00",
        weightingMathChair: "",
        weightingPhysics: "",
        weightingChemistry: "",
        weightingBiology: "",
        weightingHistory: "",
        weightingGeography: "",
        weightingCivics: "",
        weightingChinese: "1.00",
        weightingEnglish: "2.00",
        weightingMathA: "",
        weightingMathB: "",
        weightingSocial: "",
        weightingScience: "",
        weightingPractical: "",
        practicalKind: "",
        tieSubject1: "數學甲",
        tieSubject2: "英文",
        tieSubject3: "國文",
        tieSubject4: "",
        tieSubject5: "",
        illustration: "本系為培養企業資訊管理人才"
    ))
}
