//
//  iScoutApp.swift
//  iScout
//
//  Created by Sean Duran on 1/21/25.
//

import SwiftUI

@main
struct iScoutApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
