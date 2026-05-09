//
//  ScheduleDatePickerView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/2/12.
//

import SwiftUI

struct ScheduleDatePicker: View {
    
    @Binding var selectedDate: Date
    var isStartDate: Bool
    @State private var showSheet = false
    let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
    @Environment(\.colorScheme) private var colorScheme
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    var body: some View {
        
        let year = Calendar.current.component(.year, from: selectedDate)
        let month = Calendar.current.component(.month, from: selectedDate)
        let day = Calendar.current.component(.day, from: selectedDate)
        let weekday = Calendar.current.component(.weekday, from: selectedDate)
        
        VStack(alignment: .leading) {
            Text(isStartDate ? "選擇目標日期" : "選擇結束日期")
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(isDarkMode ? .lightGray : .darkGray))
            HStack {
                Text("\(year)年\(month)月\(day)日 星期" + weekdays[weekday-1])
                    .bold()
                Spacer()
                Image(systemName: showSheet ? "chevron.up.square" : "chevron.down.square")
                    .scaleEffect(1.3)
            }
            .foregroundColor(Color("darkBrown"))
            .font(.system(.body, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(.systemGray4), lineWidth: 1.5)
            )
            .onTapGesture {
                showSheet.toggle()
            }
            .padding(.vertical, 10)
        }
        .sheet(isPresented: $showSheet) {
            VStack(alignment: .center) {
                Text(isStartDate ? "選擇未來日期倒數，過去日期正數" : "什麼時候會結束呢？")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(Color(.systemGray2))
                DatePicker(
                    "日期",
                    selection: $selectedDate,
                    in: Calendar.current.date(from: DateComponents(year: 1901, month: 1, day: 1))!...Calendar.current.date(from: DateComponents(year: 2099, month: 12, day: 31))!, // 不限制年份範圍的話，太久遠的年代會差六分鐘，千萬別亂改
                    displayedComponents: .date
                )
                .labelsHidden()
                .datePickerStyle(.graphical)
                .tint(.brown)
                .presentationDetents([.height(450)]) // sheet modifier
                .presentationBackground(.thinMaterial) // sheet modifier
                .presentationCornerRadius(20) // sheet modifier
            }
        }
    }
    
}

#Preview {
    @Previewable @State var date = Date()
    ScheduleDatePicker(selectedDate: $date, isStartDate: true)
}
