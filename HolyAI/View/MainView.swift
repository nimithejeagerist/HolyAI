//
//  MainView.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab: CustomToolbar.Tab = .home
    
    var body: some View {
        Group {
            if authViewModel.userSession !=   nil {
                ZStack {
                    // Main content area
                    VStack {
                        switch selectedTab {
                        case .home:
                            DashboardView()
                                .environmentObject(authViewModel)
                        case .plans:
                            StudyPlansView()
                                .environmentObject(authViewModel)
                        case .chats:
                            ConversationView()
                                .environmentObject(authViewModel)
                        case .community:
                            CommunityFeatures()
                                .environmentObject(authViewModel)
                        case .settings:
                            SettingsView()
                                .environmentObject(authViewModel)
                        }
                        
                        Spacer()
                        
                        CustomToolbar(selectedTab: $selectedTab)
                    }
                }
            } else {
                SignInView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MainView()
            .environmentObject(AuthViewModel())
    }
}
