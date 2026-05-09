//
//  RankingDepartmentsManager.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/3/10.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

@MainActor
class RankingDepartmentsManager: ObservableObject {
    
    static let shared = RankingDepartmentsManager()
    @Published var visitRankingDepartments: [RankingDepartment] = []
    @Published var favoriteRankingDepartments: [RankingDepartment] = []
    @Published var isDataLoading: Bool = true
    private var db = Firestore.firestore()
    private var visitListener: ListenerRegistration?
    private var favoriteListener: ListenerRegistration?
    
    private init() {}
    
    deinit {
        visitListener?.remove()
        favoriteListener?.remove()
    }
    
    public func observeVisit() {
        visitListener = db.collection("rankingDepartments")
            .whereField("visitCount", isGreaterThanOrEqualTo: 1)
            .order(by: "visitCount", descending: true)
            .limit(to: 50)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("Error fetching visit ranking: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                Task {
                    do {
                        let updatedRanking = try snapshot.documents.compactMap { document in
                            try document.data(as: RankingDepartment.self)
                        }
                        
                        DispatchQueue.main.async {
                            withAnimation {
                                self.visitRankingDepartments = updatedRanking
                                self.isDataLoading = false
                            }
                        }
                    } catch {
                        print("Error decoding visit ranking: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    public func observeFavorite() {
        favoriteListener = db.collection("rankingDepartments")
            .whereField("favoriteCount", isGreaterThanOrEqualTo: 1)
            .order(by: "favoriteCount", descending: true)
            .limit(to: 50)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("Error fetching favorite ranking: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                Task {
                    do {
                        let updatedRanking = try snapshot.documents.compactMap { document in
                            try document.data(as: RankingDepartment.self)
                        }
                        
                        DispatchQueue.main.async {
                            withAnimation {
                                self.favoriteRankingDepartments = updatedRanking
                            }
                        }
                    } catch {
                        print("Error decoding favorite ranking: \(error.localizedDescription)")
                    }
                }
            }
    }

    public func updateFavoriteCount(id: Int, isAdd: Bool) {
        let documentRef = db.collection("rankingDepartments").document(String(id))
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                documentRef.updateData([
                    "favoriteCount": FieldValue.increment(Int64(isAdd ? 1 : -1))
                ]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            } else {
                let rankingDepartment = RankingDepartment(id: id, visitCount: 0, favoriteCount: isAdd ? 1 : 0)
                do {
                    try documentRef.setData(from: rankingDepartment)
                } catch {
                    print("Error setting data for placement: \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func addVisitCount(id: Int) {
        let documentRef = db.collection("rankingDepartments").document(String(id))
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                documentRef.updateData([
                    "visitCount": FieldValue.increment(Int64(1))
                ]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            } else {
                let rankingDepartment = RankingDepartment(id: id, visitCount: 1, favoriteCount: 0)
                do {
                    try documentRef.setData(from: rankingDepartment)
                } catch {
                    print("Error setting data for placement: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
