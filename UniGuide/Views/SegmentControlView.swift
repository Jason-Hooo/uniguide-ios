//
//  SwiftUIView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/2/21.
//

import SwiftUI

struct SegmentControlView: View {
    
    let segments: [String]
    @Binding var selected: String
    let mainColor: Color
    let titleSelectedColor: Color
    let cornerRadius: CGFloat
    let textSize: CGFloat
    let needBackground: Bool 
    @Namespace private var namespace
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { bounds in
            HStack(spacing: 0) {
                ForEach(segments, id: \.self) { segment in
                    Button {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.6)) {
                            selected = segment
                        }
                    } label: {
                        Text(segment)
                            .font(.system(size: textSize, weight: .semibold, design: .rounded))
                            .frame(width: bounds.size.width / CGFloat(segments.count), height: bounds.size.height)
                            .scaleEffect(selected == segment ? 1 : 0.8)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                            .foregroundColor(selected == segment ? titleSelectedColor : mainColor)
                            .background(
                                selected == segment ?
                                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                        .fill(mainColor)
                                        .matchedGeometryEffect(id: "SelectedTab", in: namespace)
                                    : nil
                            )
                    }
                }
            }
            .padding(3.5)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius + 2, style: .continuous)
                    .fill(mainColor.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius + 2, style: .continuous)
                            .stroke(style: StrokeStyle(lineWidth: 2))
                            .foregroundColor(mainColor.opacity(0.3))
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(needBackground ? (colorScheme == .dark ? .black : .white) : .clear)
                    )
            }
        }
    }
    
}
