//
//  LatestListRowView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/3/9.
//

import Foundation
import SwiftUI
import SkeletonUI

struct ListRowView: View {

    @Environment(\.colorScheme) private var colorScheme
    let placement: Placement
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 7) {
                Text(placement.schoolName)
                    .font(.system(size: 26))
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .multilineTextAlignment(.leading)
                Text(placement.departmentName)
                    .font(.system(size: 20))
                    .foregroundStyle(Color(99, 110, 114))
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            if let placement = placement as? LatestPlacement {
                FavoriteButtonView(placement: placement, favoriteButtonscale: 1.2)
                    .padding(.top, 8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 11)
    }
    
}
