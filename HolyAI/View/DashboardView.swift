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
                    .frame(width: 400, height: 400)
                    .opacity(dashboardVM.imageOpacity!)
                    .scaledToFit()
                    .cornerRadius(20)
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
                    .foregroundStyle(dashboardVM.textColor!)
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
