//
//  ScreenshotView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/2/23.
//

import SwiftUI

struct ScreenshotView: View {
    
    let schedule: Schedule
    let selectedKind: String
    let isDarkMode: Bool
    let darkModeSecondarySystemBackground: Color = Color(28, 28, 30)
    private let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
    
    var body: some View {
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
                        let remainingTime = schedule.startDate.timeIntervalSince(Date())
                        let days = remainingTime / 86400
                        if days <= -1 {
                            Text("已過了")
                                .foregroundStyle(isDarkMode ? .white : .black)
                            ScreenshotDaysText(
                                targetDate: schedule.startDate,
                                selectedKind: selectedKind,
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
                                .foregroundStyle(isDarkMode ? .white : .black)
                            ScreenshotDaysText(
                                targetDate: schedule.startDate,
                                selectedKind: selectedKind,
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
                    .background(isDarkMode ? darkModeSecondarySystemBackground : .white)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 20,
                            bottomTrailingRadius: 20,
                            topTrailingRadius: 0
                        )
                    )
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .shadow(color: isDarkMode ? .white.opacity(0.1) : .black.opacity(0.3),
                                radius: isDarkMode ? 15 : 10)
                    // shadow直接作用在VStack的話截圖文字會有灰色背景
                )
                .padding(.horizontal, 25)
                .padding(.bottom, 60)
        }
        .background(isDarkMode ? .black : .white)
        .overlay(alignment: .bottom) {
            HStack {
                Image("uniGuide")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 34, height: 34)
                    .clipShape(.rect(cornerRadius: 6))
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                Text(" UniGuide - 你的分科好夥伴")
                    .font(.custom("GenJyuuGothicX-Bold", size: 17))
                    .foregroundStyle(.brown)
            }
            .padding(.bottom, 20)
        }
    }
    
}

@MainActor
func generateSnapshot(schedule: Schedule, selectedKind: String, isDarkMode: Bool) -> UIImage {
    let targetView = ScreenshotView(
        schedule: schedule,
        selectedKind: selectedKind,
        isDarkMode: isDarkMode
    )
    .frame(width: 393, height: 500)
    let renderer = ImageRenderer(content: targetView)
    renderer.scale = UIScreen.main.scale

    return renderer.uiImage ?? UIImage()
}

struct ScreenshotDaysText: View {
    
    var targetDate: Date
    let selectedKind: String
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
    ScreenshotView(schedule: schedule, selectedKind: "天", isDarkMode: true)
}
