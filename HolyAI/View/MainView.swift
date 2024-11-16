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
    
    private let lastInactiveKey = "lastInactiveTime"
    
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
                .onAppear {
                    setupAppStateObservers()
                }
                
            } else {
                SignInView()
                    .environmentObject(authViewModel)
            }
        }
    }
    
    private func setupAppStateObservers() {
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { _ in
            // Store the current time when the app goes to the background
            UserDefaults.standard.set(Date(), forKey: lastInactiveKey)
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
            // Retrieve the last inactive time
            if let lastTime = UserDefaults.standard.object(forKey: lastInactiveKey) as? Date {
                let timeDifference = Date().timeIntervalSince(lastTime)
                let timeoutDuration: TimeInterval = 10 * 60 // 10 minutes
                
                // Reset to Dashboard if the timeout duration has been exceeded
                if timeDifference > timeoutDuration {
                    selectedTab = .home
                }
            }
        }
    }
    
    
}

