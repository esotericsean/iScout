//
//  ContentView.swift
//  iScout
//
//  Created by Sean Duran on 1/21/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var locationStore = LocationStore()
    @State private var showingAddLocation = false
    @State private var searchText = ""
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var selectedTab = 0
    @State private var centerLocation: Location?
    @AppStorage("hasSeenSplash") private var hasSeenSplash = false
    @State private var showingSplash = true
    @State private var showSearchBar = true
    
    var body: some View {
        ZStack {
            NavigationView {
                TabView(selection: $selectedTab) {
                    // Map Tab
                    ZStack(alignment: .top) {
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
                            }
                        }
                        .ignoresSafeArea(.all, edges: [.horizontal, .bottom])
                        .overlay(
                            Button(action: {
                                locationManager.centerOnUser()
                            }) {
                                Image(systemName: "location.fill")
                                    .font(.title2)
                                    .padding(12)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                            .padding()
                            , alignment: .bottomLeading
                        )
                        
                        if showSearchBar {
                            SearchBar(
                                searchText: $searchText,
                                locationStore: locationStore,
                                region: $locationManager.region
                            )
                            .padding(.top, 40)
                            .padding(.horizontal)
                        }
                    }
                    .overlay(
                        Button(action: {
                            showingAddLocation = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.bottom, 70)
                        , alignment: .bottomTrailing
                    )
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                    .tag(0)
                    .toolbarBackground(.hidden, for: .tabBar)
                    
                    // List Tab
                    LocationListView(
                        locationStore: locationStore,
                        selectedTab: $selectedTab,
                        centerLocation: $centerLocation
                    )
                    .tabItem {
                        Label("Locations", systemImage: "list.bullet")
                    }
                    .tag(1)
                    
                    // About Tab
                    AboutView()
                        .tabItem {
                            Label("About", systemImage: "person.circle")
                        }
                        .tag(2)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Image("paper_texture_top")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width + 40)
                                    .frame(height: 120)
                                    .clipped()
                                    .offset(x: -20, y: -50)
                                    .shadow(color: .black.opacity(0.3), radius: 5, y: 3)
                                    .edgesIgnoringSafeArea(.all)
                                
                                Image("iScout_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 32)
                                    .padding(.leading, 16)
                                    .offset(y: -28)
                            }
                        }
                        .frame(height: 60)
                    }
                }
                .navigationViewStyle(.stack)
                .ignoresSafeArea(.container, edges: .top)
                .sheet(isPresented: $showingAddLocation) {
                    AddLocationView(
                        locationStore: locationStore,
                        initialLocation: locationManager.location,
                        mapRegion: locationManager.region
                    )
                }
                .onAppear {
                    let tabBarAppearance = UITabBarAppearance()
                    tabBarAppearance.configureWithTransparentBackground()
                    
                    if let tabBarBackground = UIImage(named: "paper_texture_bottom") {
                        // Create a size that matches the screen width exactly
                        let targetSize = CGSize(
                            width: UIScreen.main.bounds.width,
                            height: tabBarBackground.size.height * 1.6  // Slightly larger multiplier
                        )
                        
                        let renderer = UIGraphicsImageRenderer(size: targetSize)
                        let imageWithShadow = renderer.image { context in
                            context.cgContext.setShadow(
                                offset: CGSize(width: 0, height: -3),
                                blur: 5,
                                color: UIColor.black.withAlphaComponent(0.3).cgColor
                            )
                            
                            // Draw the background image stretched to screen width
                            tabBarBackground.draw(in: CGRect(
                                x: 0,
                                y: 0,  // Remove the offset completely
                                width: targetSize.width,
                                height: targetSize.height
                            ))
                        }
                        
                        tabBarAppearance.backgroundImage = imageWithShadow
                        tabBarAppearance.backgroundEffect = nil
                        tabBarAppearance.shadowImage = nil
                        
                        // Adjust text position and colors
                        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .black
                        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
                        tabBarAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 12)
                        
                        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .black
                        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]
                        tabBarAppearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 12)
                        
                        UITabBar.appearance().standardAppearance = tabBarAppearance
                        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                        UITabBar.appearance().backgroundColor = .clear
                        UITabBar.appearance().backgroundImage = UIImage()
                        
                        // Try adjusting the tab bar item appearance directly
                        let appearance = UITabBarItem.appearance()
                        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 12)
                        appearance.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: -12, right: 0)
                    }
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
                .onChange(of: selectedTab) { newValue in
                    showSearchBar = (newValue == 0)
                }
            }
            
            if !hasSeenSplash && showingSplash {
                SplashView(showingSplash: $showingSplash)
                    .transition(.opacity)
                    .zIndex(1)
                    .background(Color(.systemBackground))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarBackground(.hidden, for: .tabBar)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
