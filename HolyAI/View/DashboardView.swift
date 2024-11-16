//
//  DashboardView.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-11-13.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var dashboardVM = DashboardViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Verse of the Day")
                .font(.title)
                .bold()
            
            Text(dashboardVM.reference)
                .font(.headline)
                .padding()
            
            Text(dashboardVM.verseOfTheDay)
                .font(.body)
                .padding()
                .multilineTextAlignment(.center)
        }
        .padding()
        .onAppear {
            dashboardVM.fetchVerseOfTheDay()
        }
    }
}

#Preview {
    DashboardView()
}
