import SwiftUI

struct LocationListView: View {
    @ObservedObject var locationStore: LocationStore
    @Binding var selectedTab: Int
    @Binding var centerLocation: Location?
    
    var body: some View {
        List {
            ForEach(locationStore.filteredLocations.sorted { $0.dateAdded > $1.dateAdded }) { location in
                NavigationLink(destination: LocationDetailView(
                    locationStore: locationStore,
                    location: location,
                    selectedTab: $selectedTab,
                    centerLocation: $centerLocation
                )) {
                    LocationRow(location: location)
                }
            }
        }
        .navigationTitle("Saved Locations")
        .searchable(text: $locationStore.searchText, prompt: "Search locations...")
    }
}

struct LocationRow: View {
    let location: Location
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageData = location.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(location.title)
                    .font(.headline)
                Text(location.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                Text(location.dateAdded.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LocationListView(
                locationStore: LocationStore(),
                selectedTab: .constant(0),
                centerLocation: .constant(nil)
            )
        }
    }
}
