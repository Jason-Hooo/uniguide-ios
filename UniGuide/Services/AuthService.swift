//
//  AuthViewModel.swift
//  UniGuide
//
//  Created by 何杰陞 on 2024/12/8.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth
import FacebookLogin
import FBSDKLoginKit
import AuthenticationServices
import CryptoKit

@MainActor
class AuthService: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    
    static let shared = AuthService()
    @Published var errorTitle: String? = nil
    @Published var errorMessage: String? = nil
    @Published var showReauthenticationAlert = false
    fileprivate var currentNonce: String?

    private override init() {}

    func handleAuthError(error: NSError?) {
        guard let error = error else { return }

        let authError = AuthErrorCode(rawValue: error.code)
        switch authError {
        case .emailAlreadyInUse:
            self.errorTitle = "此電子郵件已被註冊"
            self.errorMessage = "請直接登錄或使用其他電子郵件"
        case .expiredActionCode:
            self.errorTitle = "驗證連結已過期"
            self.errorMessage = "請重新請求操作或驗證連結"
        case .invalidActionCode:
            self.errorTitle = "無效的操作連結"
            self.errorMessage = "請重新請求操作或驗證連結"
        case .invalidEmail:
            self.errorTitle = "無效的電子郵件"
            self.errorMessage = "請輸入有效的電子郵件地址"
        case .invalidRecipientEmail:
            self.errorTitle = "無效的收件者"
            self.errorMessage = "收件者的電子郵件無效，請檢查後再試"
        case .missingEmail:
            self.errorTitle = "缺少資訊"
            self.errorMessage = "請提供電子郵件地址以繼續"
        case .networkError:
            self.errorTitle = "網絡錯誤"
            self.errorMessage = "請確認網路連線狀況"
        case .nullUser:
            self.errorTitle = "無效的使用者"
            self.errorMessage = "使用者資料有誤，請重新嘗試"
        case .operationNotAllowed:
            self.errorTitle = "操作限制"
            self.errorMessage = "此操作目前未被允許，請聯繫支援"
        case .requiresRecentLogin:
            self.showReauthenticationAlert = true
        case .tooManyRequests:
            self.errorTitle = "請求次數過多"
            self.errorMessage = "操作過於頻繁，請稍後再試"
        case .unverifiedEmail:
            self.errorTitle = "電子郵件未驗證"
            self.errorMessage = "請先驗證您的電子郵件地址以繼續"
        case .userDisabled:
            self.errorTitle = "帳戶已禁用"
            self.errorMessage = "您的帳戶已被停用，請聯繫支援"
        case .userMismatch:
            self.errorTitle = "使用者錯誤"
            self.errorMessage = "目前登入的使用者與操作帳戶不匹配"
        case .userNotFound:
            self.errorTitle = "找不到使用者"
            self.errorMessage = "使用其他帳號或選擇註冊"
        case .weakPassword:
            self.errorTitle = "密碼過於簡單"
            self.errorMessage = "密碼需6位以上且包含大小寫英文字母、數字"
        case .wrongPassword:
            self.errorTitle = "密碼錯誤"
            self.errorMessage = "請再輸入一次"         // case .accountExistsWithDifferentCredential:
        default:
            self.errorTitle = "其他錯誤"
            self.errorMessage = error.localizedDescription
        }
    }
    
    func googleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.errorTitle = "登錄失敗"
            self.errorMessage = "無法取得 Google 驗證資訊"
            
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: AppUtility.rootViewController) { result, error in
            if let error = error as NSError? {
                if error.code != -5 && error.code != -1 { // -5是取消錯誤 -1是未知錯誤，使用者按下不同的的取消分別會跳出這兩種
                    self.errorTitle = "登錄失敗"
                    self.errorMessage = error.localizedDescription
                }
                    
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                self.errorTitle = "登錄失敗"
                self.errorMessage = "無法取得使用者資訊"
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error as NSError? {
                    self.handleAuthError(error: error)
                    return
                }
            }
        }
    }
    
//    func fbSignIn() {
//        let loginManager = LoginManager()
//        print(AppUtility.rootViewController)
//        loginManager.logIn(permissions: ["public_profile", "email"], from: AppUtility.rootViewController) { result, error in
//            if let result = result {
//                    print("FB Login Result:", result)
//                    print("Did the user cancel?:", result.isCancelled)
//                    print("Granted permissions:", result.grantedPermissions)
//                    print("Declined permissions:", result.declinedPermissions)
//                } else {
//                    print("FB Login Result is nil")
//                }
//            if let error = error {
//                self.errorTitle = "登錄失敗"
//                self.errorMessage = error.localizedDescription
//                
//                return
//            }
//
//            guard let token = AccessToken.current?.tokenString else {
//                print(1)
//                // self.errorMessage = "無法取得使用者資訊" 這裡若使用者按下取消的話會跳出此錯誤，所以讓它不要顯示
//                return
//            }
//            
//            let credential = FacebookAuthProvider.credential(withAccessToken: token)
//            
//            Auth.auth().signIn(with: credential) { authResult, error in
//                print(2)
//                if let error = error as NSError? {
//                    self.handleAuthError(error: error)
//                    return
//                }
//            }
//            print(credential)
//        }
//    }
//    
//    func emailSignIn(email: String, password: String) {
//        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//            if let error = error as NSError? {
//                self.handleAuthError(error: error)
//                return
//            }
//        }
//    }
//    
//    func emailSignUp(email: String, password: String) {
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error as NSError? {
//                self.handleAuthError(error: error)
//                return
//            }
//        }
//    }
//    
//    func emailSendResetPassword(email: String, completion: @escaping (Bool) -> Void) {
//        var isSuccessful = true
//        Auth.auth().sendPasswordReset(withEmail: email) { error in
//            print(0)
//            if let error = error as NSError? {
//                self.handleAuthError(error: error)
//                isSuccessful = false
//                print(1)
//            }
//            print(2)
//            completion(isSuccessful)
//            print(3)
//        }
//    }
    
    func appleSignIn() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                self.errorTitle = "登錄失敗"
                self.errorMessage = "接收到登入回調，但未發送登入請求"
                
                return
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                self.errorTitle = "登錄失敗"
                self.errorMessage = "無法獲取身份驗證憑證"
                
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                self.errorTitle = "登錄失敗"
                self.errorMessage = appleIDToken.debugDescription
                
                return
            }
            
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error as NSError? {
                    self.handleAuthError(error: error)
                    
                    return
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let error = error as NSError? {
            if error.code != ASAuthorizationError.canceled.rawValue { // -5是取消錯誤 -1是未知錯誤，使用者按下不同的的取消分別會跳出這兩種
                self.errorTitle = "登錄失敗"
                self.errorMessage = error.localizedDescription
            }
                
            return
        }
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func logOut() async throws {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            self.handleAuthError(error: signOutError)
        }
    }
}
