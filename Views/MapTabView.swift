import SwiftUI
import MapKit

struct MapTabView: View {
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var locationStore: LocationStore
    @Binding var selectedTab: Int
    @Binding var centerLocation: Location?
    @Binding var showingAddLocation: Bool
    @State private var searchText = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            // Map View
            Map(coordinateRegion: $locationManager.region,
                showsUserLocation: true,
                annotationItems: locationStore.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    NavigationLink(destination: LocationDetailView(
                        locationStore: locationStore,
                        location: location,
                        selectedTab: $selectedTab,
                        centerLocation: $centerLocation
                    )) {
                        Text(location.emoji)
                            .font(.title)
                            .shadow(radius: 1)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accentColor(Color(AppearanceManager.accentColor))
                }
            }
            .ignoresSafeArea(.all, edges: [.horizontal, .bottom])
            .tint(Color(AppearanceManager.accentColor))
            
            // Search Bar
            SearchBar(
                searchText: $searchText,
                locationStore: locationStore,
                region: $locationManager.region
            )
            .padding(.top, 40)
            .padding(.horizontal)
        }
    }
}
