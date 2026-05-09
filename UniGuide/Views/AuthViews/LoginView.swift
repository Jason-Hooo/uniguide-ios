
import Firebase
import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import SwiftUI
import WebKit

struct LoginView: View {
//    @State private var email = ""
//    @State private var password = ""
//    @State private var showSignUp = false
//    @State private var showForgotPassword = false
//    @StateObject private var timerManager = TimerManager(time: 90)
    @State private var showTermsOfService = false
    @State private var showPrivacyPolicy = false

    var body: some View {
        ZStack {
            Color("cream")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    Image("uniGuideNoBackground")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .padding()
                    
                    Text("UniGuide，你的升學好夥伴。")
                        .font(.custom("GenJyuuGothicX-Heavy", size: 20))
                        .foregroundColor(.brown)
                        .multilineTextAlignment(.center)
                }
                .frame(maxHeight: .infinity)
                
//                    MailTextField(text: $email)
//
//                    PasswordTextField(password: $password, placeholder: "密碼")
                
//                    HStack {
//                        Button(action: {
//                            showSignUp = true
//                        }) {
//                            Text("我要註冊")
//                                .foregroundColor(.brown)
//                                .font(.system(size: 16, weight: .bold))
//                        }
//                        .padding(.leading, 20)
//
//                        Spacer()
//
//                        Button(action: {
//                            showForgotPassword = true
//                        }) {
//                            Text("忘記密碼了")
//                                .foregroundColor(.brown)
//                                .font(.system(size: 16, weight: .bold))
//                        }
//                        .padding(.trailing, 20)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
                
//                    AuthButton(
//                        title: "登錄",
//                        icon: nil,
//                        backgroundColor: email == "" || password == "" ? Color("myOrange").opacity(0.8) : Color("myOrange"),
//                        foregroundColor: Color("cream"),
//                        action: {
//                            AuthService.shared.emailSignIn(email: email, password: password)
//                        }
//                    )
//                    .disabled(email == "" || password == "")
                
//                    HStack {
//                        Rectangle()
//                            .fill(.brown.opacity(0.7))
//                            .frame(height: 2)
//
//                        Text("或者")
//                            .foregroundColor(.brown)
//                            .padding(.horizontal)
//                            .bold()
//
//                        Rectangle()
//                            .fill(.brown.opacity(0.7))
//                            .frame(height: 2)
//                    }
//                    .padding(.bottom, 11)
                
                AuthButton(
                    title: "使用 Google 繼續",
                    icon: "google",
                    backgroundColor: .white,
                    foregroundColor: .black,
                    action: {
                        AuthService.shared.googleSignIn()
                    }
                )
                .padding(.horizontal)
                
                //                        AuthButton(
                //                            title: "使用 Facebook 繼續",
                //                            icon: "facebook",
                //                            backgroundColor: .blue,
                //                            foregroundColor: .white,
                //                            action: {
                //                                AuthService.shared.fbSignIn()
                //                            }
                //                        )
                
                AuthButton(
                    title: "使用 Apple 繼續",
                    icon: "apple",
                    backgroundColor: .black,
                    foregroundColor: .white,
                    action: {
                        AuthService.shared.appleSignIn()
                    }
                )
                .padding(.horizontal)
                
                HStack(spacing: 1) {
                    Text("繼續即表示您同意我們的")
                        .font(.system(size: 14))
                        .foregroundColor(.brown.opacity(0.8))
                    
                    Button(action: {
                        showPrivacyPolicy = true
                    }) {
                        Text("隱私權政策")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.brown)
                            .underline()
                    }
                }
                .padding([.horizontal, .bottom])
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            WebView(url: URL(string: "https://jason-hooo.github.io/Privacy_Policy/PrivacyPolicy.html"))
                .ignoresSafeArea()
        }
//            .navigationDestination(isPresented: $showSignUp) {
//                SignUpView()
//            }
//            .navigationDestination(isPresented: $showForgotPassword) {
//                ResetPasswordView(timerManager: timerManager)
//            }
    }
    
}

struct WebView: UIViewRepresentable {

    let url: URL?

    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = false
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        return WKWebView(
            frame: .zero,
            configuration: config
        )
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let myURL = url else {
            return
        }
        let  request = URLRequest(url: myURL)
        uiView.load(request)
    }
    
}
