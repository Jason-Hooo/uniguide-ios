////
////  PasswordTextField.swift
////  UniGuide
////
////  Created by 何杰陞 on 2025/1/14.
////
//
//import Foundation
//import SwiftUI
//
//struct PasswordTextField: View {
//    
//    @Binding var password: String
//    var placeholder: String
//    @State private var isPasswordVisible: Bool = false
//    
//    var body: some View {
//        ZStack {
//            if isPasswordVisible {
//                TextField(
//                    "",
//                    text: $password,
//                    prompt: Text(placeholder)
//                        .font(.custom("GenJyuuGothicX-Medium", size: 16))
//                        .foregroundColor(Color("khaki"))
//                )
//                .submitLabel(.done)
//                .padding(.trailing, 40)
//                .padding()
//                .background(Color("lightOrange"))
//                .cornerRadius(10)
//                .foregroundColor(.black)
//                .frame(width: 342)
//            } else {
//                SecureField(
//                    "",
//                    text: $password,
//                    prompt: Text(placeholder)
//                        .font(.custom("GenJyuuGothicX-Medium", size: 16))
//                        .foregroundColor(Color("khaki"))
//                )
//                .submitLabel(.done)
//                .padding(.trailing, 40)
//                .padding()
//                .background(Color("lightOrange"))
//                .cornerRadius(10)
//                .foregroundColor(.black)
//                .frame(width: 342)
//            }
//            
//            Button(action: {
//                isPasswordVisible.toggle()
//            }) {
//                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
//                    .foregroundColor(Color("cream"))
//            }
//            .padding(.trailing, 30)
//            .frame(maxWidth: .infinity, alignment: .trailing)
//        }
//        .frame(height: 50)
//    }
//}
