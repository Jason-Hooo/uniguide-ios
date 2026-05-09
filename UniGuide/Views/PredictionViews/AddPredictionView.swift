//
//  PlacementAnalysisView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/2.
//

import Foundation
import SwiftUI

struct AddPredictionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var predictionRecordsManager: PredictionRecordsManager
    @EnvironmentObject private var userDataManager: UserDataManager
    
    // 新增：落點分析名稱
    @State private var analysisName: String = ""
    
    // 分科測驗成績輸入選項
    @State private var placementInputType: ScoresInputType = .level
    @State private var placementLevelScores: [String: String] = [:] // 級分輸入
    @State private var placementPercentScores: [String: String] = [:] // 百分比輸入
    @State private var placementCurrentScores: [String: String] = [:] // 今年成績輸入
    
    // 學測成績輸入選項
    @State private var gsatInputType: ScoresInputType = .level
    @State private var gsatLevelScores: [String: String] = [:] // 級分輸入
    @State private var gsatPercentScores: [String: String] = [:] // 百分比輸入
    @State private var gsatCurrentScores: [String: String] = [:] // 今年成績輸入
    
    // 英聽成績
    @State private var englishListening: EnglishListening = .none
    
    @State private var showIntroductionSheet: Bool = false
    @State private var showDeductEnergiesAlert: Bool = false
    @State private var isAnalysisNameBlank: Bool = false
    @State private var position = ScrollPosition(edge: .top)
    
    private let placementSubjectNames = ["數學甲", "數學乙", "物理", "化學", "生物", "歷史", "地理", "公民與社會"]
    private let gsatSubjectNames = ["國文", "英文", "數學A", "數學B", "社會", "自然"]
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(colorScheme == .dark ? Color.gray.opacity(0.15) : .white)
            .shadow(
                color: colorScheme == .dark ? .clear : Color.black.opacity(0.08),
                radius: 12, x: 0, y: 4
            )
    }
    
    var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    analysisNameSection
                    
                    placementSection
                    
                    gsatSection
                    
                    englishListeningSection
                    
                    analyzeButton
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .scrollPosition($position)
            .background(
                LinearGradient(
                    colors: colorScheme == .dark ?
                    [Color.black.opacity(0.9), Color.gray.opacity(0.2)] :
                        [Color("myOrange").opacity(0.05), Color("khaki").opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color("khaki"))
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("新增落點分析")
                        .font(.custom("GenJyuuGothicX-Medium", size: 20))
                        .foregroundStyle(.brown)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showIntroductionSheet = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(Color("khaki"))
                            .bold()
                    }
                }
            }
            .alert(Text("確認要進行落點分析嗎？"), isPresented: $showDeductEnergiesAlert) {
                Button("取消", role: .cancel) {}
                Button("確定", role: .destructive) {
                    let placementScores: [String: String] = switch placementInputType {
                    case .level:   placementLevelScores
                    case .percent: placementPercentScores
                    case .current: placementCurrentScores
                    }

                    let gsatScores: [String: String] = switch gsatInputType {
                    case .level:   gsatLevelScores
                    case .percent: gsatPercentScores
                    case .current: gsatCurrentScores
                    }
                    
                    let predictionRecord = PredictionRecord(
                        analysisName: analysisName,
                        placementInputType: placementInputType.rawValue,
                        placementScores: placementScores,
                        gsatInputType: gsatInputType.rawValue,
                        gsatScores: gsatScores,
                        englishListening: englishListening.rawValue
                    )
                    
                    predictionRecordsManager.createPredictionRecord(predictionRecord: predictionRecord)
                    
//                    predictAdmission(
//                        analysisName: analysisName,
//                        placementInputType: placementInputType,
//                        placementScores: placementScores,
//                        gsatInputType: gsatInputType,
//                        gsatScores: gsatScores,
//                        englishListening: englishListening
//                    )
                    
                    userDataManager.changeEnergies(amount: -1)
                    
                    dismiss()
                }
            } message: {
                Text("執行此動作將扣除 1 點能量")
            }
            .sheet(isPresented: $showIntroductionSheet) {
                PredictionGuideView()
                    .presentationBackground(.thinMaterial)
            }
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
    
    }
    
    private var analysisNameSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("落點分析名稱")
                .font(.custom("GenJyuuGothicX-Normal", size: 20))
                .fontWeight(.bold)
                .foregroundStyle(colorScheme == .dark ? .white : Color("myOrange"))
            
            VStack(alignment: .leading, spacing: 10) {
                TextField("請輸入本次分析名稱", text: $analysisName)
                    .submitLabel(.done)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                            .stroke(isAnalysisNameBlank ? .red : .clear, lineWidth: 1.5)
                    )
                    .onChange(of: analysisName) { // 再紅色空框出現後，重新輸入不為空的字串錯誤提示就要消失
                        if !analysisName.isBlank {
                            isAnalysisNameBlank = false // isAnalysisNameBlank 是開啟紅色空框的開關
                        }
                    }
                
                if isAnalysisNameBlank {
                    Text("落點分析名稱不可為空")
                        .foregroundColor(.red)
                        .font(.system(size: 13))
                }
            }
        }
        .padding(20)
        .background(cardBackground)
    }
    
    private var placementSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("分科測驗成績")
                .font(.custom("GenJyuuGothicX-Normal", size: 20))
                .fontWeight(.bold)
                .foregroundStyle(colorScheme == .dark ? .white : Color("myOrange"))

            SegmentControlView(
                segments: ScoresInputType.allCases.map { $0.rawValue },
                selected: Binding(
                    get: { placementInputType.rawValue },
                    set: { newValue in
                        if let type = ScoresInputType.allCases.first(where: { $0.rawValue == newValue }) {
                            placementInputType = type
                        }
                    }
                ),
                mainColor: Color("khaki"),
                titleSelectedColor: .white,
                cornerRadius: 20,
                textSize: 17,
                needBackground: true
            )
            .frame(height: 35)
            .padding(.trailing)
            
            Text(placementInputType.description)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            
            // 成績輸入網格
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 16) {
                ForEach(placementSubjectNames, id: \.self) { subject in
                    ScoreInputField(
                        title: subject,
                        value: Binding(
                            get: {
                                switch placementInputType {
                                case .level:
                                    return placementLevelScores[subject] ?? ""
                                case .percent:
                                    return placementPercentScores[subject] ?? ""
                                case .current:
                                    return placementCurrentScores[subject] ?? ""
                                }
                            },
                            set: { newValue in
                                switch placementInputType {
                                case .level:
                                    if newValue.isEmpty {
                                        placementLevelScores.removeValue(forKey: subject)
                                    } else {
                                        placementLevelScores[subject] = newValue
                                    }
                                case .percent:
                                    if newValue.isEmpty {
                                        placementPercentScores.removeValue(forKey: subject)
                                    } else {
                                        placementPercentScores[subject] = newValue
                                    }
                                case .current:
                                    if newValue.isEmpty {
                                        placementCurrentScores.removeValue(forKey: subject)
                                    } else {
                                        placementCurrentScores[subject] = newValue
                                    }
                                }
                            }
                        ),
                        inputType: placementInputType
                    )
                }
            }
        }
        .padding(20)
        .background(cardBackground)
    }
    
    private var gsatSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("學測成績")
                .font(.custom("GenJyuuGothicX-Normal", size: 20))
                .fontWeight(.bold)
                .foregroundStyle(colorScheme == .dark ? .white : Color("myOrange"))

            SegmentControlView(
                segments: ScoresInputType.allCases.map { $0.rawValue },
                selected: Binding( // 創建一個 Binding 變數
                    get: { gsatInputType.rawValue },
                    set: { newValue in
                        if let type = ScoresInputType.allCases.first(where: { $0.rawValue == newValue }) {
                            gsatInputType = type
                        }
                    }
                ),
                mainColor: Color("khaki"),
                titleSelectedColor: .white,
                cornerRadius: 20,
                textSize: 17,
                needBackground: true
            )
            .frame(height: 35)
            .padding(.trailing)
            
            Text(gsatInputType.description)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            
            // 成績輸入網格
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 16) {
                ForEach(gsatSubjectNames, id: \.self) { subject in
                    ScoreInputField(
                        title: subject,
                        value: Binding(
                            get: {
                                switch gsatInputType {
                                case .level:
                                    return gsatLevelScores[subject] ?? ""
                                case .percent:
                                    return gsatPercentScores[subject] ?? ""
                                case .current:
                                    return gsatCurrentScores[subject] ?? ""
                                }
                            },
                            set: { newValue in
                                switch gsatInputType {
                                case .level:
                                    if newValue.isBlank {
                                        gsatLevelScores.removeValue(forKey: subject)
                                    } else {
                                        gsatLevelScores[subject] = newValue
                                    }
                                case .percent:
                                    if newValue.isBlank {
                                        gsatPercentScores.removeValue(forKey: subject)
                                    } else {
                                        gsatPercentScores[subject] = newValue
                                    }
                                case .current:
                                    if newValue.isBlank {
                                        gsatCurrentScores.removeValue(forKey: subject)
                                    } else {
                                        gsatCurrentScores[subject] = newValue
                                    }
                                }
                            }
                        ),
                        inputType: gsatInputType
                    )
                }
            }
        }
        .padding(20)
        .background(cardBackground)
    }
    
    private var englishListeningSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 9) {
                Text("英聽成績")
                    .font(.custom("GenJyuuGothicX-Normal", size: 20))
                    .fontWeight(.bold)
                    .foregroundStyle(colorScheme == .dark ? .white : Color("myOrange"))
                
                Text("若未選擇，會漏失要檢定英文聽力之科系")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }
            
            EnglishListeningMenuPicker(
                options: EnglishListening.allCases,
                selectedValue: $englishListening
            )
        }
        .padding(20)
        .background(cardBackground)
    }
    
    private var analyzeButton: some View {
        Button {
            if !analysisName.isBlank {
                showDeductEnergiesAlert = true
            } else {
                isAnalysisNameBlank = true
                withAnimation {
                    position.scrollTo(edge: .top)
                }
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "pencil.and.list.clipboard")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("開始落點分析")
                    .font(.custom("GenJyuuGothicX-Normal", size: 18))
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [Color("myOrange"), Color("myOrange").opacity(0.5)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(
                color: Color("myOrange").opacity(0.3),
                radius: 12, x: 0, y: 6
            )
            .scaleEffect(1.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: true)
        }
        .padding(.top, 8)
    }
    
}

struct ScoreInputField: View {
    
    let title: String
    @Binding var value: String
    let inputType: ScoresInputType
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(colorScheme == .dark ? .white : Color("myOrange"))
            
            HStack {
                TextField(inputType == .percent ? "0-100" : "0-60", text: $value)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 16, weight: .medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                    )
                    .onChange(of: value) { oldValue, newValue in
                        validateInput(newValue: newValue, oldValue: oldValue)
                    }
                
                Text(inputType == .percent ? "%" : "級")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 8)
            }
        }
    }
    
    private func validateInput(newValue: String, oldValue: String) {
        if !newValue.isEmpty { // 不等於 "" 才需要管
            let maxValue = (inputType == .percent ? Double(100) : Double(60))
            
            if let doubleValue = Double(newValue) {
                if inputType != .percent && newValue.contains(".") {
                    value = oldValue
                    return
                }
                if inputType == .percent && hasMoreThanThreeDecimalPlaces(newValue) {
                    value = oldValue
                    return
                }
                if doubleValue < 0 || doubleValue > maxValue {
                    value = oldValue
                } else {
                    value = newValue
                }
            } else {
                value = oldValue
            }
        }

    }
    
    func hasMoreThanThreeDecimalPlaces(_ number: String) -> Bool {
        if let decimalPart = number.split(separator: ".").last {
            return decimalPart.count > 3
        }
        return false
    }
    
}

struct EnglishListeningMenuPicker: View {
    let options: [EnglishListening]
    @Binding var selectedValue: EnglishListening
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option.rawValue) {
                    selectedValue = option
                }
            }
        } label: {
            HStack {
                Text(selectedValue.rawValue)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(selectedValue == .none ? .secondary : Color("myOrange"))
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
            )
        }
    }
}


