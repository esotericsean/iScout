import SwiftUI
import MapKit

struct LocationDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var locationStore: LocationStore
    let location: Location
    @Binding var selectedTab: Int
    @Binding var centerLocation: Location?
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Map preview
                Button(action: showOnMap) {
                    ZStack(alignment: .bottomTrailing) {
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )), annotationItems: [location]) { location in
                            MapAnnotation(coordinate: location.coordinate) {
                                Text(location.emoji)
                                    .font(.title)
                                    .shadow(radius: 1)
                            }
                        }
                        
                        // Add a hint that the map is tappable
                        Text("View on Map")
                            .font(.caption)
                            .padding(8)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                            .padding(8)
                    }
                }
                .frame(height: 200)
                .cornerRadius(12)
                
                // Image if available
                if let imageData = location.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                }
                
                // Location details
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(location.emoji)
                            .font(.title)
                        Text(location.title)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    
                    Text(location.description)
                        .foregroundColor(.secondary)
                    
                    Text("Added on \(location.dateAdded.formatted(date: .long, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Add tags display
                    if !location.customTags.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Tags")
                                .font(.headline)
                                .padding(.top, 4)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(Array(location.customTags), id: \.self) { tag in
                                    Text(tag)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                
                // Add these buttons
                HStack {
                    Button(action: {
                        openInMaps()
                    }) {
                        Label("Directions", systemImage: "map.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        shareLocation()
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showingEditSheet = true }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: { showingDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditLocationView(locationStore: locationStore, location: location)
        }
        .alert("Delete Location", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                locationStore.removeLocation(location)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this location?")
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [locationStore.shareLocation(location)])
        }
    }
    
    private func showOnMap() {
        presentationMode.wrappedValue.dismiss()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.centerLocation = self.location
            self.selectedTab = 0
        }
    }
    
    private func openInMaps() {
        let placemark = MKPlacemark(coordinate: location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.title
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    
    private func shareLocation() {
        let shareText = locationStore.shareLocation(location)
        let av = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(av, animated: true)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
} 
