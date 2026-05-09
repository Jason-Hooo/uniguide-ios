//
//  TimerManager.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/1/15.
//

//import Foundation
//import SwiftUI
//
//class TimerManager: ObservableObject {
//    
//    @Published var cooldownTime: Int = 0
//    private var time: Int // 要計時多久
//    private var timer: Timer?
//    
//    init(time: Int) {
//        self.time = time
//    }
//    
//    func startTimer() {
//        cooldownTime = time
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//            if self.cooldownTime > 0 {
//                self.cooldownTime -= 1
//            } else {
//                self.timer?.invalidate()
//                self.timer = nil
//            }
//        }
//    }
//    
//    func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
//    
//}
//
