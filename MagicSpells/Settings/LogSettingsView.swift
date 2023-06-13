//
//  LogSettingsView.swift
//  KeyPair
//
//  Created by Alexis Rondeau on 11.06.23.
//

import SwiftUI

struct LogSettingsView: View {
    @ObservedObject var state = AppState.shared
    @State var showLogSettingsDetailsView = false
    
    var body: some View {
        VStack(alignment: .leading) {

            Toggle("Log Anything At All", isOn: state.$logAnything)
            Text("When enabled, will capture a local-only, in-memory timestamped log your keyboard input and context switches. You can customize what it logs, too.\n\nWhy? This is part of a personal experiment where I feed the log to ChatGPT to gain deeper insights into my day-to-day work.")
                .font(.body)
                .opacity(0.8)

            if showLogSettingsDetailsView {
                LogSettingsDetailsView()
            }
            
            LogExportsView()

            Spacer()
        }
        .padding()
        .onAppear() {
            self.showLogSettingsDetailsView = state.logAnything
        }
        .onChange(of: state.logAnything) { newValue in
            showLogSettingsDetailsView = newValue
        }
    }
}

struct LogSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LogSettingsView()
    }
}
