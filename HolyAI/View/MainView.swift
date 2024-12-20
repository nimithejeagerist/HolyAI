//
//  MainView.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-07-26.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedTab: CustomToolbar.Tab = .home
    
    private let lastInactiveKey = "lastInactiveTime"
    
    var body: some View {
        Group {
            if authVM.userSession !=   nil {
                ZStack {
                    // Main content area
                    VStack {
                        switch selectedTab {
                        case .home:
                            DashboardView()
                                .environmentObject(authVM)
                        case .plans:
                            StudyPlansView()
                                .environmentObject(authVM)
                        case .chats:
                            ConversationView()
                                .environmentObject(authVM)
                        case .community:
                            CommunityFeatures()
                                .environmentObject(authVM)
                        case .settings:
                            SettingsView()
                                .environmentObject(authVM)
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
                    .environmentObject(authVM)
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

