import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: Int
    let content: AnyView
    let searchBar: AnyView
    
    var body: some View {
        ZStack(alignment: .top) {
            content
            
            if selectedTab == 0 {  // Only show search bar on Map tab
                searchBar
            }
        }
    }
} 
