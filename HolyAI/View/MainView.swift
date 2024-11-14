//
//  MainView.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.userSession == nil {
                TabView {
                    DashboardView()
                        .environmentObject(authViewModel)
                        .tabItem {
                            Image(.home)
                            Text("Home")
                        }
                    
                    StudyPlansView()
                        .environmentObject(authViewModel)
                        .tabItem {
                            Image(.reading)
                            Text("Plans")
                        }
                    
                    ConversationView()
                        .environmentObject(authViewModel)
                        .tabItem {
                            Image(.read)
                            Text("Conversations")
                        }
                    
                    CommunityFeatures()
                        .environmentObject(authViewModel)
                        .tabItem {
                            Image(.crowdOfUsers)
                            Text("Community")
                        }
                    
                    SettingsView()
                        .environmentObject(authViewModel)
                        .tabItem {
                            Image(.settings)
                            Text("Settings")
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
