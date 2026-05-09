//
//  ScheduleWidget.swift
//  ScheduleWidget
//
//  Created by 何杰陞 on 2025/3/13.
//

import WidgetKit
import SwiftUI

struct ScheduleWidget: Widget {
    
    let kind: String = "ScheduleWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ScheduleConfigIntent.self,
            provider: ScheduleProvider()
        ) { entry in
            ScheduleWidgetView(entry: entry)
        }
        .configurationDisplayName("倒數日小工具")
        .description("隨時關注你的重要日子，添加小組件後可長按選擇事件與主題。")
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall, .systemMedium])
    }
    
}

//#Preview(as: .systemSmall) {
//    ScheduleWidget()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}
