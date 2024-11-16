//
//  DashboardViewModel.swift
//  HolyAI
//
//  Created by Nimi Akinroye on 2024-11-15.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var verseOfTheDay: String = "Loading..."
    @Published var reference: String = ""
    
    private let db = Firestore.firestore()
    
    func fetchVerseOfTheDay() {
        let cal = NSCalendar.current
        let day = String(cal.ordinality(of: .day, in: .year, for: Date()) ?? 1)
        
        db.collection("verses").document(day).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            if let document = document, document.exists {
                let data = document.data()!
                self.reference = data["reference"] as? String ?? "Unknown reference"
                self.verseOfTheDay = data["verse"] as? String ?? "Unknown verse"
            } else {
                print("Failed fetch the verse: \(error?.localizedDescription ?? "Unknown error")")
                self.verseOfTheDay = "Verse not found"
                self.reference = "Unknown reference"
            }
        }
        
    }
    
}
