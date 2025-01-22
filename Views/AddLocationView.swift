import SwiftUI
import CoreLocation
import MapKit

struct AddLocationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var locationStore: LocationStore
    let initialLocation: CLLocation?
    let mapRegion: MKCoordinateRegion
    
    @State private var title = ""
    @State private var description = ""
    @State private var showingImagePicker = false
    @State private var image: UIImage?
    @State private var region: MKCoordinateRegion
    @State private var customTags = Set<String>()
    @State private var emoji: String = "📍"
    @State private var showEmojiPicker = false
    
    init(locationStore: LocationStore, initialLocation: CLLocation?, mapRegion: MKCoordinateRegion) {
        self.locationStore = locationStore
        self.initialLocation = initialLocation
        self.mapRegion = mapRegion
        
        // Use the map region's center as the initial location
        _region = State(initialValue: MKCoordinateRegion(
            center: mapRegion.center,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location")) {
                    Map(coordinateRegion: $region, showsUserLocation: true)
                        .frame(height: 200)
                        .cornerRadius(8)
                }
                
                Section(header: Text("Details")) {
                    HStack {
                        TextField("Title", text: $title)
                        Button(emoji) {
                            showEmojiPicker = true
                        }
                    }
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section(header: Text("Photo")) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Text(image == nil ? "Add Photo" : "Change Photo")
                            Spacer()
                            if let image = image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            }
                        }
                    }
                }
                
                Section(header: Text("Tags")) {
                    TagEditor(tags: $customTags)
                }
            }
            .navigationTitle("Add Location")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    saveLocation()
                    dismiss()
                }
                .disabled(title.isEmpty)
            )
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $image)
            }
            .sheet(isPresented: $showEmojiPicker) {
                EmojiPickerView(selectedEmoji: $emoji)
            }
        }
    }
    
    private func saveLocation() {
        let coordinate = region.center
        let newLocation = Location(
            title: title,
            description: description,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            imageData: image?.jpegData(compressionQuality: 0.8),
            customTags: customTags,
            emoji: emoji
        )
        locationStore.addLocation(newLocation)
    }
}

struct AddLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AddLocationView(
            locationStore: LocationStore(),
            initialLocation: CLLocation(latitude: 37.331516, longitude: -121.891054),
            mapRegion: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
} 
