import SwiftUI

struct LocationListView: View {
    @ObservedObject var locationStore: LocationStore
    @Binding var selectedTab: Int
    @Binding var centerLocation: Location?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(locationStore.filteredLocations.sorted { $0.dateAdded > $1.dateAdded }) { location in
                    NavigationLink(destination: LocationDetailView(
                        locationStore: locationStore,
                        location: location,
                        selectedTab: $selectedTab,
                        centerLocation: $centerLocation
                    )) {
                        LocationRow(location: location)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .frame(maxWidth: UIScreen.main.bounds.width)
                    }
                    Divider()
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .padding(.top, safeAreaInsets.top + 20)
        .padding(.bottom, 90)
    }
    
    private var safeAreaInsets: EdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return EdgeInsets() }
        
        let insets = window.safeAreaInsets
        return EdgeInsets(
            top: insets.top,
            leading: insets.left,
            bottom: insets.bottom,
            trailing: insets.right
        )
    }
}

struct LocationRow: View {
    let location: Location
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Group {
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
            }
            .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(location.emoji)
                        .font(.headline)
                    Text(location.title)
                        .font(.headline)
                        .lineLimit(1)
                }
                Text(location.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                Text(location.dateAdded.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
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
