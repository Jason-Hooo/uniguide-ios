//
//  PredictionSkeletonCardView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/13.
//

import Foundation
import SwiftUI
import SkeletonUI

struct PredictionSkeletonCardView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    private var isDarkMode: Bool {
        colorScheme == .dark
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("")
                        .skeleton(with: true, size: .init(width: 100, height: 25))
                    
                    Text("")
                        .skeleton(with: true, size: .init(width: 130, height: 10))
                }
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("")
                        .skeleton(with: true, size: .init(width: 70, height: 18))
                    
                    Text("")
                        .skeleton(with: true, size: .init(width: 100, height: 15))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 5) {
                    Text("")
                        .skeleton(with: true, size: .init(width: 30, height: 18))
                    
                    Text("")
                        .skeleton(with: true, size: .init(width: 130, height: 15))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: isDarkMode ? .white.opacity(0.1) : .black.opacity(0.2), radius: 8, y: 3)
    }
    
}

