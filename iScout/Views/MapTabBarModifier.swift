import SwiftUI

struct MapTabBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Image("paper_texture_bottom")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .shadow(color: .black.opacity(0.3), radius: 5, y: -3)
                    .allowsHitTesting(false)
                    , alignment: .bottom
            )
    }
}

extension View {
    func mapTabBarStyle() -> some View {
        self.modifier(MapTabBarModifier())
    }
} 