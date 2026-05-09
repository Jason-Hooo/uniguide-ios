//
//  LoadingView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/1/20.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    
    @State private var isAnimate = false
    let color: Color
    let pointSize: CGFloat
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: pointSize, height: pointSize)
                .scaleEffect(isAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever(), value: isAnimate)
            Circle()
                .fill(color)
                .frame(width: pointSize, height: pointSize)
                .scaleEffect(isAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3), value: isAnimate)
            Circle()
                .fill(color)
                .frame(width: pointSize, height: pointSize)
                .scaleEffect(isAnimate ? 1.0 : 0.5)
                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6), value: isAnimate)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.opacity(0.2))
        )
        .onAppear {
            self.isAnimate = true
        }
    }
    
}

#Preview {
    LoadingView(color: .brown, pointSize: 100)
}
