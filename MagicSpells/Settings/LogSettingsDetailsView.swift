//
//  LogSettingsDetailsView.swift
//  KeyPair
//
//  Created by Alexis Rondeau on 13.06.23.
//

import SwiftUI

struct LogSettingsDetailsView: View {
    @ObservedObject var state = AppState.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Toggle("Log Control Key Combinations Only", isOn: state.$logControlKeyCombinationsOnly)
                Text("When enabled, will log only control keys and keyboard shortcuts but not what you write alphanumerically. **Restart KeyPair to apply changes.**")
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    .opacity(0.8)
            }
            .frame(height: 80)
            .padding(8)
            
            VStack(alignment: .leading) {
                Toggle("Log Context Switches", isOn: state.$logContextSwitches)
                Text("When enabled, will log when you start or switch applications and when your computer goes to sleep and wakes up etc. **Restart KeyPair to apply changes.**")
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    .opacity(0.8)

            }
            .frame(height: 80)
            .padding(8)
        }
    }
}

struct LogSettingsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LogSettingsDetailsView()
    }
}
