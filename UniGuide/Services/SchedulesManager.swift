//
//  UserDataManager.swift
//  UniGuide
//
//  Created by 何杰陞 on 2024/12/29.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

@MainActor
class SchedulesManager: ObservableObject {
    
    static let shared = SchedulesManager()
    @Published var schedules: [Schedule] = []
    @Published var isDataLoading: Bool = true
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    private var defaultSchedules: [Schedule] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return [
            Schedule(id: "00",
                     title: "發售-「大學術科考試簡章」",
                     startDate: dateFormatter.date(from: "2024/08/06")!,
                     endDate: dateFormatter.date(from: "2024/11/12")!,
                     isPin: false),
            
            Schedule(id: "01",
                     title: "發售-「考試簡章(高中英語聽力測驗、學科能力測驗、分科測驗)」",
                     startDate: dateFormatter.date(from: "2024/08/06")!,
                     endDate: dateFormatter.date(from: "2025/07/12")!,
                     isPin: false),
            
            Schedule(id: "02",
                     title: "公告-「檢定英聽系組」",
                     startDate: dateFormatter.date(from: "2024/08/30")!,
                     endDate: nil,
                     isPin: false),
            
            Schedule(id: "03",
                     title: "報名-「高中英語聽力測驗(第一次考試)」",
                     startDate: dateFormatter.date(from: "2024/09/06")!,
                     endDate: dateFormatter.date(from: "2024/09/13")!,
                     isPin: false),
            
            Schedule(id: "04",
                     title: "考試-「高中英語聽力測驗(第一次考試)」",
                     startDate: dateFormatter.date(from: "2024/10/19")!,
                     endDate: nil,
                     isPin: false),
            
            Schedule(id: "05",
                     title: "公告-「參採學測系組、採計術科系組」",
                     startDate: dateFormatter.date(from: "2024/10/25")!,
                     endDate: nil,
                     isPin: false),
            
            Schedule(id: "06",
                     title: "報名-「大學術科考試」",
                     startDate: dateFormatter.date(from: "2024/10/29")!,
                     endDate: dateFormatter.date(from: "2024/11/12")!,
                     isPin: false),
            
            Schedule(id: "07",
                     title: "報名-「學科能力測驗」",
                     startDate: dateFormatter.date(from: "2024/10/29")!,
                     endDate: dateFormatter.date(from: "2024/11/12")!,
                     isPin: false),
            
            Schedule(id: "08",
                     title: "公告-「校系分則(開放校系分則查詢系統)」",
                     startDate: dateFormatter.date(from: "2024/11/04")!,
                     endDate: nil,
                     isPin: false),
            
            Schedule(id: "09",
                     title: "報名-「高中英語聽力測驗 (第二次考試)」",
                     startDate: dateFormatter.date(from: "2024/11/06")!,
                     endDate: dateFormatter.date(from: "2024/11/12")!,
                     isPin: false),
            
            Schedule(id: "10",
                     title: "發售-「分發入學招生簡章」",
                     startDate: dateFormatter.date(from: "2024/12/02")!,
                     endDate: dateFormatter.date(from: "2025/08/04")!,
                     isPin: false),
            
            Schedule(id: "11",
                     title: "考試-「高中英語聽力測驗 (第二次考試)」",
                     startDate: dateFormatter.date(from: "2024/12/14")!,
                     endDate: nil,
                     isPin: false),
            
            Schedule(id: "12",
                     title: "考試-「學科能力測驗」",
                     startDate: dateFormatter.date(from: "2025/01/18")!,
                     endDate: dateFormatter.date(from: "2025/01/20")!,
                     isPin: false),
            
            Schedule(id: "13",
                     title: "考試-「大學術科考試(體育組、音樂組及美術組)」",
                     startDate: dateFormatter.date(from: "2025/01/22")!,
                     endDate: dateFormatter.date(from: "2025/02/09")!,
                     isPin: false),
            
            Schedule(id: "14",
                     title: "放棄-「繁星推薦(第一至七類學群)」錄取資格",
                     startDate: dateFormatter.date(from: "2025/03/18")!,
                     endDate: dateFormatter.date(from: "2025/03/20")!,
                     isPin: false),
            
            Schedule(id: "15",
                     title: "發售-「分發入學登記相關資訊」(含核定名額及特種生外加名額、登記繳費單等)",
                     startDate: dateFormatter.date(from: "2025/04/16")!,
                     endDate: dateFormatter.date(from: "2025/08/04")!,
                     isPin: false),
            
            Schedule(id: "16",
                     title: "受理-「登記分發相關證明文件」審查",
                     startDate: dateFormatter.date(from: "2025/06/02")!,
                     endDate: dateFormatter.date(from: "2025/06/20")!,
                     isPin: false),
            
            Schedule(id: "17",
                     title: "提供-「登記志願單機版」下載",
                     startDate: dateFormatter.date(from: "2025/06/04")!,
                     endDate: dateFormatter.date(from: "2025/08/04")!,
                     isPin: false),
            
            Schedule(id: "18",
                     title: "報名-「分科測驗」",
                     startDate: dateFormatter.date(from: "2025/06/05")!,
                     endDate: dateFormatter.date(from: "2025/06/17")!,
                     isPin: false),
            
            Schedule(id: "19",
                     title: "放棄-「繁星推薦(第八類學群)」及「申請入學」錄取資格",
                     startDate: dateFormatter.date(from: "2025/06/12")!,
                     endDate: dateFormatter.date(from: "2025/06/15")!,
                     isPin: false),
            
            Schedule(id: "20",
                     title: "公布-「文件審查結果」",
                     startDate: dateFormatter.date(from: "2025/07/01")!,
                     endDate: nil,
                     isPin: false),
            
            Schedule(id: "21",
                     title: "考試-「分科測驗」",
                     startDate: dateFormatter.date(from: "2025/07/11")!,
                     endDate: dateFormatter.date(from: "2025/07/12")!,
                     isPin: false),
            
            Schedule(id: "22",
                     title: "公布-「分科測驗成績」",
                     startDate: dateFormatter.date(from: "2025/07/29")!,
                     endDate: nil,
                     isPin: false),
            
            Schedule(id: "23",
                     title: "公布-「招生名額(含回流名額)、組合成績人數累計表及最低登記標準表」",
                     startDate: dateFormatter.date(from: "2025/07/29")!,
                     endDate: nil,
                     isPin: false),
            
            Schedule(id: "24",
                     title: "繳費-「分發入學登記費」",
                     startDate: dateFormatter.date(from: "2025/07/29")!,
                     endDate: dateFormatter.date(from: "2025/08/04")!,
                     isPin: false),
            
            Schedule(id: "25",
                     title: "登記-「分發志願」",
                     startDate: dateFormatter.date(from: "2025/08/01")!,
                     endDate: dateFormatter.date(from: "2025/08/04")!,
                     isPin: false),
            
            Schedule(id: "26",
                     title: "公布-「大學分發入學錄取名單」",
                     startDate: dateFormatter.date(from: "2025/08/13")!,
                     endDate: nil,
                     isPin: false),
            
            Schedule(id: "27",
                     title: "受理-「分發結果」複查",
                     startDate: dateFormatter.date(from: "2025/08/13")!,
                     endDate: dateFormatter.date(from: "2025/08/15")!,
                     isPin: false),
            
            Schedule(id: "28",
                     title: "公布-「分發複查結果」",
                     startDate: dateFormatter.date(from: "2025/08/22")!,
                     endDate: nil,
                     isPin: false),
            
            Schedule(id: "29",
                     title: "受理-「分發志願表」申請",
                     startDate: dateFormatter.date(from: "2025/09/01")!,
                     endDate: dateFormatter.date(from: "2025/12/31")!,
                     isPin: false)
        ]
    }
    
    private init() {}
    
    deinit {
        listener?.remove()
    }
    
    func observeSchedules(uid: String) {
        let userDoc = db.collection("users").document(uid)
        self.listener = userDoc.collection("schedules")
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot, error == nil else {
                    print("Error fetching schedules: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                Task {
                    do {
                        let updatedSchedules = try snapshot.documents.compactMap { document in
                            try document.data(as: Schedule.self)
                        }
                        
                        DispatchQueue.main.async {
                            self.schedules = updatedSchedules
                            self.isDataLoading = false
                        }
                    } catch {
                        print("Error decoding schedules: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func addDefaultData(uid: String) {
        let userDoc = db.collection("users").document(uid)
        let schedulesCollection = userDoc.collection("schedules")
        for schedule in defaultSchedules {
            do {
                try schedulesCollection.document(schedule.id).setData(from: schedule)
            } catch {
                print("Error setting data for placement: \(error.localizedDescription)")
            }
        }
    }
    
    func updateSchedule(schedule: Schedule) {
        guard let currentUser = Auth.auth().currentUser else {
            fatalError("User must be logged in to use the app.")
        }
        let userId = currentUser.uid
        let userDoc = db.collection("users").document(userId)
        do {
            let scheduleDoc = userDoc.collection("schedules").document(schedule.id)
            if schedule.endDate == nil {
                scheduleDoc.updateData(["endDate": FieldValue.delete()])
            }
            try scheduleDoc.setData(from: schedule, merge: true)
        } catch {
            print("Error converting schedule data: \(error.localizedDescription)")
        }
    }
    
    func deleteSchedule(schedule: Schedule) {
        guard let currentUser = Auth.auth().currentUser else {
            fatalError("User must be logged in to use the app.")
        }
        let userId = currentUser.uid
        let userDoc = db.collection("users").document(userId)
        userDoc.collection("schedules").document(schedule.id).delete()
    }
    
    func createSchedule(schedule: Schedule) {
        guard let currentUser = Auth.auth().currentUser else {
            fatalError("User must be logged in to use the app.")
        }
        let userId = currentUser.uid
        let userDoc = db.collection("users").document(userId)
        do {
            try userDoc.collection("schedules").document(schedule.id).setData(from: schedule)
        } catch {
            print("Error converting schedule data: \(error.localizedDescription)")
        }
    }
    
    func resetSchedule(schedule: Schedule) {
        if let id = Int(schedule.id) {
            let newSchedule = defaultSchedules[id]
            updateSchedule(schedule: newSchedule)
        }
    }
    
}
