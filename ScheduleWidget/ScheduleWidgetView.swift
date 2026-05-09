//
//  ScheduleWidgetView.swift
//  ScheduleWidgetExtension
//
//  Created by 何杰陞 on 2025/3/14.
//

import Foundation
import WidgetKit
import SwiftUI

struct ScheduleWidgetView : View {
    
    @Environment(\.colorScheme) private var colorScheme
    private var isDarkMode: Bool {
        return colorScheme == .dark
    }
    var entry: ScheduleProvider.Entry
    private var schedule: Schedule {
        return entry.scheduleKind.schedule
    }
    let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
    
    var body: some View {
        VStack(spacing: 0) {
            Text(schedule.title)
                .font(.headline)
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(.brown)
            
            let remainingTime = schedule.startDate.timeIntervalSince(Date())
            let days = remainingTime / 86400
            if days <= -1 {
                HStack {
                    Text("已過了")
                        .font(.system(size: 12, design: .rounded))
                        .padding(.leading)
                        .frame(height: 20)
                        .background(.blue)
                    Spacer()
                }
                Text("\(Int(-days))")
                    .font(.system(size: 60, weight: .black))
                    .foregroundStyle(isDarkMode ? Color("veryDarkBrown").opacity(0.8) : .brown)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .padding(.horizontal)
                    .background(.yellow)
            } else if days > 0 {
                HStack {
                    Text("還剩下")
                        .font(.system(size: 12, design: .rounded))
                        .padding([.leading, .top])
                    Spacer()
                }
                Text("\(Int(ceil(days)))")
                    .font(.system(size: 60, weight: .black))
                    .foregroundStyle(.orange.opacity(isDarkMode ? 0.75 : 1))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.horizontal)
            } else {
                Text("就是今天！")
                    .font(.system(size: 15))
                    .foregroundColor(isDarkMode ? Color("darkRed") : .red)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                let startWeekday = Calendar.current.component(.weekday, from: schedule.startDate)
                Text("目標日：\(schedule.startDate, style: .date) 星期\(weekdays[startWeekday - 1])")
                    .font(.system(size: 20))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
                    .background(.blue)
                if let endDate = schedule.endDate {
                    let endWeekday = Calendar.current.component(.weekday, from: endDate)
                    Text("結束日：\(endDate, style: .date) 星期\(weekdays[endWeekday - 1])")
                        .font(.system(size: 20))
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .frame(maxWidth: .infinity)
                        .frame(height: 20)
                        .background(.red)
                }
            }
            .foregroundStyle(.gray)
            
        }
        .containerBackground(isDarkMode ? Color(.secondarySystemBackground) : .white, for: .widget)
        .widgetURL(URL(string: "UniGuide://CreateWithSwift"))
        .onAppear {
            print("widget view refresh")
        }
    }
    
}

