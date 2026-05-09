//
//  ScheduleWidgetBundle.swift
//  ScheduleWidget
//
//  Created by 何杰陞 on 2025/3/13.
//

import WidgetKit
import SwiftUI
import Firebase
import FirebaseAuth

@main
struct ScheduleWidgetBundle: WidgetBundle {
    
    init() {
        FirebaseApp.configure()
        let TEAM_ID = Bundle.main.infoDictionary?["TEAM_ID"] as! String
        do {
            try Auth.auth().useUserAccessGroup("\(TEAM_ID).com.Jason.UniGuide.shared") 
        } catch let error as NSError {
            print("Error changing user access group: %@", error)
        }
    }
    
    var body: some Widget {
        ScheduleWidget()
    }
    
}
