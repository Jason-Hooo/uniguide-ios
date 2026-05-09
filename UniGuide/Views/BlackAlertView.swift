//
//  BlackAlertView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/2/12.
//

import SwiftUI

struct BlackAlertView: View {
    
    let alert: String
    let imageName: String
    @Binding var showAlert: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text(alert)
                .font(.system(size: 13))
                .multilineTextAlignment(.center)
                .padding(.top, 2)
        }
        .frame(width: 90)
        .padding(23)
        .foregroundStyle(.white)
        .background(.black.opacity(0.7))
        .cornerRadius(10)
        .scaleEffect(showAlert ? 1 : 0.4)
        .opacity(showAlert ? 1 : 0)
    }
    
}

#Preview {
    BlackAlertView(alert: "test", imageName: "pin", showAlert: .constant(true))
}
