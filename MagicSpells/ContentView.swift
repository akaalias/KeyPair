//
//  ContentView.swift
//  KeyPair
//
//  Created by Alexis Rondeau on 11.06.23.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var state = AppState.shared
    @State var keys: [String.SubSequence] = []
    @State private var showingNotice = true
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if showingNotice {
                ForEach(self.keys, id: \.self) { key in
                    KeyView(key: key)
                }
            }
            
            if state.requiresAccessibility {
                VStack(alignment: .leading) {
                    Text("Welcome to KeyPair!")
                        .font(.title)
                    Text("Please update Accessiblity: ")
                        .multilineTextAlignment(.leading)
                        .font(.title2)
                    
                    Text("1. Open System Settings > Security & Privacy > Accessibility")
                    Text("2. Click on '+' and add Applications > KeyPair")
                    Text("3. Restart KeyPair")
                    
                    Link("Watch the Accessiblity Settings How-To Video Here", destination: URL(string: "https://github.com/akaalias/KeyPair/tree/main#accessibility-settings")!)
                        .tint(.orange)
                        .foregroundColor(.orange)

                }
                .padding()
            }
        }
        .animation(.easeInOut(duration: 1))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TranslucentVisualEffectView())
        .toolbar {
            Spacer()
            Image(systemName: state.isPinned ? "circlebadge.fill" : "circlebadge")
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 8)
                .foregroundColor(Color("KeyTextColor").opacity(0.5))
                .onTapGesture {
                    state.isPinned.toggle()
                }
                .offset(y: -8)
        }
        .onChange(of: state.keyOutput) { newValue in
            if newValue == "" {
                showingNotice = false
            } else {
                self.keys = newValue.split(separator: " ")
                showingNotice = true
            }
        }
        .onChange(of: state.isPinned) { newValue in
            if let window = NSApplication.shared.windows.first {
                if state.isPinned {
                    window.level = NSWindow.Level.screenSaver
                } else {
                    window.level = NSWindow.Level.normal
                }
            }
        }
    }
}
