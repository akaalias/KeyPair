//
//  TranslucentVisualEffectView.swift
//  KeyPair
//
//  Created by Alexis Rondeau on 11.06.23.
//

import SwiftUI

struct TranslucentVisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView
    {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .appearanceBased
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
        
    }
    
    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context)
    {
        visualEffectView.material = .appearanceBased
        visualEffectView.blendingMode = .behindWindow
    }
}

