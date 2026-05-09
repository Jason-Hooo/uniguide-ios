//
//  AuthButton.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/1/14.
//

import Foundation
import SwiftUI

struct AuthButton: View {
    let title: String
    let icon: String?
    let backgroundColor: Color
    let foregroundColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
            .font(.custom("GenJyuuGothicX-Medium", size: 18))
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 28)
            .padding()
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(10)
            .overlay(alignment: .leading) {
                if let icon = icon {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .padding(.leading, 20)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 2)
                    .opacity(0.6)
            )
        }
    }
}


