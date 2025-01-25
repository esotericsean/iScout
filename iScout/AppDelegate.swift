//
//  AppDelegate.swift
//  iScout
//
//  Created by Sean Duran on 1/23/25.
//

import UIKit
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    override init() {
        super.init()
        setupAppearance()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    private func setupAppearance() {
        DispatchQueue.main.async {
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
}
