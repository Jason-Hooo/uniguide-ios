////
////  SignUpView.swift
////  UniGuide
////
////  Created by 何杰陞 on 2024/12/27.
////
//
//import SwiftUI
//import Firebase
//
//struct SignUpView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var email = ""
//    @State private var password = ""
//    @State private var confirmPassword = ""
//    @State private var isPasswordMatching = true
//    @State private var isPasswordValid = true
//    @State private var passwordErrorMessage: String? = nil
//    
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            Color("cream")
//                .edgesIgnoringSafeArea(.all)
//            
//            ScrollView {
//                VStack(spacing: 20) {
//                    Image(systemName: "person.crop.circle.badge.plus")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.brown)
//                        .padding(.top, 60)
//                        .symbolEffect(.bounce.down, options: .repeat(1))
//                    
//                    Text("使用電子信箱來註冊")
//                        .foregroundStyle(.brown)
//                        .font(.custom("GenJyuuGothicX-Bold", size: 28))
//                        .padding(.bottom, 100)
//                    
//                    MailTextField(text: $email)
//                    
//                    VStack {
//                        PasswordTextField(password: $password, placeholder: "密碼")
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(isPasswordValid ? .clear : .red, lineWidth: 1.5)
//                                    .frame(width: 342, height: 52)
//                            )
//                        
//                        if !isPasswordValid {
//                            Text(passwordErrorMessage ?? "")
//                                .foregroundColor(.red)
//                                .padding(.leading, 20)
//                                .padding(.trailing, 20)
//                                .font(.system(size: 15.5))
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .fixedSize(horizontal: false, vertical: true)
//                        }
//                    }
//                    
//                    VStack {
//                        PasswordTextField(password: $confirmPassword, placeholder: "確認密碼")
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(isPasswordMatching ? .clear : .red, lineWidth: 1.5)
//                                    .frame(width: 342, height: 52)
//                            )
//                        
//                        if !isPasswordMatching {
//                            Text("密碼需要一致喔！")
//                                .foregroundColor(.red)
//                                .padding(.leading, 20)
//                                .font(.system(size: 15.5))
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                        }
//                    }
//                    
//                    AuthButton(
//                        title: "註冊",
//                        icon: nil,
//                        backgroundColor: email == "" || password == "" || confirmPassword == "" ? Color("myOrange").opacity(0.8) : Color("myOrange"),
//                        foregroundColor: Color("cream"),
//                        action: {
//                            passwordErrorMessage = checkPassword(password: password)
//                            if password != confirmPassword && passwordErrorMessage != nil {
//                                isPasswordMatching = false
//                                isPasswordValid = false
//                            } else if password != confirmPassword && passwordErrorMessage == nil {
//                                isPasswordMatching = false
//                                isPasswordValid = true
//                            } else if password == confirmPassword && passwordErrorMessage != nil {
//                                isPasswordMatching = true
//                                isPasswordValid = false
//                            } else {
//                                AuthService.shared.emailSignUp(email: email, password: password)
//                            }
//                        }
//                    )
//                    .padding(.top, 15)
//                    .disabled(email == "" || password == "" || confirmPassword == "")
//                    
//                    HStack {
//                        Text("你原來已經有帳號了？那還不趕緊")
//                            .foregroundColor(.brown)
//                        Button(action: { dismiss() }) {
//                            Text("登錄")
//                                .fontWeight(.bold)
//                                .foregroundColor(.brown)
//                        }
//                    }
//                    .padding(.leading, 20)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                }
//                .padding()
//            }
//        }
//        .overlay(alignment: .topLeading) {
//            Button(action: {
//                dismiss()
//            }) {
//                Image(systemName: "chevron.left")
//                    .foregroundColor(.brown)
//                    .font(.system(size: 25, weight: .bold))
//            }
//            .padding(.leading, 30)
//            .padding(.top, 10)
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//
//    func checkPassword(password: String) -> String? {
//        var errors = [String]()
//
//        if password.count < 6 {
//            errors.append("6個字元以上")
//        }
//
//        if !password.contains(where: { $0.isUppercase }) || !password.contains(where: { $0.isLowercase }) {
//            errors.append("包含大小寫字母")
//        }
//
//        if !password.contains(where: { $0.isNumber }) {
//            errors.append("至少一個數字")
//        }
//
//        let errorMessage = errors.isEmpty ? nil : "密碼需" + errors.joined(separator: "、")
//        
//        return errorMessage
//    }
//
//}
//
//#Preview {
//    SignUpView()
//}
//
