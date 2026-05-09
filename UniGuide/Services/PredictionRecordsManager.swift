//
//  Untitled.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/13.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

@MainActor
class PredictionRecordsManager: ObservableObject {
    
    static let shared = PredictionRecordsManager()
    
    @Published var predictionRecords: [PredictionRecord] = []
    @Published var errorMessage: String? = nil
    @Published var isDataLoading: Bool = false
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    private init() {}
    
    deinit {
        listener?.remove()
    }
    
    func observePredictionRecords(uid: String) {
        let userDoc = db.collection("users").document(uid)
        self.listener = userDoc.collection("predictionRecords")
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot, error == nil else {
                    print("Error fetching predictionRecords: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                Task {
                    do {
                        let updatedPredictionRecords = try snapshot.documents.compactMap { document in
                            try document.data(as: PredictionRecord.self)
                        }
                        
                        DispatchQueue.main.async {
                            self.predictionRecords = updatedPredictionRecords
                            self.isDataLoading = false
                        }
                    } catch {
                        print("Error decoding schedules: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func createPredictionRecord(predictionRecord: PredictionRecord) {
        guard let currentUser = Auth.auth().currentUser else {
            fatalError("User must be logged in to use the app.")
        }
        let userId = currentUser.uid
        let userDoc = db.collection("users").document(userId)
        
        do {
            try userDoc.collection("predictionRecords").addDocument(from: predictionRecord)
        } catch {
            print("Error converting schedule data: \(error.localizedDescription)")
        }
    }
    
    func deletePredictionRecord(predictionRecord: PredictionRecord) {
        guard let currentUser = Auth.auth().currentUser else {
            fatalError("User must be logged in to use the app.")
        }
        let userDoc = db.collection("users").document(currentUser.uid)
        if let id = predictionRecord.id {
            userDoc.collection("predictionRecords").document(id).delete()
        } else {
            print("此 predictionRecord id 為 nil")
        }
    }
    
}
