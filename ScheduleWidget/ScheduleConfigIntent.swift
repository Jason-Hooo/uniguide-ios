//
//  ScheduleConfigIntent.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/3/13.
//

import AppIntents
import FirebaseAuth
import FirebaseFirestore
import Firebase
import SwiftUI

struct ScheduleConfigIntent: WidgetConfigurationIntent {

    static var title: LocalizedStringResource = "倒數日小工具"
    static var description = IntentDescription("隨時關注你的重要日子，添加小組件後可長按選擇事件與主題。")
    
    @Parameter(title: "事件")
    var scheduleKind: ScheduleKind?
    
    @Parameter(title: "主題色彩", default: .douShaGreen)
    var color: ColorOption
        
    @Parameter(title: "啟用數字顏色", default: false)
    var isColoredText: Bool
    
}

enum ColorOption: String, AppEnum {
    case douShaGreen         // 豆沙綠
    case galaxyWhite         // 銀河白
    case almondYellow        // 杏仁黃
    case autumnLeafBrown     // 秋葉褐
    case blushRed            // 胭脂紅
    case grassGreen          // 青草綠
    case oceanBlue           // 海天藍
    case geJinPurple         // 葛巾紫
    case auroraGray          // 極光灰
    case appleGreen          // 蘋果綠
    case douShaGreenDark     // 豆沙綠-略暗

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "顏色"
    static var caseDisplayRepresentations: [ColorOption: DisplayRepresentation] = [
        .douShaGreen:     "豆沙綠",
        .galaxyWhite:     "銀河白",
        .almondYellow:    "杏仁黃",
        .autumnLeafBrown: "秋葉褐",
        .blushRed:        "胭脂紅",
        .grassGreen:      "青草綠",
        .oceanBlue:       "海天藍",
        .geJinPurple:     "葛巾紫",
        .auroraGray:      "極光灰",
        .appleGreen:      "蘋果綠",
        .douShaGreenDark: "豆沙綠-略暗"
    ]
    
    var color: Color {
        switch self {
        case .douShaGreen:     return Color(hex: "#C7EDCC")
        case .galaxyWhite:     return Color(hex: "#FFFFFF")
        case .almondYellow:    return Color(hex: "#FAF9DE")
        case .autumnLeafBrown: return Color(hex: "#FFF2E2")
        case .blushRed:        return Color(hex: "#FDE6E0")
        case .grassGreen:      return Color(hex: "#E3EDCD")
        case .oceanBlue:       return Color(hex: "#DCE2F1")
        case .geJinPurple:     return Color(hex: "#E9EBFE")
        case .auroraGray:      return Color(hex: "#EAEAEF")
        case .appleGreen:      return Color(hex: "#B7E8BD")
        case .douShaGreenDark: return Color(hex: "#CCE8CF")
        }
    }
}

struct ScheduleKind: AppEntity {
    var id: String
    var schedule: Schedule

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Widget Color"
    static var defaultQuery = ScheduleKindQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(schedule.title)")
    }
}


struct ScheduleKindQuery: EntityQuery {
    
    func entities(for identifiers: [ScheduleKind.ID]) async throws -> [ScheduleKind] {
        await getScheduleKinds()
    }
        
    func suggestedEntities() async throws -> [ScheduleKind] {
        await getScheduleKinds()
    }
        
    func defaultResult() async -> ScheduleKind? {
        await getScheduleKinds().first
    }
        
    private func getScheduleKinds() async -> [ScheduleKind] {
        let schedules = await getSchedulesData()
        return schedules.map { ScheduleKind(id: $0.id, schedule: $0) }
    }
    
    private func getSchedulesData() async -> [Schedule] {
        guard let currentUser = Auth.auth().currentUser else {
            print("no user")
            return []
        }
        
        let db = Firestore.firestore()
        let userDoc = db.collection("users").document(currentUser.uid)

        do {
            let snapshot = try await userDoc.collection("schedules").getDocuments()
            let schedules = try snapshot.documents.compactMap { document in
                try document.data(as: Schedule.self)
            }
            print("get schedules")
            return schedules
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
}
