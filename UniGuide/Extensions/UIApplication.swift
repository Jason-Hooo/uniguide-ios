//
//  UIApplication.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/2/7.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
