//
//  PredictionGuideView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2025/8/7.
//

import Foundation
import SwiftUI

struct PredictionGuideView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color("lightBrown"))
                .frame(height: 50)
                .overlay(alignment: .trailing) {
                    Button{
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .scaleEffect(1.1)
                            .padding(.trailing, 15)
                            .foregroundStyle(.gray.opacity(0.5))
                    }
                }
                .overlay(alignment: .center) {
                    Text("精準落點分析 - 使用說明")
                        .font(.custom("GenJyuuGothicX-Medium", size: 22))
                }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 說明文字
                    Text("精準落點分析提供三種成績輸入方式，讓考生依照自身情況選擇最合適的分析模式：")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                    
                    // 級分模式
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Circle()
                                .fill(.orange)
                                .frame(width: 12, height: 12)
                            
                            Text("級分")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        Text("將您輸入的成績視為「去年大考」的級分進行分析。")
                            .font(.body)
                        
                        Text("適用於：")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundColor(.orange)
                                    .fontWeight(.bold)
                                
                                Text("使用附有級分對照表的出版社題本練習（分析準確度較低）")
                                    .font(.subheadline)
                            }
                            
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundColor(.orange)
                                    .fontWeight(.bold)
                                
                                Text("練習「去年」的大考考古題（絕對準確）")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.leading, 8)
                    }
                    
                    // 分隔線
                    Divider()
                        .padding(.vertical, 8)
                    
                    // 百分比模式
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Circle()
                                .fill(.orange)
                                .frame(width: 12, height: 12)
                            
                            Text("百分比")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        Text("將您輸入的成績排名百分比（非 PR 值）轉換為「去年大考」成績，再進行分析。")
                            .font(.body)
                        
                        Text("適用於：")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundColor(.orange)
                                    .fontWeight(.bold)
                                
                                Text("使用提供排名百分比的題本或模擬考")
                                    .font(.subheadline)
                            }
                            
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundColor(.orange)
                                    .fontWeight(.bold)
                                
                                Text("參加校內舉辦的分科或學測模擬考")
                                    .font(.subheadline)
                            }
                            
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundColor(.orange)
                                    .fontWeight(.bold)
                                
                                Text("練習「前年」或更早的大考考古題")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.leading, 8)
                        
                        Text("（分析準確度高）")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                            .fontWeight(.medium)
                    }
                    
                    // 分隔線
                    Divider()
                        .padding(.vertical, 8)
                    
                    // 今年成績模式
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Circle()
                                .fill(.orange)
                                .frame(width: 12, height: 12)
                            
                            Text("今年成績")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        Text("將您輸入的「當年大考」成績自動轉換為排名百分比，並使用前述百分比模式進行落點分析。此模式省去查詢成績排名百分比的麻煩。")
                            .font(.body)
                        
                        Text("適用於：")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundColor(.orange)
                                    .fontWeight(.bold)
                                
                                Text("考完當年大考，在選填志願前想進行落點分析")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.leading, 8)
                        
                        Text("（分析準確度高）")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                            .fontWeight(.medium)
                    }
                    
                    // 分隔線
                    Divider()
                        .padding(.vertical, 8)
                    
                    // 免責聲明
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.orange)
                            Text("注意事項")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.orange)
                        }
                        
                        Text("分析結果僅供參考，建議搭配多個管道資訊評估，請依個人狀況謹慎選擇志願序。")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
    }
}
