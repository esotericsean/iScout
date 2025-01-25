import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: Int
    let content: AnyView
    let searchBar: AnyView
    
    var body: some View {
        ZStack(alignment: .top) {
            // Main content
            content
            
            // Top bar with background and logo
            VStack(spacing: 0) {
                // Top bar
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 120)
                    .background(
                        Image("paper_texture_top")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width + 40)
                            .offset(x: -20, y: -20)
                            .shadow(color: .black.opacity(0.3), radius: 5, y: 3)
                    )
                    .overlay(
                        Image("iScout_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 32)
                            .padding(.top, 44)
                            .padding(.leading, 16)
                    )
                    .background(Color.red.opacity(0.3)) // Debug color
                
                // Search bar
                if selectedTab == 0 {
                    searchBar
                        .padding(.top, 8)
                }
                
                Spacer()
            }
            .background(Color.blue.opacity(0.3)) // Debug color
        }
        .ignoresSafeArea()
    }
} 