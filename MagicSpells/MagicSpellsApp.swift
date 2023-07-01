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
        Window("KeyPair", id: "KeyPair") {
            ContentView()
                .frame(minWidth: 400, minHeight: 100)
                .ignoresSafeArea()
        }
        
        Settings {
            TabView {
                LogSettingsView()
                    .tabItem {
                        Label("Log", systemImage: "text.line.last.and.arrowtriangle.forward")
                    }
                UpdaterSettingsView(updater: updaterController.updater)
                    .tabItem {
                        Label("Updates", systemImage: "arrow.clockwise")
                    }
                AboutSettingsView()
                    .tabItem {
                        Label("About", systemImage: "hand.wave")
                    }

            }
            .padding()
            .frame(width: 600, height: 500)
        }
    }
}
