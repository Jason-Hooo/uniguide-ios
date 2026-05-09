//
//  ShortForm.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/2/12.
//

import SwiftUI

struct ShortForm: View {
    
    let label: String
    var hintWords: String = ""
    @Binding var value: String
    @Environment(\.colorScheme) private var colorScheme
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(isDarkMode ? .lightGray : .darkGray))
            TextField(hintWords, text: $value)
                .submitLabel(.done)
                .font(.system(.body, design: .rounded))
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(.systemGray4), lineWidth: 1.5)
                )
                .padding(.top, 10)
        }
    }
}

#Preview {
    @Previewable @State var value = "j23"
    ShortForm(label: "23kld", hintWords: "3nj2ek", value: $value)
}

