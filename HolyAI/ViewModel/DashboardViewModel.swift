import UIKit
import SwiftUI
import FirebaseFirestore
import FirebaseStorage

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var verseOfTheDay: String = "Loading..."
    @Published var referenceOfTheDay: String = ""
    @Published var imageOfTheDay: URL?
    
    private let db = Firestore.firestore()

    func fetchContentOfTheDay() {
        let cal = NSCalendar.current
        let day = String(cal.ordinality(of: .day, in: .year, for: Date()) ?? 1)
        
        print("Fetching content for day: \(day)")
        
        // Fetch Verse and Image URL from Firestore
        db.collection("verses").document(day).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                let data = document.data()!
                self.referenceOfTheDay = data["reference"] as? String ?? "Unknown reference"
                self.verseOfTheDay = data["verse"] as? String ?? "Unknown verse"
                
                print("Successfully fetched verse: \(self.verseOfTheDay)")
                
                // Fetch Image URL from document and load it
                if let imageUrlString = data["imageUrl"] as? String, let imageUrl = URL(string: imageUrlString) {
                    self.imageOfTheDay = imageUrl
                }
            } else {
                print("Failed to fetch the verse: \(error?.localizedDescription ?? "Unknown error")")
                self.verseOfTheDay = "Verse not found"
                self.referenceOfTheDay = "Unknown reference"
            }
        }
    }
}
