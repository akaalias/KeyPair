//
//  LogExportsView.swift
//  KeyPair
//
//  Created by Alexis Rondeau on 13.06.23.
//

import SwiftUI

struct LogExportsView: View {
    @ObservedObject var state = AppState.shared
    @State var lastLog = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(state.lines.count) events logged")
                    .font(.title2)
                    .transition(.opacity)
                    .animation(.easeInOut)
                
                Spacer()
                
                Button {
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(state.logAsString(), forType: .string)
                } label: {
                    Text("Copy to Clipboard")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    state.lines = []
                } label: {
                    Text("Clear Log")
                }
            }
            .padding(8)
            
            
            HStack {
                Text(lastLog)
                    .transition(.opacity)
                    .animation(.easeInOut)
                Spacer()
            }
            .onChange(of: state.lines.last ?? "") { newValue in
                self.lastLog = newValue
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.leading)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor.opacity(0.4)))
            
            
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.accentColor.opacity(0.2)))
        
    }
}

struct LogExportsView_Previews: PreviewProvider {
    static var previews: some View {
        LogExportsView()
    }
}
