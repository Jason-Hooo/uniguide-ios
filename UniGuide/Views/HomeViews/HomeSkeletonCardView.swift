//
//  SkeletonCardView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/6.
//

import Foundation
import SwiftUI
import SkeletonUI

struct HomeSkeletonCardView: View {
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 7) {
                Text("")
                    .skeleton(with: true, size: .init(width: 150, height: 35))
                Text("")
                    .skeleton(with: true, size: .init(width: 110, height: 25))
            }
            Spacer()
            Text("")
                .skeleton(with: true, size: .init(width: 20, height: 30), shape: .rounded(.radius(8)))
        }
        .padding(.horizontal)
        .padding(.vertical, 11)
    }
    
}
