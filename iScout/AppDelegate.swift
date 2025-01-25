//
//  AppDelegate.swift
//  iScout
//
//  Created by Sean Duran on 1/23/25.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupAppearance()
        return true
    }
    
    private func setupAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundColor = .clear
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = AppearanceManager.unselectedColor
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: AppearanceManager.unselectedColor]
        itemAppearance.selected.iconColor = AppearanceManager.accentColor
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: AppearanceManager.accentColor]
        
        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        tabBarAppearance.inlineLayoutAppearance = itemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().isTranslucent = true
    }
}
