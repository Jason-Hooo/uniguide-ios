//
//  ResultDetailView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/14.
//

import SwiftUI

struct ResultDetailView: View {
    
    let years: Year = Year.before1
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var predictionRecordsManager: PredictionRecordsManager
    let predictedPlacement: PredictedPlacement
    private var placement: BeforePlacement {
        return predictedPlacement.placement
    }
    @State private var showAlertFavorite = false
    @State private var favoriteButtonscale = 1.2
    @State private var showCopyAlert: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                VStack(alignment: .leading) {
                    Text("學測及英聽檢定標準")
                        .font(.headline)
                    GroupBox {
                        Text(placement.englishListening == "" ?
                             placement.subjectCriteria :
                                placement.subjectCriteria + "  /  " + "英聽(\(placement.englishListening))"
                        )
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity) // 還是要加，如果HStack沒內容就會變超窄
                    }
                }
                .padding(.top, 25)
                VStack(alignment: .leading) {
                    Text("採計科目及加權")
                        .font(.headline)
                    GroupBox {
                        Text(placement.weighting)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity)
                    }
                }
                VStack(alignment: .leading) {
                    Text("同分參酌順序（由左至右）")
                        .font(.headline)
                    GroupBox {
                        Text(placement.tieSubjectOrder)
                            .frame(maxWidth: .infinity)
                    }
                }
                VStack(alignment: .leading) {
                    Text("最低錄取標準")
                        .font(.headline)
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Group {
                                HStack {
                                    Text("普通生錄取分數")
                                    Spacer()
                                    Text(placement.generalScore)
                                }
                                HStack {
                                    Text("普通生同分參酌")
                                    Spacer()
                                    Text(placement.generalTieScore == "" ? "-----" : placement.generalTieScore)
                                }
                                HStack {
                                    Text("原住民錄取分數")
                                    Spacer()
                                    Text(placement.indigenousScore)
                                }
                                HStack {
                                    Text("退伍軍人錄取分數")
                                    Spacer()
                                    Text(placement.veteranScore)
                                }
                                HStack {
                                    Text("僑生錄取分數")
                                    Spacer()
                                    Text(placement.overseasStudentScore)
                                }
                                HStack {
                                    Text("蒙藏生錄取分數")
                                    Spacer()
                                    Text(placement.mongolianScore)
                                }
                                HStack {
                                    Text("派外子女錄取分數")
                                    Spacer()
                                    Text(placement.overseasChildScore)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                VStack(alignment: .leading) {
                    Text("招生名額與錄取人數")
                        .font(.headline)
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Group {
                                HStack {
                                    Text("核定名額")
                                    Spacer()
                                    Text(placement.approvedQuota)
                                }
                                HStack {
                                    Text("回流名額")
                                    Spacer()
                                    Text(placement.returnQuota)
                                }
                                HStack {
                                    Text("招生名額")
                                    Spacer()
                                    Text(placement.admissionQuota)
                                }
                                HStack {
                                    Text("錄取人數 - 男")
                                    Spacer()
                                    Text(placement.admittedMale)
                                }
                                HStack {
                                    Text("錄取人數 - 女")
                                    Spacer()
                                    Text(placement.admittedFemale)
                                }
                                HStack {
                                    Text("外加錄取 - 男")
                                    Spacer()
                                    Text(placement.extraMale)
                                }
                                HStack {
                                    Text("外加錄取 - 女")
                                    Spacer()
                                    Text(placement.extraFemale)
                                }
                                HStack {
                                    Text("錄取總人數（含外加）")
                                    Spacer()
                                    Text(placement.totalAdmitted)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
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
                        Text(years.rawValue + " " + placement.schoolName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.brown)
                        Text(placement.departmentName)
                            .font(.system(size: 12))
                            .foregroundColor(Color(.systemGray2))
                    }
                }
            }
        }
        .overlay(alignment: .center) {
            if showCopyAlert {
                BlackAlertView(alert: "已成功複製校系至剪貼簿。", imageName: "checkmark.circle", showAlert: $showCopyAlert)
            }
        }
    }
}
