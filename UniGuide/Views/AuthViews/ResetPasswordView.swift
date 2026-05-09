////
////  orgotPasswordView.swift
////  UniGuide
////
////  Created by 何杰陞 on 2025/1/13.
////
//
//import Foundation
//import SwiftUI
//import FirebaseAuth
//
//struct ResetPasswordView: View {
//    @Environment(\.dismiss) private var dismiss
//    @State private var email = ""
//    @ObservedObject var timerManager: TimerManager
//    
//    var body: some View {
//        ZStack {
//            Color("cream")
//                .edgesIgnoringSafeArea(.all)
//            
//            ScrollView { 
//                VStack(spacing: 20) {
//                    Image(systemName: "lock.rotation")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.brown)
//                        .padding(.top, 60)
//                        .symbolEffect(.bounce.down, options: .repeat(1))
//                    
//                    Text("重設密碼")
//                        .foregroundStyle(.brown)
//                        .font(.custom("GenJyuuGothicX-Bold", size: 28))
//                    
//                    Text("請輸入您的電子信箱，我們會寄送重設密碼的連結給您")
//                        .font(.system(size: 18))
//                        .foregroundColor(.brown)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//                        .frame(height: 43)
//                        .padding(.bottom, 100)
//                    
//                    MailTextField(text: $email)
//                    
//                    Button(action: {
//                        AuthService.shared.emailSendResetPassword(email: email) { isSuccessful in
//                            if isSuccessful {
//                                timerManager.startTimer()
//                            }
//                        }
//                    }) {
//                        HStack {
//                            Text(timerManager.cooldownTime > 0 ? "請等待 \(formatTime(timerManager.cooldownTime))" : "發送重設密碼郵件")
//                            if timerManager.cooldownTime > 0 {
//                                ProgressView()
//                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("cream")))
//                                    .scaleEffect(0.8)
//                            }
//                        }
//                        .font(.custom("GenJyuuGothicX-Medium", size: 18))
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .frame(width: 310, height: 27)
//                        .padding()
//                        .background(timerManager.cooldownTime > 0 || email == "" ? Color("myOrange").opacity(0.6) : Color("myOrange"))
//                        .foregroundColor(Color("cream"))
//                        .cornerRadius(10)
//                    }
//                    .disabled(timerManager.cooldownTime > 0 || email == "")
//                    
//                    Spacer()
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
////        .alert("提示", isPresented: $showAlert) {
////            Button("確定") {
////                if alertMessage.contains("已發送") {
////                    // 保持在當前頁面，等待冷卻時間結束
////                }
////            }
////        } message: {
////            Text(alertMessage)
////        }
//        .navigationBarBackButtonHidden(true)
//    }
//    
//    private func formatTime(_ seconds: Int) -> String {
//        let minutes = seconds / 60
//        let remainingSeconds = seconds % 60
//        return String(format: "%d:%02d", minutes, remainingSeconds)
//    }
//    
//}
//
//#Preview {
//    @Previewable @StateObject var timerManager = TimerManager(time: 90)
//    ResetPasswordView(timerManager: timerManager)
//}
//
