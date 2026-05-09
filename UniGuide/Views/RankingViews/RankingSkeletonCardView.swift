//
//  RankingSkeletonCardView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/6.
//

import Foundation
import SwiftUI

struct RankingSkeletonCardView: View {
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("")
                .skeleton(with: true, size: .init(width: 30, height: 30))
                .frame(width: 60, height: 60)
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("")
                        .skeleton(with: true, size: .init(width: 150, height: 35))
                    Text("")
                        .skeleton(with: true, size: .init(width: 110, height: 25))
                }
                Spacer()
                VStack {
                    Text("")
                        .skeleton(with: true, size: .init(width: 20, height: 30), shape: .rounded(.radius(8)))
                    Text("")
                        .skeleton(with: true, size: .init(width: 50, height: 20))
                }
            }
            .padding(.trailing)
            .padding(.vertical, 11)
        }
    }
    
}
