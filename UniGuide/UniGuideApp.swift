//
//  UniGuideApp.swift
//  UniGuide
//
//  Created by 何杰陞 on 2024/12/4.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit
import FirebaseFirestore
import SwiftData
import GoogleMobileAds

@main
struct UniGuideApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            InitialView()
                .modelContainer(for: SearchHistory.self)
        }
    }
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        
//        navBarAppearance.largeTitleTextAttributes = [
//            .foregroundColor: UIColor(named: "cream") ?? UIColor.systemYellow,
//            .font: UIFont(name: "GenJyuuGothicX-Bold", size: 35)!
//        ]
//        navBarAppearance.titleTextAttributes = [
//            .foregroundColor: UIColor(named: "cream") ?? UIColor.systemYellow,
//            .font: UIFont(name: "GenJyuuGothicX-Medium", size: 20)!
//        ]
        // 以上暫時用不到，設定toolbarBackground後會讓此無效
//        navBarAppearance.backgroundColor = .systemBrown // NavigationBar的背景顏色
//        navBarAppearance.backgroundEffect = .none // NavigationBar的背景效果，有背景顏色就看不到這個了，會覆蓋掉
//        navBarAppearance.shadowColor = .black // 陰影顏色
        UINavigationBar.appearance().standardAppearance = navBarAppearance // 標準外觀
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance // 滾動時的外觀
        UINavigationBar.appearance().compactAppearance = navBarAppearance // 緊湊外觀（適用於一些較小的裝置）
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(180, 150, 120)
        // alert button color(brown)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        MobileAds.shared.start()
        
        let TEAM_ID = Bundle.main.infoDictionary?["TEAM_ID"] as! String
        do {
            try Auth.auth().useUserAccessGroup("\(TEAM_ID).com.Jason.UniGuide.shared")
        } catch let error as NSError {
            print("Error changing user access group: %@", error)
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]){
            return true
        }
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        return false
    }
    
}
