import Foundation

class LocationStore: ObservableObject {
    @Published var locations: [Location] = []
    @Published var searchText: String = ""
    private let saveKey = "SavedLocations"
    
    var filteredLocations: [Location] {
        guard !searchText.isEmpty else { return locations }
        return locations.filter { $0.matches(searchText: searchText) }
    }
    
    init() {
        loadLocations()
    }
    
    func addLocation(_ location: Location) {
        // Generate automatic tags
        var autoTags = Set(location.title.lowercased().split(by: " "))
        autoTags.formUnion(location.description.lowercased().split(by: " "))
        
        let locationWithTags = Location(
            id: location.id,
            title: location.title,
            description: location.description,
            latitude: location.latitude,
            longitude: location.longitude,
            imageData: location.imageData,
            customTags: location.customTags,
            autoTags: autoTags,
            emoji: location.emoji
        )
        
        DispatchQueue.main.async {
            self.locations.append(locationWithTags)
            self.saveLocations()
        }
    }
    
    func updateLocation(_ location: Location) {
        if let index = locations.firstIndex(where: { $0.id == location.id }) {
            // Generate automatic tags
            var autoTags = Set(location.title.lowercased().split(by: " "))
            autoTags.formUnion(location.description.lowercased().split(by: " "))
            
            let updatedLocation = Location(
                id: location.id,
                title: location.title,
                description: location.description,
                latitude: location.latitude,
                longitude: location.longitude,
                imageData: location.imageData,
                customTags: location.customTags,
                autoTags: autoTags,
                emoji: location.emoji
            )
            
            DispatchQueue.main.async {
                self.locations[index] = updatedLocation
                self.saveLocations()
            }
        }
    }
    
    func removeLocation(_ location: Location) {
        locations.removeAll { $0.id == location.id }
        saveLocations()
    }
    
    func shareLocation(_ location: Location) -> String {
        // Create a shareable string with location details
        return """
        Location: \(location.title)
        Description: \(location.description)
        Coordinates: \(location.latitude), \(location.longitude)
        Maps URL: https://maps.apple.com/?ll=\(location.latitude),\(location.longitude)
        """
    }
    
    private func saveLocations() {
        if let encoded = try? JSONEncoder().encode(locations) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
            UserDefaults.standard.synchronize() // Force immediate save
        }
    }
    
    private func loadLocations() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Location].self, from: data) {
            locations = decoded
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
