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
        Text(key)
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
    
    func isSpecialKey() -> Bool {
        if String(self.key) == "⌘" {
            return true
        }
        
        return false
    }
}
