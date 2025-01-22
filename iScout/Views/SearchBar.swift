import SwiftUI
import MapKit

struct SearchResult: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let coordinate: CLLocationCoordinate2D
    let isSavedLocation: Bool
    let savedLocation: Location?
    
    init(mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        self.subtitle = mapItem.placemark.formattedAddress
        self.coordinate = mapItem.placemark.coordinate
        self.isSavedLocation = false
        self.savedLocation = nil
    }
    
    init(location: Location) {
        self.title = location.title
        self.subtitle = location.description
        self.coordinate = location.coordinate
        self.isSavedLocation = true
        self.savedLocation = location
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    @ObservedObject var locationStore: LocationStore
    @Binding var region: MKCoordinateRegion
    @State private var searchResults: [SearchResult] = []
    @State private var isSearching = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search locations...", text: $searchText)
                    .autocapitalization(.none)
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        searchResults = []
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if !searchResults.isEmpty {
                List(searchResults) { result in
                    Button(action: {
                        selectSearchResult(result)
                    }) {
                        VStack(alignment: .leading) {
                            Text(result.title)
                                .font(.headline)
                            Text(result.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .frame(maxHeight: 300)
            }
        }
        .onChange(of: searchText) { newValue in
            if !newValue.isEmpty {
                performSearch(query: newValue)
            } else {
                searchResults = []
            }
        }
    }
    
    private func performSearch(query: String) {
        // Search saved locations
        let savedResults = locationStore.locations
            .filter { $0.matches(searchText: query) }
            .map { SearchResult(location: $0) }
        
        // Search MapKit
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        searchRequest.region = region
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                searchResults = savedResults
                return
            }
            
            let mapResults = response.mapItems.map { SearchResult(mapItem: $0) }
            searchResults = savedResults + mapResults
        }
    }
    
    private func selectSearchResult(_ result: SearchResult) {
        withAnimation {
            region = MKCoordinateRegion(
                center: result.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
        searchText = ""
        searchResults = []
    }
}

extension MKPlacemark {
    var formattedAddress: String {
        let components = [
            subThoroughfare,
            thoroughfare,
            locality,
            administrativeArea,
            postalCode
        ].compactMap { $0 }
        return components.joined(separator: " ")
    }
} 