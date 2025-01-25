import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            // Background
            Image("paper_texture_bottom")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 90)
                .shadow(color: .black.opacity(0.3), radius: 5, y: -3)
            
            // Tab items
            HStack(spacing: 120) {  // Large fixed spacing
                TabBarButton(
                    imageName: "map",
                    title: "Map",
                    isSelected: selectedTab == 0,
                    action: { selectedTab = 0 }
                )
                
                TabBarButton(
                    imageName: "list.bullet",
                    title: "Locations",
                    isSelected: selectedTab == 1,
                    action: { selectedTab = 1 }
                )
                
                TabBarButton(
                    imageName: "person.circle",
                    title: "About",
                    isSelected: selectedTab == 2,
                    action: { selectedTab = 2 }
                )
            }
            .padding(.bottom, 8)
        }
        .frame(height: 90)
    }
}

struct TabBarButton: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: imageName)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? Color(AppearanceManager.accentColor) : Color(AppearanceManager.unselectedColor))
        }
    }
} 
