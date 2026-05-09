//
//  EnergyBarView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/2.
//

import Foundation
import SwiftUI

struct EnergyBarView: View {
    @EnvironmentObject private var userDataManager: UserDataManager
    @StateObject private var rewardedAdManager = RewardedAdManager()
    private let maxAnalyses: Int = 3
    @Environment(\.colorScheme) private var colorScheme
    @Binding var shouldShowAd: Bool
    @Binding var showAddEnergySheet: Bool
    private var energies: Int {
        userDataManager.userData?.energies ?? 0
    }
    
    var body: some View {
        Button {
            showAddEnergySheet = true
        } label: {
            HStack(spacing: 4) {
                // 能量條主體
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    // 能量格子
                    HStack(spacing: 3) {
                        ForEach(0..<maxAnalyses, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 3)
                                .fill(
                                    index < energies
                                    ? LinearGradient(
                                        colors: [.orange.opacity(0.9), .yellow.opacity(0.8)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    : LinearGradient(
                                        colors: [.gray.opacity(0.2), .gray.opacity(0.1)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 7, height: 18)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(
                                            index < energies
                                            ? .orange.opacity(0.3)
                                            : .clear,
                                            lineWidth: 0.5
                                        )
                                )
                                .scaleEffect(
                                    index < energies ? 1.0 : 0.9
                                )
                                .animation(
                                    .spring(response: 0.4, dampingFraction: 0.8)
                                    .delay(Double(index) * 0.05),
                                    value: energies
                                )
                        }
                    }
                    
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(
                    Capsule()
                        .fill(.orange.opacity(0.08))
                        .overlay(
                            Capsule()
                                .stroke(.orange.opacity(0.2), lineWidth: 0.5)
                        )
                )
                
                Image(systemName: "plus")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.orange)
                
            }
            .sheet(isPresented: $showAddEnergySheet, onDismiss: {
                if shouldShowAd {
                    Task {
                        await rewardedAdManager.showAd()
                        shouldShowAd = false
                    }
                }
            }) {
                EnergyOptionsView(
                    rewardedAdManager: rewardedAdManager,
                    showingEnergySheet: $showAddEnergySheet,
                    shouldShowAd: $shouldShowAd
                )
                .presentationDetents([.medium])
                .presentationBackground(.thinMaterial)
            }
            .alert(item: $rewardedAdManager.errorMessage) { errorMessage in
                Alert(title: Text("發生錯誤"),
                      message: Text(errorMessage.message),
                      dismissButton: .default(Text("確認")))
            }
        }
    }
}

struct EnergyOptionsView: View {
    @EnvironmentObject private var userDataManager: UserDataManager
    @ObservedObject var rewardedAdManager: RewardedAdManager
    @Binding var showingEnergySheet: Bool
    @Binding var shouldShowAd: Bool
    let maxAnalyses: Int = 3
    @State private var selectedOption: Int? = nil
    private var energies: Int {
        userDataManager.userData?.energies ?? 0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 頂部標題區域
            VStack(spacing: 16) {
                // 能量圖標
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.yellow.opacity(0.3), .orange.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                
                VStack(spacing: 8) {
                    Text("補充能量")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("剩餘 \(energies)/\(maxAnalyses) 次分析")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                        )
                }
            }
            .padding(.top, 40)
            .padding(.bottom, 32)
            
            // 選項卡片
            VStack(spacing: 16) {
                // 看廣告選項
                Button(action: {
                    showingEnergySheet = false
                    shouldShowAd = true
                    selectedOption = 1
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        if remainingAnalyses < maxAnalyses {
//                            remainingAnalyses += 1
//                        }
//                        selectedOption = nil
//                    }
                }) {
                    EnergyOptionCard(
                        icon: "play.rectangle.fill",
                        iconColor: .orange,
                        title: "觀看廣告",
                        subtitle: "立即獲得 1 點能量",
                        benefit: "+1",
                        gradientColors: [.orange.opacity(0.8), .red.opacity(0.6)],
                        isSelected: selectedOption == 1,
                        isEnabled: energies < maxAnalyses
                    )
                }
                .disabled(energies >= maxAnalyses)
                
                // 買斷選項
                Button(action: {
                    selectedOption = 2
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        //energies = maxAnalyses
                        selectedOption = nil
                    }
                }) {
                    EnergyOptionCard(
                        icon: "crown.fill",
                        iconColor: .white,
                        title: "Pro 解鎖",
                        subtitle: "永久無限能量",
                        benefit: "∞",
                        gradientColors: [.blue, .purple],
                        isSelected: selectedOption == 2,
                        isEnabled: true,
                        isPro: true
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer(minLength: 40)
        }
        .background(
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0.95),
                    Color(.secondarySystemBackground).opacity(0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct EnergyOptionCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let benefit: String
    let gradientColors: [Color]
    let isSelected: Bool
    let isEnabled: Bool
    var isPro: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            // 左側圖標
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(
                        color: gradientColors[0].opacity(0.3),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(iconColor)
            }
            
            // 中間內容
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    if isPro {
                        Text("HOT")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(.red)
                            )
                    }
                    
                    Spacer()
                }
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            // 右側效益顯示
            VStack {
                Text(benefit)
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThickMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: isSelected ? gradientColors : [.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isSelected ? 2 : 0
                        )
                )
        )
        .scaleEffect(isSelected ? 0.98 : 1.0)
        .opacity(isEnabled ? 1.0 : 0.5)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .shadow(
            color: isSelected ? gradientColors[0].opacity(0.2) : .black.opacity(0.05),
            radius: isSelected ? 12 : 6,
            x: 0,
            y: isSelected ? 6 : 3
        )
    }
}
