//
//  oneScheduleView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/1/26.
//

import SwiftUI

struct OneScheduleView: View {
    
    @EnvironmentObject private var schedulesManager: SchedulesManager
    var schedule: Schedule
    private let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
    @Environment(\.colorScheme) private var colorScheme
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    var body: some View {
        NavigationLink {
            ScheduleDetailView(schedule: schedule)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(isDarkMode ? Color("khaki").opacity(0.9) : Color("cream"))
                    .shadow(color: isDarkMode ? .white.opacity(0.3) : .black.opacity(0.23), radius: 10, y: 3)
                    .overlay(alignment: .bottomTrailing) {
                        if schedule.isDefaultSchedule() {
                            Image(isDarkMode ? "blackU" : "whiteU")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 17, height: 17)
                                .padding()
                        }
                    }
                
                VStack(alignment: .leading, spacing: 10) {
                    // 標題行
                    HStack(alignment: .top) {
                        Text(schedule.title)
                            .font(.system(size: 15))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.6)
                        Spacer()
                        if schedule.isPin {
                            Image(systemName: "pin.fill")
                                .foregroundStyle(Color(isDarkMode ? "veryDarkBrown" : "myOrange"))
                                .rotationEffect(Angle(degrees: 43))
                        }
                    }
                    
                    // 倒數計時
                    TimelineView(.periodic(from: .now, by: 1)) { context in
                        HStack {
                            let remainingTime = schedule.startDate.timeIntervalSince(context.date)
                            let days = remainingTime / 86400
                            if days <= -1 {
                                Text("已過了")
                                Text("\(Int(-days))")
                                    .font(.system(size: 23))
                                    .foregroundColor(
                                        isDarkMode ? Color("veryDarkBrown").opacity(0.8) : .brown
                                    )
                                    .bold()
                                Text("天")
                            } else if days > 0 {
                                Text("還剩下")
                                Text("\(Int(ceil(days)))")
                                    .font(.system(size: 23))
                                    .foregroundColor(.orange.opacity(isDarkMode ? 0.75 : 1))
                                    .bold()
                                Text("天")
                            } else {
                                Text("就是今天！")
                                    .bold()
                                    .font(.system(size: 23))
                                    .foregroundColor(isDarkMode ? Color("darkRed") : .red)
                            }
                        }
                        .font(.system(size: 20))
                    }
                    
                    // 日期行
                    HStack {
                        Text(schedule.startDate, style: .date)
                        Text("星期" + weekdays[Calendar.current.component(.weekday, from: schedule.startDate) - 1])
                    }
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 99/255, green: 110/255, blue: 114/255))
                }
                .padding()
            }
        }
        .foregroundStyle(.primary)
    }
}
//     schedule.date 與 Date() 都是UTC，直接計算時間差
//     Date型別固定是UTC，但datePicker可以選本地日期時間，但變數內容會是UTC時間

#Preview {
    let schedule = Schedule(
        title: "測試用喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔喔",
        startDate: Date(),
        endDate: nil,
        isPin: true
    )
    
    OneScheduleView(schedule: schedule)
    
}

//if !isLoading {
//
//} else {
//    HStack {
//        Text("倒數日載入中")
//            .foregroundStyle(isDarkMode ? Color("veryLightGray") : Color(.systemGray2))
//        ProgressView()
//    }
//} 這邊的在 view 消失後會保存 State isLoading 的值至下一次使用，但通常是不會（有實驗過）才對啊

