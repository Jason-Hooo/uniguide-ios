//
//  UserData.swift
//  UniGuide
//
//  Created by 何杰陞 on 2024/12/28.
//

import Foundation

struct UserData: Codable {
    
    var uid: String
    var energies: Int
    
    init(uid: String, energies: Int) {
        self.uid = uid
        self.energies = energies
    }
    
}

