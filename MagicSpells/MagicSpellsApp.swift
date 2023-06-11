//
//  ContentView.swift
//  MagicSpells
//
//  Created by Alexis Rondeau on 04.06.23.
//

import SwiftUI
import Sparkle

@main
struct MagicSpellsApp: App {
    private let updaterController: SPUStandardUpdaterController
    
    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true,
                                                         updaterDelegate: nil, userDriverDelegate: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 400, minHeight: 100)
                .ignoresSafeArea()
        }
        
        Settings {
            TabView {
                UpdaterSettingsView(updater: updaterController.updater)
                    .tabItem {
                        Label("Updates", systemImage: "arrow.clockwise")
                    }
                LogSettingsView()
                    .tabItem {
                        Label("Log", systemImage: "text.line.last.and.arrowtriangle.forward")
                    }
            }
            .padding()
            .frame(width: 400, height: 200)
        }
    }
}
