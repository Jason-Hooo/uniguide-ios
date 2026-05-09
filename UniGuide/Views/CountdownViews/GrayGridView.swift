//
//  GrayGridView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/2/11.
//

import SwiftUI

struct GrayGridView: View {
    
    var horizontalSpacing: CGFloat = 15
    var verticalSpacing: CGFloat = 15

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let numberOfHorizontalGridLines = Int(geometry.size.height / self.verticalSpacing)
                let numberOfVerticalGridLines = Int(geometry.size.width / self.horizontalSpacing)
                for index in 0...numberOfVerticalGridLines {
                    let vOffset: CGFloat = CGFloat(index) * self.horizontalSpacing
                    path.move(to: CGPoint(x: vOffset, y: 0))
                    path.addLine(to: CGPoint(x: vOffset, y: geometry.size.height))
                }
                for index in 0...numberOfHorizontalGridLines {
                    let hOffset: CGFloat = CGFloat(index) * self.verticalSpacing
                    path.move(to: CGPoint(x: 0, y: hOffset))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: hOffset))
                }
            }
            .stroke(Color(.lightGray).opacity(0.15))
        }
    }
    
}

#Preview {
    GrayGridView()
        .ignoresSafeArea()
}
