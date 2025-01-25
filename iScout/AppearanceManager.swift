import UIKit

enum AppearanceManager {
    static let accentColor = UIColor(red: 240/255, green: 90/255, blue: 40/255, alpha: 1)  // Adjust these values to match your logo
    static let unselectedColor = UIColor.systemGray3  // Light grey for unselected items
    
    static func setupTabBarAppearance() {
        guard let tabBarBackground = UIImage(named: "paper_texture_bottom") else { return }
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        
        // Safe way to get screen width
        let screenWidth = UIScreen.main.bounds.width
        let targetHeight = tabBarBackground.size.height * 1.6
        
        let targetSize = CGSize(width: screenWidth, height: targetHeight)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let imageWithShadow = renderer.image { context in
            context.cgContext.setShadow(
                offset: CGSize(width: 0, height: -3),
                blur: 5,
                color: UIColor.black.withAlphaComponent(0.3).cgColor
            )
            
            tabBarBackground.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        tabBarAppearance.backgroundImage = imageWithShadow
        tabBarAppearance.shadowImage = nil
        tabBarAppearance.shadowColor = nil
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = unselectedColor
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]
        
        itemAppearance.selected.iconColor = accentColor
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: accentColor]
        
        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        tabBarAppearance.inlineLayoutAppearance = itemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().isTranslucent = false
    }
}
