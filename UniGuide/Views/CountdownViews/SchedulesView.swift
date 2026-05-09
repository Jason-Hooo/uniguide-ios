//
//  SchedulesView.swift
//  UniGuide
//
//  Created by 何杰陞 on 2024/12/7.
//

import SwiftUI
import Foundation

struct SchedulesView: View {
    
    @EnvironmentObject private var schedulesManager: SchedulesManager
    @State private var isMidnight = false
    @AppStorage("hasSeenAlert") private var hasSeenAlert = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                //                sorted(by:) 會回傳一個新的 [Binding<Schedule>] 陣列，但這些 Binding 仍然指向
                //                userDataManager.userData.schedules 裡的原始 Schedule。
                if schedulesManager.isDataLoading {
                    LazyVStack {
                        ForEach(0..<10, id: \.self) { _ in
                            ScheduleSkeletonCardView()
                                .padding(.top, 15)
                                .padding(.horizontal)
                        }
                    }
                } else {
                    ForEach(
                        schedulesManager.schedules.sorted(by: {
                            if $0.isPin == $1.isPin {
                                return $0.startDate < $1.startDate
                            }
                            return $0.isPin
                        })
                    ) { schedule in
                        ScheduleWithContextMenu(schedule: schedule)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.brown, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink {
                        AddScheduleView()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color("cream"))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("倒數日事件")
                        .font(.custom("GenJyuuGothicX-Medium", size: 20))
                        .foregroundStyle(Color("cream"))
                }
            }
        }
        .onAppear {
            if !hasSeenAlert {
                showAlert = true
            }
        }
        .alert("重要通知", isPresented: $showAlert) {
            Button("確定") {}
            Button("下次不再顯示") {
                hasSeenAlert = true
            }
        } message: {
            Text("預設倒數日日期僅供參考，確切時間並無提供，若有需要請見大考中心官網")
        }
    }
}

struct ScheduleWithContextMenu: View {
    
    var schedule: Schedule
    @EnvironmentObject private var schedulesManager: SchedulesManager
    @State private var showDeletedAlert = false
    @State private var showResetAlert = false
    @State private var showEditView = false
    @Environment(\.colorScheme) private var colorScheme
    private var isDarkMode: Bool {
        colorScheme == .dark
    }
    
    var body: some View {
        VStack {
            OneScheduleView(schedule: schedule)
                .contextMenu {
                    ShareLink(
                        item: Image(uiImage: generateSnapshot(schedule: schedule, selectedKind: "天", isDarkMode: isDarkMode)),
                        preview: SharePreview(schedule.title, image: Image("uniGuide"))
                    ) {
                        Label("分享", systemImage: "square.and.arrow.up")
                    }
                    
                    Divider()
                    
                    Button {
                        let updateSchedule = Schedule(id: schedule.id, title: schedule.title, startDate: schedule.startDate, endDate: schedule.endDate, isPin: !schedule.isPin)
                        schedulesManager.updateSchedule(schedule: updateSchedule)
                    } label: {
                        HStack {
                            Text(schedule.isPin ? "取消釘選" : "釘選")
                            Image(systemName: schedule.isPin ? "pin.slash" : "pin")
                        }
                    }
                    
                    Button {
                        showEditView = true
                    } label: {
                        HStack {
                            Text("編輯")
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    
                    if schedule.isDefaultSchedule() {
                        Button(role: .destructive) {
                            showResetAlert = true
                        } label: {
                            HStack {
                                Text("重置")
                                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                            }
                        }
                    } else {
                        Button(role: .destructive) {
                            showDeletedAlert = true
                        } label: {
                            HStack {
                                Text("刪除")
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                .confirmationDialog("確認要刪除此事件嗎？此動作將無法返回", isPresented: $showDeletedAlert, titleVisibility: .visible) {
                    Button("刪除", role: .destructive) {
                        schedulesManager.deleteSchedule(schedule: schedule)
                    }
                    Button("取消", role: .cancel) {}
                }
                .confirmationDialog("確認要重置為預設倒數日嗎？當前事件內容將會被覆蓋", isPresented: $showResetAlert, titleVisibility: .visible) {
                    Button("重置", role: .destructive) {
                        schedulesManager.resetSchedule(schedule: schedule)
                    }
                    Button("取消", role: .cancel) {}
                }
                .navigationDestination(isPresented: $showEditView) {
                    EditScheduleView(schedule: schedule)
                }
                .padding(.top, 15)
                .padding(.horizontal)
        }
    }
    
}

//ForEach($userDataManager.userData.schedules) { $schedule in
//    if schedule.isPin {
//        ScheduleWithContextMenu(schedule: $schedule)
//    }
//}
//
//ForEach($userDataManager.userData.schedules) { $schedule in
//    if !schedule.isPin {
//        ScheduleWithContextMenu(schedule: $schedule)
//    }
//}
// 這樣寫ScheduleDetailView的navigationLink的binding就會失效，
// 因為使用了if schedule.isPin，超怪，似乎是swiftui的bug

#Preview {
    SchedulesView()
}
