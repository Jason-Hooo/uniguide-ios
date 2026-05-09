//
//  InitialView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2024/12/9.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct InitialView: View {
    
    @State private var isLoggedIn = (Auth.auth().currentUser != nil)
    @State private var handle: AuthStateDidChangeListenerHandle?
    @StateObject private var authService = AuthService.shared
    @StateObject private var schedulesManager = SchedulesManager.shared
    @StateObject private var latestPlacementsManager = LatestPlacementsManager.shared
    @StateObject private var rankingDepartmentsManager = RankingDepartmentsManager.shared
    @StateObject private var userDataManager = UserDataManager.shared
    @StateObject private var predictionRecordsManager = PredictionRecordsManager.shared
    @State private var showAlert = false
    @State private var enterToBackgroundTime: Date?
    @State private var justLoggedIn = false
    @State private var isJustOpened = true
    
    var body: some View {
        Group {
            if isLoggedIn {
                MainTabView()
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                        enterToBackgroundTime = Date()
                    }
                    .onReceive(NotificationCenter.default.publisher(for:  UIApplication.didBecomeActiveNotification)) { _ in
                        // 45 秒內未回到 app 就會顯示廣告
                        if let lastBackgroundTime = enterToBackgroundTime {
                            if Date().timeIntervalSince(lastBackgroundTime) > 45 {
                                AppOpenAdManager.shared.showAdIfAvailable()
                            }
                        }
                    }
                    .onAppear {
                        if !justLoggedIn && isJustOpened {
                            Task { // show ad when app is opened
                                isJustOpened = false
                                await AppOpenAdManager.shared.loadAd()
                                AppOpenAdManager.shared.showAdIfAvailable()
                            }
                        }
                    }
            } else {
                LoginView()
                    .onAppear {
                        justLoggedIn = true
                    }
            }
        }
        .environmentObject(schedulesManager)
        .environmentObject(latestPlacementsManager)
        .environmentObject(rankingDepartmentsManager)
        .environmentObject(userDataManager)
        .environmentObject(predictionRecordsManager)
        .onChange(of: authService.errorMessage) {
            if authService.errorMessage != nil && authService.errorTitle != nil{
                showAlert = true
            }
        }
        .alert(authService.errorTitle ?? "發生錯誤", isPresented: $showAlert) {
            Button("確認") {
                authService.errorMessage = nil
                authService.errorTitle = nil
            }
        } message: {
            Text(authService.errorMessage ?? "未知錯誤，請稍後再試")
        }
        .onAppear {
            self.handle = Auth.auth().addStateDidChangeListener { auth, user in
                withAnimation(.spring) {
                    isLoggedIn = (user != nil)
                }
                if let user = user {
                    let userId = user.uid
                    let db = Firestore.firestore()
                    let userDoc = db.collection("users").document(userId)
                    
                    userDoc.getDocument { document, error in
                        if let error = error {
                            print("Error getting document: \(error.localizedDescription)")
                            return
                        }
                        
                        if let document = document, document.exists {} else {
                            let newUserData = UserData(uid: userId, energies: 1)
                            do {
                                try userDoc.setData(from: newUserData)
                            } catch {
                                print(error.localizedDescription)
                            }
                            schedulesManager.addDefaultData(uid: userId)
                            latestPlacementsManager.addDefaultData(uid: userId)
                        }
                        
                        userDataManager.observeUserData(uid: userId)
                        predictionRecordsManager.observePredictionRecords(uid: userId)
                        schedulesManager.observeSchedules(uid: userId)
                        latestPlacementsManager.observePlacements(uid: userId)
                        rankingDepartmentsManager.observeFavorite()
                        rankingDepartmentsManager.observeVisit()
                    }
                }
            }
        }
        .onDisappear {
            if let handle = self.handle {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    }
}

#Preview {
    InitialView()
}

