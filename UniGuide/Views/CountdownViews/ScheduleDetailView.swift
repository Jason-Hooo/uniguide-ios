//
//  ScheduleDetailView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/1/26.
//

import SwiftUI

struct ScheduleDetailView: View {
    
    @EnvironmentObject private var schedulesManager: SchedulesManager
    @Environment(\.dismiss) private var dismiss
    var schedule: Schedule
    private let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
    @Environment(\.colorScheme) private var colorScheme
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    @State private var showEditScheduleView: Bool = false
    @State private var showDeletionAlert: Bool = false
    @State private var showResetAlert: Bool = false
    let showingKinds: [String] = ["年", "月", "週", "天"]
    @State private var selectedKind: String = "天"
    @State private var pinButtonIsPressed: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                GrayGridView()
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    Text(schedule.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.brown)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 20,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 20
                            )
                        )
                    
                    VStack(spacing: 10) {
                        TimelineView(.periodic(from: .now, by: 1)) { context in
                            let remainingTime = schedule.startDate.timeIntervalSince(context.date)
                            let days = remainingTime / 86400
                            if days <= -1 {
                                Text("已過了")
                                DaysText(
                                    targetDate: schedule.startDate,
                                    selectedKind: $selectedKind,
                                    correctDays: Int(-days),
                                    isPast: true
                                )
                                .font(.system(size: 120, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .foregroundColor(isDarkMode ? Color("veryDarkBrown").opacity(0.8) : .brown)
                                .padding(.horizontal)
                                .frame(height: 150)
                            } else if days > 0 {
                                Text("還剩下")
                                DaysText(
                                    targetDate: schedule.startDate,
                                    selectedKind: $selectedKind,
                                    correctDays: Int(ceil(days)),
                                    isPast: false
                                )
                                .font(.system(size: 120, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .foregroundColor(.orange.opacity(isDarkMode ? 0.75 : 1))
                                .padding(.horizontal)
                                .frame(height: 150)
                            } else {
                                Text("就是今天！")
                                    .bold()
                                    .font(.system(size: 60))
                                    .foregroundColor(isDarkMode ? Color("darkRed") : .red)
                                    .padding(.vertical, 50)
                            }
                        }
                                    
                        VStack(alignment: .leading) {
                            HStack {
                                let startWeekday = Calendar.current.component(.weekday, from: schedule.startDate)
                                Text("目標日：")
                                Text(schedule.startDate, style: .date)
                                Text("星期" + weekdays[startWeekday-1])
                            }
                            HStack {
                                if let endDate = schedule.endDate {
                                    let endWeekday = Calendar.current.component(.weekday, from: endDate)
                                    Text("結束日：")
                                    Text(endDate, style: .date)
                                    Text("星期" + weekdays[endWeekday-1])
                                }
                            }
                        }
                        .foregroundStyle(.gray)
                        .font(.system(size: 18))
                        .padding()
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(isDarkMode ? Color(.secondarySystemBackground) : .white)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 20,
                            bottomTrailingRadius: 20,
                            topTrailingRadius: 0
                        )
                    )
                }
                .shadow(color: isDarkMode ? .white.opacity(0.1) : .black.opacity(0.3),
                        radius: isDarkMode ? 15 : 10)
                .padding(.horizontal, 25)
                .padding(.bottom, 75)
            }
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .overlay(alignment: .top) {
                Text(schedule.isDefaultSchedule() ? "預設倒數日" : "自訂倒數日")
                    .font(.system(size: 20))
                    .fontWeight(.heavy)
                    .foregroundStyle(Color("myOrange"))
                HStack(spacing: 20) {
                    Image(systemName: "chevron.left")
                        .scaleEffect(1.3)
                        .background {
                            Circle()
                                .foregroundStyle(isDarkMode ? Color(.secondarySystemBackground) : Color("superLightGray"))
                                .frame(width: 38, height: 38)
                        }
                        .padding(.leading, 28)
                        .onTapGesture {
                            dismiss()
                        }
                    
                    Spacer()

                    Image(systemName: schedule.isPin ? "pin.fill" : "pin")
                        .scaleEffect(pinButtonIsPressed ? 0.7 : 1.0)
                        .background {
                            Circle()
                                .foregroundStyle(isDarkMode ? Color(.secondarySystemBackground) : Color("superLightGray"))
                                .frame(width: 38, height: 38)
                        }
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)) {
                                pinButtonIsPressed = true
                            }
                            let updateSchedule = Schedule(id: schedule.id, title: schedule.title, startDate: schedule.startDate, endDate: schedule.endDate, isPin: !schedule.isPin)
                            schedulesManager.updateSchedule(schedule: updateSchedule)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    pinButtonIsPressed = false
                                }
                            }
                        }
                    
                    Menu {
                        ShareLink(
                            item: Image(uiImage: generateSnapshot(schedule: schedule, selectedKind: selectedKind, isDarkMode: isDarkMode)),
                            preview: SharePreview(schedule.title, image: Image("uniGuide"))
                        ) {
                            Label("分享", systemImage: "square.and.arrow.up")
                        }
                        
                        Divider()
                        
                        NavigationLink {
                            EditScheduleView(schedule: schedule)
                        } label: {
                            Label("修改", systemImage: "square.and.pencil")
                        }
                        
                        if schedule.isDefaultSchedule() {
                            Button(role: .destructive) {
                                showResetAlert = true
                            } label: {
                                Label("重置", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
                            }
                        } else {
                            Button(role: .destructive) {
                                showDeletionAlert = true
                            } label: {
                                Label("刪除", systemImage: "trash.fill")
                            }
                        }
                    } label: {
                        Circle()
                            .foregroundStyle(
                                isDarkMode ?
                                Color(.secondarySystemBackground) :
                                    Color("superLightGray")
                            )
                            .frame(width: 38, height: 38)
                            .overlay(alignment: .center) {
                                Image(systemName: "ellipsis")
                                    .scaleEffect(1.3)
                            }
                    }
                    .padding(.trailing, 16)
                }
                .foregroundStyle(Color("myOrange"))
            }
            .overlay(alignment: .bottom) {
                SegmentControlView(
                    segments: showingKinds,
                    selected: $selectedKind,
                    mainColor: .brown,
                    titleSelectedColor: .white,
                    cornerRadius: 22,
                    textSize: 20,
                    needBackground: true
                )
                .frame(height: 38)
                .padding(25)
                .padding(.bottom, 30)
                .padding(.trailing, 8)
            }
        }
        .confirmationDialog("確認要刪除此事件嗎？此動作將無法返回", isPresented: $showDeletionAlert, titleVisibility: .visible) {
            Button("刪除", role: .destructive) {
                schedulesManager.deleteSchedule(schedule: schedule)
                dismiss()
            }
            Button("取消", role: .cancel) {}
        }
        .confirmationDialog("確認要重置為預設倒數日嗎？當前事件內容將會被覆蓋", isPresented: $showResetAlert, titleVisibility: .visible) {
            Button("重置", role: .destructive) {
                schedulesManager.resetSchedule(schedule: schedule)
            }
            Button("取消", role: .cancel) {}
        }
    }

}

struct DaysText: View {
    
    var targetDate: Date
    @Binding var selectedKind: String
    let correctDays: Int
    var isPast: Bool
    
    var body: some View {
        let calendar = Calendar.current
        if selectedKind == "年" {
            let components = calendar.dateComponents([.year, .month, .day], from: Date(), to: targetDate)
            if let componentsYears = components.year, let componentsMonths = components.month, let componentsDays = components.day {
                let years = isPast ? -componentsYears : componentsYears
                let months = isPast ? -componentsMonths : componentsMonths
                let days = isPast ? -componentsDays : componentsDays + 1
                Text("\(years)年\(months)個月\(days)天")
            }
        } else if selectedKind == "月" {
            let components = calendar.dateComponents([.month, .day], from: Date(), to: targetDate)
            if let componentsMonths = components.month, let componentsDays = components.day {
                let months = isPast ? -componentsMonths : componentsMonths
                let days = isPast ? -componentsDays : componentsDays + 1
                Text("\(months)個月\(days)天")
            }
        } else if selectedKind == "週" {
            let weeks = Int(correctDays / 7)
            let days = correctDays % 7
            Text("\(weeks)週\(days)天")
        } else if selectedKind == "天" {
            Text("\(correctDays)")
        }
    }
    
}
    
    
#Preview {
    let schedule = Schedule(
        title: "喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔",
        startDate: Date().addingTimeInterval(86400 * 320),
        endDate: Date().addingTimeInterval(86400 * 320),
        isPin: true
    )
    ScheduleDetailView(schedule: schedule)
}
    /*
     var components = calendar.dateComponents([.day], from: Date(), to: targetDate)
     if let componentsDay = components.day {
     
     }
     Text("\(days)")
     .font(.system(size: 120))
     .bold()
     .lineLimit(1)
     .minimumScaleFactor(0.4)
     .foregroundColor(
     isPast ?
     (isDarkMode ? Color("veryDarkBrown").opacity(0.8) : .brown) :
     .orange.opacity(isDarkMode ? 0.75 : 1)
     )
     .padding(.horizontal)
     .frame(height: 150)
     }
     */

/*
 struct TabDetailView: View {
     @Binding var currentSchedule: Schedule
     @Binding var allSchedules: [Schedule]
     
     var body: some View {
         TabView(selection: $currentSchedule.id) {
             ForEach($allSchedules, id: \.id) { $schedule in
                 ScheduleDetailView(schedule: $schedule)
                     .tag(schedule.id)
             }
         }
         .tabViewStyle(.page(indexDisplayMode: .never))
     }
 }
 */
