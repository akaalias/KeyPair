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
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 64, height: 64)
                .background(RoundedRectangle(cornerRadius: 8)
                    .fill(Color("KeyColor")))
            
            Text(self.key)
                .foregroundColor(Color("KeyTextColor"))
        }
        Text(key)
        .transition(.opacity)
        .animation(.easeOut(duration: 0.5))
        .shadow(radius: 10)
    }
    
    func isSpecialKey() -> Bool {
        if ["⌘","⇧","⌃","⌥"].contains(String(self.key)) {
            return true
        }
        return false
    }
}
