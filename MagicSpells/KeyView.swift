//
//  KeyView.swift
//  KeyPair
//
//  Created by Alexis Rondeau on 11.06.23.
//

import SwiftUI

struct KeyView: View {
    let key: String.SubSequence
    
    
    var body: some View {
        if isControlKey() {
            if String(self.key) == "⌘" {
                ZStack {
                    Text(key)
                        .font(.title2)
                        .foregroundColor(Color("KeyTextColor"))
                        .offset(x: 20, y: -16)

                    Text(controlKeyLabel())
                        .multilineTextAlignment(.trailing)
                        .font(.body)
                        .foregroundColor(Color("KeyTextColor"))
                        .offset(x: 0, y: 16)
                }
                .frame(width: 80, height: 64)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color("KeyColor")))
                .shadow(radius: 10)

            } else if String(self.key) == "⇧" {

                ZStack {
                    Text(key)
                        .font(.title2)
                        .foregroundColor(Color("KeyTextColor"))
                        .offset(x: -20, y: 16)
                }
                .frame(width: 80, height: 64)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color("KeyColor")))
                .shadow(radius: 10)
                
            } else {
                ZStack {
                    Text(key)
                        .font(.title2)
                        .foregroundColor(Color("KeyTextColor"))
                        .offset(x: 12, y: -16)

                    Text(controlKeyLabel())
                        .multilineTextAlignment(.trailing)
                        .font(.body)
                        .foregroundColor(Color("KeyTextColor"))
                        .offset(x: 0, y: 16)
                }
                .frame(width: 64, height: 64)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color("KeyColor")))
                .shadow(radius: 10)
            }
            
        } else {
            Text(self.keyDisplayString())
                .font(.title)
                .padding(16)
                .foregroundColor(Color("KeyTextColor"))
                .frame(width: 64, height: 64)
                .background(RoundedRectangle(cornerRadius: 8)
                    .fill(Color("KeyColor")))
                .transition(.opacity)
                .animation(.easeOut(duration: 0.5))
                .shadow(radius: 10)
        }
    }
    
    func isControlKey() -> Bool {
        if controlKeys.contains(String(self.key)) {
            return true
        }
        return false
    }
    
    func controlKeyLabel() -> String {
        if self.key == "⌘" { return "command" }
        if self.key == "⌥" { return "option" }
        if self.key == "⌃" { return "control" }
        if self.key == "⇧" { return "" }
        
        return ""
    }
    
    func keyDisplayString() -> String {
        return self.key.uppercased()
    }
}
