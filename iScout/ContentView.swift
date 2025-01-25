import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var locationStore = LocationStore()
    @State private var showingAddLocation = false
    @State private var selectedTab = 0
    @State private var centerLocation: Location?
    @AppStorage("hasSeenSplash") private var hasSeenSplash = false
    @State private var showingSplash = true
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Content based on selected tab
                Group {
                    if selectedTab == 0 {
                        // Map Tab
                        ZStack(alignment: .top) {
                            // Map content
                            ZStack {
                                MapTabView(
                                    locationManager: locationManager,
                                    locationStore: locationStore,
                                    selectedTab: $selectedTab,
                                    centerLocation: $centerLocation,
                                    showingAddLocation: $showingAddLocation
                                )
                                
                                VStack {
                                    Spacer()
                                    ButtonsView(
                                        onLocationTap: { locationManager.centerOnUser() },
                                        onAddTap: { showingAddLocation = true }
                                    )
                                    .padding(.bottom, 100)
                                }
                            }
                            
                            // Top bar overlay
                            VStack(spacing: 0) {
                                ZStack(alignment: .leading) {
                                    Image("paper_texture_top")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width + 40)
                                        .frame(height: 160)
                                        .offset(x: -20, y: 0)
                                        .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
                                    
                                    Image("iScout_logo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 36)
                                        .padding(.leading, 40)
                                        .padding(.top, 60)
                                }
                                .frame(height: 120)
                                .zIndex(2)
                                
                                SearchBar(
                                    searchText: .constant(""),
                                    locationStore: locationStore,
                                    region: $locationManager.region
                                )
                                .frame(maxWidth: UIScreen.main.bounds.width - 80)
                                .padding(.horizontal, 40)
                                .padding(.top, 32)
                                .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                                .zIndex(1)
                                
                                Spacer()
                            }
                            .allowsHitTesting(false)
                        }
                    } else if selectedTab == 1 {
                        // List Tab
                        LocationListView(
                            locationStore: locationStore,
                            selectedTab: $selectedTab,
                            centerLocation: $centerLocation
                        )
                        .navigationBarTitleDisplayMode(.inline)
                    } else {
                        // About Tab
                        AboutView()
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
                
                // Custom tab bar
                CustomTabBar(selectedTab: $selectedTab)
                    .ignoresSafeArea(edges: .bottom)
            }
            .ignoresSafeArea(.all, edges: .top)
            .sheet(isPresented: $showingAddLocation) {
                AddLocationView(
                    locationStore: locationStore,
                    initialLocation: locationManager.location,
                    mapRegion: locationManager.region
                )
            }
            .onChange(of: centerLocation) { location in
                if let location = location {
                    withAnimation {
                        locationManager.region = MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    }
                    centerLocation = nil // Reset after centering
                }
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(Color(AppearanceManager.accentColor))
        .overlay(
            // Splash screen
            Group {
                if !hasSeenSplash && showingSplash {
                    SplashView(showingSplash: $showingSplash)
                        .transition(.opacity)
                        .zIndex(1)
                        .background(Color(.systemBackground))
                }
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let locationManager = LocationManager()
        let locationStore = LocationStore()
        
        ContentView()
            .environmentObject(locationManager)
            .environmentObject(locationStore)
            .previewDisplayName("ContentView")
    }
}
