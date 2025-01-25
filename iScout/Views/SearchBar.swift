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
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var showingResults = false
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    var body: some View {
        VStack(spacing: 0) {
            // Search TextField
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search locations", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.none)
                    .onChange(of: searchText) { newValue in
                        if !newValue.isEmpty {
                            searchCompleter.queryFragment = newValue
                            showingResults = true
                        } else {
                            searchResults = []
                            showingResults = false
                        }
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        searchResults = []
                        showingResults = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
            
            // Search Results
            if showingResults && !searchResults.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(searchResults, id: \.self) { result in
                            Button(action: {
                                searchLocation(result)
                            }) {
                                VStack(alignment: .leading) {
                                    Text(result.title)
                                        .foregroundColor(.primary)
                                    Text(result.subtitle)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                            }
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
                .frame(maxHeight: 200)
            }
        }
    }
    
    private func searchLocation(_ result: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            
            withAnimation {
                region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
            
            searchText = ""
            searchResults = []
            showingResults = false
        }
    }
    
    init(searchText: Binding<String>, locationStore: LocationStore, region: Binding<MKCoordinateRegion>) {
        self._searchText = searchText
        self.locationStore = locationStore
        self._region = region
        
        searchCompleter.resultTypes = .pointOfInterest
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