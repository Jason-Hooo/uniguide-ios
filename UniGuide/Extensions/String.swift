//
//  String.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/2/7.
//

import Foundation
import SwiftUI

extension String {
    
    var isBlank: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}
