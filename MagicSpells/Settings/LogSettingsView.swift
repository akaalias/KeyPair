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
            HStack {
                Button {
                    state.log = ""
                } label: {
                    Text("Clear Log")
                }
                
                Spacer()
                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(state.log, forType: .string)
                } label: {
                    Text("Copy")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

struct LogSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LogSettingsView()
    }
}
