//
//  ScheduleProvider.swift
//  ScheduleWidgetExtension
//
//  Created by 何杰陞 on 2025/3/13.
//

import Foundation
import WidgetKit

struct ScheduleProvider: AppIntentTimelineProvider {
    
    let defaultScheduleKind: ScheduleKind = ScheduleKind(
        id: "e3ikmd",
        schedule: Schedule(
            id: "ji2oe",
            title: "載入中...",
            startDate: Date(),
            endDate: Date(),
            isPin: false
        )
    )
    
    func placeholder(in context: Context) -> ScheduleEntry {
        return ScheduleEntry(date: Date(), scheduleKind: defaultScheduleKind)
    }

    func snapshot(for configuration: ScheduleConfigIntent, in context: Context) async -> ScheduleEntry {
        ScheduleEntry(
            date: Date(),
            scheduleKind: configuration.scheduleKind ?? defaultScheduleKind
        )
    }
    
    func timeline(for configuration: ScheduleConfigIntent, in context: Context) async -> Timeline<ScheduleEntry> {
        let currentDate = Date()
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: currentDate)
        let nextMidnight = calendar.date(byAdding: .day, value: 1, to: midnight)!
        let entries = [ScheduleEntry(
            date: currentDate,
            scheduleKind: configuration.scheduleKind ?? defaultScheduleKind)
        ]
        print("refresh timeline")
        return Timeline(entries: entries, policy: .after(nextMidnight))
    }


//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}
