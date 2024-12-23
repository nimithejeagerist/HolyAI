import UIKit
import SwiftUI
import FirebaseFirestore
import FirebaseStorage

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UIColor {
    func isBright() -> CGFloat {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let brightness = (0.299 * red + 0.587 * green + 0.114 * blue)
        return brightness
    }
}

final class DashboardViewModel: ObservableObject {
    @Published var verseOfTheDay: String = "Loading..."
    @Published var referenceOfTheDay: String = ""
    @Published var imageOfTheDay: URL?
    @Published var averageColor: UIColor?
    
    @Published var imageBrightness: CGFloat?
    @Published var imageOpacity: Double?
    @Published var textColor: Color?
    
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
                    setAverageColor(url: imageUrl)
                    printVariables()
                    
                    self.imageOfTheDay = imageUrl
                    
                }
            } else {
                print("Failed to fetch the verse: \(error?.localizedDescription ?? "Unknown error")")
                self.verseOfTheDay = "Verse not found"
                self.referenceOfTheDay = "Unknown reference"
            }
        }
    }
    
    private func setAverageColor(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let data = data, let uiImage = UIImage(data: data) {
                let workItem = DispatchWorkItem {
                    self.averageColor = uiImage.averageColor
                    self.imageBrightness = self.averageColor?.isBright()
                    
                    if self.imageBrightness! > 0.5 {
                        self.imageOpacity = 1.0
                        self.textColor = .black
                    } else {
                        self.imageOpacity = 0.7
                        self.textColor = .white
                    }
                }
                
                DispatchQueue.main.async(execute: workItem)
            } else {
                print("Failed to fetch image with: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        task.resume()
    }
    
    private func printVariables() -> Void {
        print("Image brightness: \(self.imageBrightness)")
        print("Image opacity: \(self.imageOpacity)")
    }
    
}
