//
//  TabButton.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-11-13.
//

import SwiftUI

struct TabButton: View {
    var icon: Image
    var title: String
    @Binding var selectedTab: CustomToolbar.Tab
    var tab: CustomToolbar.Tab
    
    
    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            VStack {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(selectedTab == tab ? Color.customColor : .gray)
                Text(title)
                    .font(Font.custom("Poppins-Regular", size: 12))
                    .foregroundStyle(selectedTab == tab ? Color.customColor : .gray)
            }
        }
        
    }
}

#Preview {
    @Previewable @State var selectedTab: CustomToolbar.Tab = .community
    
    TabButton(icon: Image(.community), title: "Community", selectedTab: $selectedTab, tab: .community)
}
