//
//  MenuView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2024/12/9.
//

import SwiftUI
import FirebaseAuth
import MessageUI

struct MenuView: View {
    let width: CGFloat
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authService = AuthService.shared
    @StateObject private var userDataManager = UserDataManager.shared
    @State private var showErrorReport = false
    @State private var showUserTerms = false
    @State private var showPrivacyPolicy = false
    @State private var showAboutUs = false
    @State private var showHelpCenter = false
    @State private var showSettings = false
    @State private var showMyWishes = false
    @State private var showProfile = false
    @State private var showLogoutAlert = false
    @State private var showDeleteAccountAlert = false
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                // 动态渐变背景
                LinearGradient(
                    colors: [
                        Color("veryLightGray").opacity(0.3),
                        Color.white.opacity(0.8),
                        Color("myOrange").opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 现代化头部
                    modernHeaderView
                    
                    // 内容区域
                    GeometryReader { geometry in
                        ScrollView {
                            LazyVStack(spacing: 24) {
                                // 现代化用户信息卡片
                                modernUserCard
                                    .padding(.top, 8)
                                
                                // 主要功能区域
                                modernMenuSection(title: "主要功能", icon: "star.fill") {
                                    modernMenuRow(
                                        icon: "person.crop.circle.fill",
                                        title: "个人资料",
                                        subtitle: "管理您的个人信息",
                                        gradient: LinearGradient(colors: [Color("myOrange"), Color("myOrange").opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color("myOrange").opacity(0.3)
                                    ) {
                                        showProfile = true
                                    }
                                    
                                    modernMenuRow(
                                        icon: "heart.circle.fill",
                                        title: "我的志愿",
                                        subtitle: "查看和管理志愿列表",
                                        gradient: LinearGradient(colors: [Color("darkRed"), Color("darkRed").opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color("darkRed").opacity(0.3)
                                    ) {
                                        showMyWishes = true
                                    }
                                }
                                
                                // 应用设置区域
                                modernMenuSection(title: "应用设置", icon: "gearshape.fill") {
                                    modernMenuRow(
                                        icon: "gear.circle.fill",
                                        title: "设置",
                                        subtitle: "个性化您的应用体验",
                                        gradient: LinearGradient(colors: [Color("darkBrown"), Color("darkBrown").opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color("darkBrown").opacity(0.3)
                                    ) {
                                        showSettings = true
                                    }
                                    
                                    modernMenuRow(
                                        icon: "bell.circle.fill",
                                        title: "通知设置",
                                        subtitle: "管理推送通知",
                                        gradient: LinearGradient(colors: [Color("lightOrange"), Color("lightOrange").opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color("lightOrange").opacity(0.3)
                                    ) {
                                        // 通知设置逻辑
                                    }
                                    
                                    modernMenuRow(
                                        icon: "paintbrush.pointed.fill",
                                        title: "主题设置",
                                        subtitle: "更换应用外观",
                                        gradient: LinearGradient(colors: [Color("khaki"), Color("khaki").opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color("khaki").opacity(0.3)
                                    ) {
                                        // 主题设置逻辑
                                    }
                                    
                                    modernMenuRow(
                                        icon: "globe.badge.chevron.backward",
                                        title: "语言设置",
                                        subtitle: "选择您的语言偏好",
                                        gradient: LinearGradient(colors: [Color("lightBrown"), Color("lightBrown").opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color("lightBrown").opacity(0.3)
                                    ) {
                                        // 语言设置逻辑
                                    }
                                }
                                
                                // 帮助与支持区域
                                modernMenuSection(title: "帮助与支持", icon: "questionmark.circle.fill") {
                                    modernMenuRow(
                                        icon: "info.circle.fill",
                                        title: "帮助中心",
                                        subtitle: "获取使用帮助",
                                        gradient: LinearGradient(colors: [Color.blue, Color.blue.opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color.blue.opacity(0.3)
                                    ) {
                                        showHelpCenter = true
                                    }
                                    
                                    modernMenuRow(
                                        icon: "exclamationmark.triangle.fill",
                                        title: "错误回报",
                                        subtitle: "报告应用问题",
                                        gradient: LinearGradient(colors: [Color("darkRed"), Color("darkRed").opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color("darkRed").opacity(0.3)
                                    ) {
                                        showErrorReport = true
                                    }
                                }
                                
                                // 法律与条款区域
                                modernMenuSection(title: "法律与条款", icon: "doc.text.fill") {
                                    modernMenuRow(
                                        icon: "doc.plaintext.fill",
                                        title: "用户条款",
                                        subtitle: "查看使用条款",
                                        gradient: LinearGradient(colors: [Color.gray, Color.gray.opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color.gray.opacity(0.3)
                                    ) {
                                        showUserTerms = true
                                    }
                                    
                                    modernMenuRow(
                                        icon: "hand.raised.circle.fill",
                                        title: "隐私权政策",
                                        subtitle: "了解隐私保护",
                                        gradient: LinearGradient(colors: [Color.gray, Color.gray.opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color.gray.opacity(0.3)
                                    ) {
                                        showPrivacyPolicy = true
                                    }
                                    
                                    modernMenuRow(
                                        icon: "info.bubble.fill",
                                        title: "关于我们",
                                        subtitle: "了解 UniGuide",
                                        gradient: LinearGradient(colors: [Color("myOrange"), Color("myOrange").opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color("myOrange").opacity(0.3)
                                    ) {
                                        showAboutUs = true
                                    }
                                }
                                
                                // 账户管理区域
                                modernMenuSection(title: "账户管理", icon: "person.2.fill") {
                                    modernMenuRow(
                                        icon: "rectangle.portrait.and.arrow.right.fill",
                                        title: "登出",
                                        subtitle: "安全退出账户",
                                        gradient: LinearGradient(colors: [Color.orange, Color.orange.opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color.orange.opacity(0.3)
                                    ) {
                                        showLogoutAlert = true
                                    }
                                    
                                    modernMenuRow(
                                        icon: "trash.circle.fill",
                                        title: "删除账户",
                                        subtitle: "永久删除账户数据",
                                        gradient: LinearGradient(colors: [Color.red, Color.red.opacity(0.7)], startPoint: .leading, endPoint: .trailing),
                                        shadowColor: Color.red.opacity(0.3)
                                    ) {
                                        showDeleteAccountAlert = true
                                    }
                                }
                                
                                // 底部版本信息
                                modernVersionInfo
                                    .padding(.top, 20)
                                    .padding(.bottom, 40)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.light)
        .sheet(isPresented: $showErrorReport) {
            ErrorReportView()
        }
        .sheet(isPresented: $showUserTerms) {
            UserTermsView()
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showAboutUs) {
            AboutUsView()
        }
        .sheet(isPresented: $showHelpCenter) {
            HelpCenterView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showMyWishes) {
            MyWishesView()
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .alert("确认登出", isPresented: $showLogoutAlert) {
            Button("取消", role: .cancel) { }
            Button("登出", role: .destructive) {
                logout()
            }
        } message: {
            Text("确定要登出当前账户吗？")
        }
        .alert("确认删除账户", isPresented: $showDeleteAccountAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                deleteAccount()
            }
        } message: {
            Text("删除账户后，所有数据将无法恢复。此操作不可撤销。")
        }
        .onAppear {
            if let uid = Auth.auth().currentUser?.uid {
                userDataManager.observeUserData(uid: uid)
            }
        }
    }
    
    // MARK: - 现代化头部视图
    private var modernHeaderView: some View {
        HStack(spacing: 16) {
            // 关闭按钮
            Button(action: { dismiss() }) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color("darkBrown"))
                }
            }
            .buttonStyle(PressEffectButtonStyle())
            
            Spacer()
            
            // 标题
            VStack(spacing: 2) {
                Text("菜单")
                    .font(.custom("GenJyuuGothicX-Bold", size: 20))
                    .foregroundColor(Color("darkBrown"))
                
                Circle()
                    .fill(Color("myOrange"))
                    .frame(width: 4, height: 4)
            }
            
            Spacer()
            
            // 个人资料按钮
            Button(action: { showProfile = true }) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color("myOrange"))
                }
            }
            .buttonStyle(PressEffectButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial.opacity(0.8))
    }
    
    // MARK: - 现代化用户卡片
    private var modernUserCard: some View {
        VStack(spacing: 0) {
            // 装饰性顶部
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color("myOrange").opacity(0.3))
                    .frame(width: 40, height: 4)
                Spacer()
            }
            .padding(.top, 12)
            
            VStack(spacing: 20) {
                // 头像区域
                ZStack {
                    // 背景光环效果
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color("myOrange").opacity(0.2), Color("myOrange").opacity(0.05)],
                                center: .center,
                                startRadius: 40,
                                endRadius: 80
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(1.2)
                    
                    // 主头像
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color("myOrange"), Color("myOrange").opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 90, height: 90)
                            .shadow(color: Color("myOrange").opacity(0.4), radius: 20, x: 0, y: 8)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 42, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                
                // 用户信息
                VStack(spacing: 12) {
                    if let user = Auth.auth().currentUser {
                        Text(user.email ?? "未知用户")
                            .font(.custom("GenJyuuGothicX-Medium", size: 17))
                            .foregroundColor(Color("darkBrown"))
                            .lineLimit(1)
                    }
                    
                    // 统计信息
                    HStack(spacing: 0) {
                        // 能量统计
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color("myOrange").opacity(0.1))
                                    .frame(width: 60, height: 60)
                                
                                VStack(spacing: 2) {
                                    Text("\(userDataManager.userData?.energies ?? 0)")
                                        .font(.custom("GenJyuuGothicX-Bold", size: 20))
                                        .foregroundColor(Color("myOrange"))
                                    
                                    Text("能量")
                                        .font(.custom("GenJyuuGothicX-Normal", size: 10))
                                        .foregroundColor(Color("darkBrown").opacity(0.7))
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // 分割线
                        Rectangle()
                            .fill(Color("lightBrown").opacity(0.3))
                            .frame(width: 1, height: 40)
                        
                        Spacer()
                        
                        // 志愿统计
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color("darkRed").opacity(0.1))
                                    .frame(width: 60, height: 60)
                                
                                VStack(spacing: 2) {
                                    Text("0")
                                        .font(.custom("GenJyuuGothicX-Bold", size: 20))
                                        .foregroundColor(Color("darkRed"))
                                    
                                    Text("志愿")
                                        .font(.custom("GenJyuuGothicX-Normal", size: 10))
                                        .foregroundColor(Color("darkBrown").opacity(0.7))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.white)
                .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 8)
                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
        )
    }
    
    // MARK: - 现代化菜单区域
    private func modernMenuSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // 区域标题
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("myOrange").opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("myOrange"))
                }
                
                Text(title)
                    .font(.custom("GenJyuuGothicX-Bold", size: 16))
                    .foregroundColor(Color("darkBrown"))
                
                Spacer()
                
                // 装饰性元素
                Circle()
                    .fill(Color("myOrange").opacity(0.3))
                    .frame(width: 6, height: 6)
            }
            .padding(.horizontal, 4)
            
            // 菜单项容器
            VStack(spacing: 12) {
                content()
            }
        }
    }
    
    // MARK: - 现代化菜单行
    private func modernMenuRow(
        icon: String,
        title: String,
        subtitle: String,
        gradient: LinearGradient,
        shadowColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // 图标
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(gradient)
                        .frame(width: 48, height: 48)
                        .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                // 文字信息
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.custom("GenJyuuGothicX-Medium", size: 16))
                        .foregroundColor(Color("darkBrown"))
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.custom("GenJyuuGothicX-Normal", size: 13))
                        .foregroundColor(Color("lightBrown"))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // 箭头
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("lightBrown").opacity(0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
                    .shadow(color: .black.opacity(0.04), radius: 1, x: 0, y: 1)
            )
        }
        .buttonStyle(ModernPressEffectButtonStyle())
    }
    
    // MARK: - 现代化版本信息
    private var modernVersionInfo: some View {
        VStack(spacing: 12) {
            // 装饰性分割线
            HStack {
                Rectangle()
                    .fill(Color("lightBrown").opacity(0.3))
                    .frame(height: 1)
                
                Circle()
                    .fill(Color("myOrange").opacity(0.5))
                    .frame(width: 8, height: 8)
                
                Rectangle()
                    .fill(Color("lightBrown").opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.horizontal, 60)
            
            VStack(spacing: 8) {
                Text("UniGuide v1.0.0")
                    .font(.custom("GenJyuuGothicX-Medium", size: 14))
                    .foregroundColor(Color("darkBrown"))
                
                Text("© 2024 UniGuide. All rights reserved.")
                    .font(.custom("GenJyuuGothicX-Normal", size: 11))
                    .foregroundColor(Color("lightBrown").opacity(0.8))
            }
        }
    }
    
    // MARK: - 登出功能
    private func logout() {
        do {
            try Auth.auth().signOut()
            dismiss()
        } catch {
            print("登出失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 删除账户功能
    private func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.delete { error in
            if let error = error {
                print("删除账户失败: \(error.localizedDescription)")
            } else {
                dismiss()
            }
        }
    }
}

// MARK: - 自定义按钮样式
struct PressEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct ModernPressEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - 错误回报视图
struct ErrorReportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var subject = ""
    @State private var message = ""
    @State private var showMailComposer = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.white, Color("veryLightGray").opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("主题")
                                .font(.custom("GenJyuuGothicX-Medium", size: 16))
                                .foregroundColor(Color("darkBrown"))
                            
                            TextField("请输入错误主题", text: $subject)
                                .font(.custom("GenJyuuGothicX-Normal", size: 16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.white)
                                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("详细描述")
                                .font(.custom("GenJyuuGothicX-Medium", size: 16))
                                .foregroundColor(Color("darkBrown"))
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                                    .frame(height: 200)
                                
                                TextEditor(text: $message)
                                    .font(.custom("GenJyuuGothicX-Normal", size: 16))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(Color.clear)
                            }
                        }
                        
                        Spacer(minLength: 40)
                        
                        Button(action: {
                            if MFMailComposeViewController.canSendMail() {
                                showMailComposer = true
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text("发送报告")
                                    .font(.custom("GenJyuuGothicX-Bold", size: 16))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: subject.isEmpty || message.isEmpty ?
                                                [Color.gray.opacity(0.6), Color.gray.opacity(0.4)] :
                                                [Color("myOrange"), Color("myOrange").opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(
                                        color: subject.isEmpty || message.isEmpty ?
                                            Color.clear : Color("myOrange").opacity(0.3),
                                        radius: 12,
                                        x: 0,
                                        y: 6
                                    )
                            )
                        }
                        .disabled(subject.isEmpty || message.isEmpty)
                        .buttonStyle(PressEffectButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("错误回报")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(Color("darkBrown"))
                }
            }
        }
        .sheet(isPresented: $showMailComposer) {
            MailComposerView(
                subject: subject,
                message: message,
                isPresented: $showMailComposer
            )
        }
    }
}

// MARK: - 邮件发送视图
struct MailComposerView: UIViewControllerRepresentable {
    let subject: String
    let message: String
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setToRecipients(["support@uniguide.com"])
        composer.setSubject(subject)
        composer.setMessageBody(message, isHTML: false)
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposerView
        
        init(_ parent: MailComposerView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.isPresented = false
        }
    }
}

// MARK: - 其他现代化视图
struct UserTermsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ModernDetailView(
            title: "用户条款",
            content: "这里是用户条款的详细内容...",
            dismiss: dismiss
        )
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ModernDetailView(
            title: "隐私权政策",
            content: "这里是隐私权政策的详细内容...",
            dismiss: dismiss
        )
    }
}

struct AboutUsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.white, Color("veryLightGray").opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // 应用图标和信息
                        VStack(spacing: 24) {
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [Color("myOrange").opacity(0.2), Color("myOrange").opacity(0.05)],
                                            center: .center,
                                            startRadius: 60,
                                            endRadius: 120
                                        )
                                    )
                                    .frame(width: 160, height: 160)
                                
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color("myOrange"), Color("myOrange").opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                    .shadow(color: Color("myOrange").opacity(0.4), radius: 20, x: 0, y: 10)
                                
                                Image("uniGuide")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 16) {
                                Text("UniGuide")
                                    .font(.custom("GenJyuuGothicX-Bold", size: 32))
                                    .foregroundColor(Color("darkBrown"))
                                
                                HStack(spacing: 8) {
                                    Text("版本")
                                        .font(.custom("GenJyuuGothicX-Normal", size: 16))
                                        .foregroundColor(Color("lightBrown"))
                                    
                                    Text("1.0.0")
                                        .font(.custom("GenJyuuGothicX-Bold", size: 16))
                                        .foregroundColor(Color("myOrange"))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(Color("myOrange").opacity(0.1))
                                        )
                                }
                            }
                        }
                        
                        // 描述信息
                        VStack(spacing: 20) {
                            Text("UniGuide 是一个专为台湾学生设计的大学志愿填报辅助应用，帮助您更好地规划未来。")
                                .font(.custom("GenJyuuGothicX-Normal", size: 17))
                                .foregroundColor(Color("darkBrown"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 20)
                            
                            // 特色功能
                            VStack(spacing: 16) {
                                FeatureRow(icon: "graduationcap.fill", title: "智能推荐", description: "基于您的成绩和兴趣推荐合适的大学")
                                FeatureRow(icon: "heart.fill", title: "志愿管理", description: "轻松管理和编辑您的志愿列表")
                                FeatureRow(icon: "chart.bar.fill", title: "数据分析", description: "提供详细的录取数据分析")
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("关于我们")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        dismiss()
                    }
                    .foregroundColor(Color("darkBrown"))
                }
            }
        }
    }
}

// MARK: - 特色功能行组件
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("myOrange").opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("myOrange"))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("GenJyuuGothicX-Medium", size: 16))
                    .foregroundColor(Color("darkBrown"))
                
                Text(description)
                    .font(.custom("GenJyuuGothicX-Normal", size: 14))
                    .foregroundColor(Color("lightBrown"))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

struct HelpCenterView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ModernDetailView(
            title: "帮助中心",
            content: "这里是帮助中心的详细内容...",
            dismiss: dismiss
        )
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ModernDetailView(
            title: "设置",
            content: "这里是设置的详细内容...",
            dismiss: dismiss
        )
    }
}

struct MyWishesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ModernDetailView(
            title: "我的志愿",
            content: "这里是志愿的详细内容...",
            dismiss: dismiss
        )
    }
}

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ModernDetailView(
            title: "个人资料",
            content: "这里是个人资料的详细内容...",
            dismiss: dismiss
        )
    }
}

// MARK: - 通用现代化详情视图
struct ModernDetailView: View {
    let title: String
    let content: String
    let dismiss: DismissAction
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.white, Color("veryLightGray").opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // 标题区域
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color("myOrange"))
                                    .frame(width: 4, height: 32)
                                
                                Text(title)
                                    .font(.custom("GenJyuuGothicX-Bold", size: 28))
                                    .foregroundColor(Color("darkBrown"))
                                
                                Spacer()
                            }
                            
                            Rectangle()
                                .fill(Color("lightBrown").opacity(0.2))
                                .frame(height: 1)
                        }
                        
                        // 内容区域
                        VStack(alignment: .leading, spacing: 20) {
                            Text(content)
                                .font(.custom("GenJyuuGothicX-Normal", size: 17))
                                .foregroundColor(Color("darkBrown"))
                                .lineSpacing(6)
                            
                            // 占位内容
                            VStack(spacing: 16) {
                                ForEach(0..<3, id: \.self) { index in
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(Color("myOrange").opacity(0.2))
                                            .frame(width: 8, height: 8)
                                        
                                        Text("这里可以添加更多详细的内容信息...")
                                            .font(.custom("GenJyuuGothicX-Normal", size: 16))
                                            .foregroundColor(Color("lightBrown"))
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 4)
                        )
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        dismiss()
                    }
                    .foregroundColor(Color("darkBrown"))
                }
            }
        }
    }
}
