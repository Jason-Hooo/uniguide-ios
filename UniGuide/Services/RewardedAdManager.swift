//
//  RewardedAdManager.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/5.
//

import GoogleMobileAds
import SwiftUI

class RewardedAdManager: NSObject, ObservableObject, FullScreenContentDelegate {

    @Published var isAdReady = false
    @Published var errorMessage: ErrorMessage? = nil
    private var rewardedAd: RewardedAd?
    
    override init() {
        super.init()
        Task {
           await loadAd()
        }
    }
    
    func loadAd() async {
        do {
            rewardedAd = try await RewardedAd.load(
                with: "ca-app-pub-3940256099942544/1712485313", request: Request())
            self.rewardedAd?.fullScreenContentDelegate = self
            await MainActor.run {
                self.isAdReady = true
                print("廣告載入成功")
            }
        } catch {
            await MainActor.run {
                self.isAdReady = false
                self.errorMessage = ErrorMessage(message: "廣告載入失敗: \(error.localizedDescription)")
            }
        }
    }
    
    func showAd() async {
        if !isAdReady {
            await loadAd()
        }
        guard let ad = rewardedAd else {
            await MainActor.run {
                self.errorMessage = ErrorMessage(message: "廣告尚未準備完成，請稍後再試。")
            }
            return
        }
        await ad.present(from: nil) {
            Task { @MainActor in
                UserDataManager.shared.changeEnergies(amount: 1)
            }
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        // ad has been closed, so reload the new ad
        isAdReady = false
        Task {
            await loadAd()
        }
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        // showing the ad encounter an error
        errorMessage = ErrorMessage(message: "廣告顯示失敗: \(error.localizedDescription)")
        isAdReady = false
        Task {
            await loadAd()
        }
    }
    
}
