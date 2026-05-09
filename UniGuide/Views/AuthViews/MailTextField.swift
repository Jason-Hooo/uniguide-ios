////
////  MailTextField.swift
////  UniGuide
////
////  Created by 何杰陞 on 2025/1/14.
////
//
//import Foundation
//import SwiftUI
//
//struct MailTextField: View {
//    
//    @Binding var text: String
//    
//    var body: some View {
//        TextField(
//            "",
//            text: $text,
//            prompt: Text("電子郵件")
//                .font(.custom("GenJyuuGothicX-Medium", size: 16))
//                .foregroundColor(Color("khaki"))
//        )
//        .submitLabel(.done)
//        .padding()
//        .background(Color("lightOrange"))
//        .cornerRadius(10)
//        .foregroundColor(.black)
//        .keyboardType(.emailAddress)
//        .frame(width: 342)
//    }
//    
//}
