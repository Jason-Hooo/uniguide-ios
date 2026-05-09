//
//  AppOpenAdManager.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/6.
//

import GoogleMobileAds

@MainActor
protocol AppOpenAdManagerDelegate: AnyObject {
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager)
}

@MainActor
class AppOpenAdManager: NSObject, FullScreenContentDelegate {

    var appOpenAd: AppOpenAd?
    weak var appOpenAdManagerDelegate: AppOpenAdManagerDelegate?
    var isLoadingAd = false
    var isShowingAd = false
    var loadTime: Date?
    
    static let shared = AppOpenAdManager()

    private func wasLoadTimeLessThan4HoursAgo() -> Bool {
        // Valid duration (in seconds) for a loaded App Open Ad (4 hours)
        if let loadTime = loadTime {
            return Date().timeIntervalSince(loadTime) < TimeInterval(4 * 3_600)
        }
        return false
    }
    
    private func isAdReady() -> Bool {
        return appOpenAd != nil && wasLoadTimeLessThan4HoursAgo()
    }

    func loadAd() async {
        // Do not load ad if there is an unused ad or one is already loading.
        if isLoadingAd || isAdReady() {
            return
        }
        isLoadingAd = true
        do {
            appOpenAd = try await AppOpenAd.load(
                with: "ca-app-pub-3940256099942544/5575463023",
                request: Request()
            )
            appOpenAd?.fullScreenContentDelegate = self
            loadTime = Date()
        } catch {
            print("App open ad failed to load with error: \(error.localizedDescription)")
            appOpenAd = nil
            loadTime = nil
        }
        print("loading successfully")
        isLoadingAd = false
    }

    func showAdIfAvailable() {
        // If the app open ad is already showing, do not show the ad again.
        if isShowingAd {
            return print("App open ad is already showing.")
        }
        
        // If the app open ad is not available yet but is supposed to show, load
        // a new ad.
        if !isAdReady() {
            print("App open ad is not ready yet.")
            appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
            // 是用來通知外部的委託物件（delegate）「App Open 廣告已經完成了」
            Task {
                // 在其他 thread 執行，就不等載入完再顯示廣告了，app open ad要及時才合理，不能讓 user 等
                await loadAd()
            }
            
            return
        }
        
        if let appOpenAd = appOpenAd {
            appOpenAd.present(from: nil)
            print("present successfully")
            isShowingAd = true
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("App open ad was dismissed.")
        appOpenAd = nil
        isShowingAd = false
        appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
        Task {
            await loadAd()
        }
    }
    
    func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("App open ad failed to present with error: \(error.localizedDescription)")
        appOpenAd = nil
        isShowingAd = false
        appOpenAdManagerDelegate?.appOpenAdManagerAdDidComplete(self)
        Task {
            await loadAd()
        }
    }

}
