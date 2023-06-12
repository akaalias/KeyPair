//
//  LogSettingsView.swift
//  KeyPair
//
//  Created by Alexis Rondeau on 11.06.23.
//

import SwiftUI

struct LogSettingsView: View {
    @ObservedObject var state = AppState.shared
    
    var body: some View {
        VStack {
            
            Toggle("Log Key Combinations Only", isOn: state.$keyCombinationsOnly)
            
            Spacer()
            
            HStack {
                Spacer()

                Text("\(state.lines.count) lines logged")

                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(state.logAsString(), forType: .string)
                } label: {
                    Text("Copy")
                }
                .buttonStyle(.borderedProminent)

                Button {
                    state.lines = []
                } label: {
                    Text("Clear Log")
                }
                                
                Spacer()
            }
            
            Spacer()

        }
        .padding()
    }
}

struct LogSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LogSettingsView()
    }
}
