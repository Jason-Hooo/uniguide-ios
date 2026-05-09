//
//  Untitled.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/6.
//

import Foundation
import SwiftUI
import SkeletonUI

struct ScheduleSkeletonCardView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(isDarkMode ? Color("khaki").opacity(0.9) : Color("cream"))
                .shadow(color: isDarkMode ? .white.opacity(0.3) : .black.opacity(0.23), radius: 10, y: 3)
                .overlay(alignment: .bottomTrailing) {
                    Image(isDarkMode ? "blackU" : "whiteU")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 17, height: 17)
                        .padding()
                }
            
            VStack(alignment: .leading, spacing: 10) {

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("")
                            .skeleton(with: true, size: .init(width: 200, height: 15))
                        Text("")
                            .skeleton(with: true, size: .init(width: 70, height: 15))
                    }
                    Spacer()
                }
                
                Text("")
                    .skeleton(with: true, size: .init(width: 150, height: 30))

                Text("")
                    .skeleton(with: true, size: .init(width: 150, height: 12))
                
            }
            .padding()
        }
    }
    
}
