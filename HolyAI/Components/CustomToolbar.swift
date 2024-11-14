//
//  CustomToolbar.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-11-13.
//

import SwiftUI

struct CustomToolbar: View {
    @Binding var selectedTab: Tab
    
    enum Tab: Hashable {
        case home, plans, chats, community, settings
    }
    
    var body: some View {
        HStack {
            TabButton(icon: Image(.home), title: "Home", selectedTab: $selectedTab, tab: .home)
            Spacer()
            TabButton(icon: Image(.plans), title: "Plans", selectedTab: $selectedTab, tab: .plans)
            Spacer()
            TabButton(icon: Image(.chats), title: "Chats", selectedTab: $selectedTab, tab: .chats)
            Spacer()
            TabButton(icon: Image(.community), title: "Community", selectedTab: $selectedTab, tab: .community)
            Spacer()
            TabButton(icon: Image(.settings), title: "Settings", selectedTab: $selectedTab, tab: .settings)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @State var selectedTab: CustomToolbar.Tab = .home
    
    CustomToolbar(selectedTab: $selectedTab)
}
