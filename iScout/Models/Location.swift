import Foundation
import CoreLocation

struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var latitude: Double
    var longitude: Double
    var imageData: Data?
    var dateAdded: Date
    var autoTags: Set<String>
    var customTags: Set<String>
    var emoji: String
    
    var allTags: Set<String> {
        autoTags.union(customTags)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: UUID = UUID(), title: String, description: String = "", latitude: Double, longitude: Double, imageData: Data? = nil, customTags: Set<String> = [], autoTags: Set<String> = [], emoji: String = "📍") {
        self.id = id
        self.title = title
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.imageData = imageData
        self.dateAdded = Date()
        self.customTags = customTags
        self.autoTags = autoTags
        self.emoji = emoji
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // Add search functionality
    func matches(searchText: String) -> Bool {
        let searchTerms = searchText.lowercased().split(separator: " ")
        let locationText = "\(title) \(description)".lowercased()
        
        return searchTerms.allSatisfy { term in
            locationText.contains(term)
        }
    }
}

private extension String {
    func split(by separator: Character) -> [String] {
        self.split(separator: separator)
            .map(String.init)
            .filter { !$0.isEmpty }
    }
} 