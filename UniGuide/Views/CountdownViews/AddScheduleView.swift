//
//  AddScheduleView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/1/26.
//

import Foundation
import SwiftUI

struct AddScheduleView: View {
    
    @EnvironmentObject var schedulesManager: SchedulesManager
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var startDate = Date.now
    @State private var endDate = Date.now
    @State private var showEndDatePicker = false
    @State private var isPin: Bool = false
    @State private var showBackAlert: Bool = false
    @State private var showNeedTitleAlert: Bool = false
    @State private var showEndDateWrongAlert: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    ShortForm(label: "事件名稱", hintWords: "輸入事件標題", value: $title)
                    Divider()
                    ScheduleDatePicker(selectedDate: $startDate, isStartDate: true)
                    Divider()
                    Toggle(isOn: $isPin) {
                        Text("釘選這個事件")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(Color(isDarkMode ? .lightGray : .darkGray))
                    }
                    .tint(Color("darkBrown"))
                    Divider()
                    Toggle(isOn: $showEndDatePicker) {
                        Text("使用結束日期")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(Color(isDarkMode ? .lightGray : .darkGray))
                    }
                    .tint(Color("darkBrown"))
                    if showEndDatePicker {
                        Divider()
                        ScheduleDatePicker(selectedDate: $endDate, isStartDate: false)
                            .animation(.spring, value: showEndDatePicker)
                    }
                }
                .padding(.top, 10)
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showBackAlert = true
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color("cream"))
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("新增事件")
                        .font(.custom("GenJyuuGothicX-Medium", size: 20))
                        .foregroundStyle(Color("cream"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    scheduleAddSaveButton(
                        title: $title,
                        startDate: $startDate,
                        endDate: $endDate,
                        showEndDatePicker: $showEndDatePicker,
                        isPin: $isPin,
                        showNeedTitleAlert: $showNeedTitleAlert,
                        showEndDateWrongAlert: $showEndDateWrongAlert
                    )
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .gesture( // 用 .gesture 的話會取代原本的返回手勢，用simultaneousGesture有時會有bug
                DragGesture()
                    .onChanged { value in
                        if value.startLocation.x < 27 && value.translation.width > 10 {
                            showBackAlert = true
                        }
                    }
            )
            .toolbarBackground(.brown, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .alert(Text("確認要放棄所有當前操作嗎？"), isPresented: $showBackAlert) {
            Button("取消", role: .cancel) {}
            Button("確定", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("此動作將無法還原")
        }
        .overlay(alignment: .center) {
             // showNeedTitleAlert == false 時不會顯示此 View
            if showNeedTitleAlert {
                BlackAlertView(alert: "事件標題不可為空白", imageName: "exclamationmark.circle", showAlert: $showNeedTitleAlert)
            } else if showEndDateWrongAlert {
                BlackAlertView(alert: "結束日期必須大於目標日期", imageName: "exclamationmark.circle", showAlert: $showEndDateWrongAlert)
            }
        }
    }
}





struct scheduleAddSaveButton: View {
    
    @EnvironmentObject var schedulesManager: SchedulesManager
    @Environment(\.dismiss) var dismiss
    @Binding var title: String
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var showEndDatePicker: Bool
    @Binding var isPin: Bool
    @Binding var showNeedTitleAlert: Bool
    @Binding var showEndDateWrongAlert: Bool
    
    var body: some View {
        Button {
            startDate = Calendar.current.startOfDay(for: startDate) // 讓時間是凌晨十二點
            endDate = Calendar.current.startOfDay(for: endDate)
            if !title.isBlank && (endDate > startDate) && showEndDatePicker
                || !title.isBlank && !showEndDatePicker {
                // extension of String 判斷字串是否為空(包含空格)
                let newSchedule: Schedule = Schedule(
                    title: title,
                    startDate: startDate,
                    endDate: showEndDatePicker == true ? endDate : nil,
                    isPin: isPin
                )
                schedulesManager.createSchedule(schedule: newSchedule)
                dismiss()
            } else {
                if title.isBlank {
                    withAnimation(.spring(duration: 0.3)) {
                        showNeedTitleAlert = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showNeedTitleAlert = false
                        }
                    }
                } else if endDate <= startDate {
                    withAnimation(.spring(duration: 0.3)) {
                        showEndDateWrongAlert = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showEndDateWrongAlert = false
                        }
                    }
                }
            }
        } label: {
            Text("保存")
                .font(.headline)
                .foregroundStyle(Color("cream"))
        }
    }
    
}

#Preview {
    @Previewable @StateObject var schedulesManager = SchedulesManager.shared
    AddScheduleView()
}
