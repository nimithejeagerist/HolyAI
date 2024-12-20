//
//  DashboardView.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-11-13.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var dashboardVM = DashboardViewModel()
    
    var body: some View {
        ZStack {
            AsyncImage(url: dashboardVM.imageOfTheDay) { image in
                image
                    .resizable()
                    .frame(width: 500, height: 500)
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            
            VStack(spacing: 20) {
                Text("Verse of the Day")
                    .font(.title)
                    .bold()
                
                Text(dashboardVM.referenceOfTheDay)
                    .font(.headline)
                    .padding()
                
                Text(dashboardVM.verseOfTheDay)
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            .padding()
            .onAppear {
                dashboardVM.fetchContentOfTheDay()
            }
        }
    }
}

#Preview {
    DashboardView()
}
