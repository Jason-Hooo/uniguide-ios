//
//  PlacementsManager.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/2/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

@MainActor
class LatestPlacementsManager: ObservableObject {
    
    static let shared = LatestPlacementsManager()
    @Published var latestPlacements: [LatestPlacement] = []
    @Published var isDataLoading: Bool = true
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private let latestDefaultPlacements: [LatestPlacement] = readLatestPlacementCSV(csvName: "114_placement")
    
    private init() {}
    
    deinit {
        listener?.remove()
    }

    func observePlacements(uid: String) {
        let userDoc = db.collection("users").document(uid)
        self.listener = userDoc.collection("latestPlacements")
            .addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot, error == nil else {
                    print("Error fetching schedules: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                Task {
                    var existingPlacements = self.latestDefaultPlacements
                    for document in snapshot.documents {
                        if let id = Int(document.documentID), let isFavorite = document.data()["isFavorite"] as? Bool {
                            existingPlacements[id].isFavorite = isFavorite
                        }
                    }
                    DispatchQueue.main.async {
                        self.latestPlacements = existingPlacements
                        self.isDataLoading = false
                    }
                }
            }
    }

    func addDefaultData(uid: String) {
        let userDoc = db.collection("users").document(uid)
        let latestPlacementsCollection = userDoc.collection("latestPlacements")
        for placement in latestDefaultPlacements {
            let data: [String: Any] = [
                "id": placement.id,
                "isFavorite": placement.isFavorite
            ]
            latestPlacementsCollection.document(String(placement.id)).setData(data)
        }
    }
    
    func toggleLatestPlacement(latestPlacement: LatestPlacement) {
        guard let currentUser = Auth.auth().currentUser else {
            fatalError("User must be logged in to use the app.")
        }
        let userId = currentUser.uid
        let userDoc = db.collection("users").document(userId)
        do {
            let latestPlacementDoc = userDoc.collection("latestPlacements").document(String(latestPlacement.id))
            try latestPlacementDoc.setData(from: ["isFavorite": !latestPlacement.isFavorite], merge: true)
        } catch {
            print("Error converting schedule data: \(error.localizedDescription)")
        }
    }
    
}
