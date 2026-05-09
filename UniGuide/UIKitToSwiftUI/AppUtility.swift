//
//  AppUtility.swift
//  UniGuide
//
//  Created by 何杰陞 on 2024/12/8.
//

import SwiftUI
import UIKit

final class AppUtility {
    
    static var rootViewController: UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init() // .init就是UIViewController()
        }
        
        return root
    }
    
}
