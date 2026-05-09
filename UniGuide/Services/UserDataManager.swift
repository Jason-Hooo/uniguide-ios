//
//  UserDataManager.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/5.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

@MainActor
class UserDataManager: ObservableObject {
    
    static let shared = UserDataManager()
    
    @Published var userData: UserData?
    @Published var errorMessage: String? = nil
    @Published var isDataLoading: Bool = true
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    private init() {}
    
    deinit {
        listener?.remove()
    }
    
    func observeUserData(uid: String) {
        let userDoc = db.collection("users").document(uid)
        self.listener = userDoc.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("Error fetching userData: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                self.userData = try snapshot.data(as: UserData.self)
                self.isDataLoading = false
            } catch {
                self.errorMessage = "解析使用者資料失敗：\(error.localizedDescription)"
            }
        }
    }
    
    func changeEnergies(amount: Int) { // 我就只會加一減一而已
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "使用者未登入"
            return
        }
        
        let userRef = db.collection("users").document(uid)
        userRef.updateData([
            "energies": FieldValue.increment(Int64(amount))
        ]) { error in
            if let error = error {
                self.errorMessage = "能量更新失敗：\(error.localizedDescription)"
            }
        }
    }

}
