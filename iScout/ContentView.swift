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
                        
                        SearchBar(
                            searchText: $searchText,
                            locationStore: locationStore,
                            region: $locationManager.region
                        )
                        .padding()
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
                .navigationTitle("iScout")
                .sheet(isPresented: $showingAddLocation) {
                    AddLocationView(
                        locationStore: locationStore,
                        initialLocation: locationManager.location,
                        mapRegion: locationManager.region
                    )
                }
                .onAppear {
                    // Set tab bar appearance
                    let appearance = UITabBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                    UITabBar.appearance().standardAppearance = appearance
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
            
            if !hasSeenSplash && showingSplash {
                SplashView(showingSplash: $showingSplash)
                    .transition(.opacity)
                    .zIndex(1)
                    .background(Color(.systemBackground))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
