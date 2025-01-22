import SwiftUI

struct EditLocationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var locationStore: LocationStore
    let location: Location
    
    @State private var title: String
    @State private var description: String
    @State private var showingImagePicker = false
    @State private var image: UIImage?
    @State private var customTags: Set<String>
    @State private var emoji: String
    @State private var showEmojiPicker = false
    
    init(locationStore: LocationStore, location: Location) {
        self.locationStore = locationStore
        self.location = location
        _title = State(initialValue: location.title)
        _description = State(initialValue: location.description)
        _customTags = State(initialValue: location.customTags)
        if let imageData = location.imageData {
            _image = State(initialValue: UIImage(data: imageData))
        }
        _emoji = State(initialValue: location.emoji)
    }
    
    var body: some View {
        NavigationView {
            Form {
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
            .navigationTitle("Edit Location")
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
        let updatedLocation = Location(
            id: location.id,
            title: title,
            description: description,
            latitude: location.latitude,
            longitude: location.longitude,
            imageData: image?.jpegData(compressionQuality: 0.8),
            customTags: customTags,
            emoji: emoji
        )
        locationStore.updateLocation(updatedLocation)
    }
} 
