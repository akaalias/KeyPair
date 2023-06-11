//
//  AppState.swift
//  KeyPair
//
//  Created by Alexis Rondeau on 11.06.23.
//

import Foundation
import SwiftUI

enum SettingsKeys: String, CaseIterable{
    case isPinned = "isPinned"
}

class AppState: ObservableObject, Equatable {
    static let shared = AppState()
    static let DEFAULT_IS_PINNED_STATE = true
    
    @Published var requiresAccessibility = true
    @Published var keyOutput = ""
    @Published var log = ""
    @Published var currentLogLine = ""
    @Published var currentApp = "KeyPair"
    @Published var previousInputIsTextInput = false
    
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.keyOutput == rhs.keyOutput
    }
    
    @AppStorage(SettingsKeys.isPinned.rawValue) var isPinned = AppState.DEFAULT_IS_PINNED_STATE {
        didSet {
            objectWillChange.send()
        }
    }
    var appChangedTimer = Timer()
    
    init() {
        startAppChangedTimer()
    }
    
    func getTimestamp() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = dateFormatter.string(from: currentDate)
        return "\(timestamp): "
    }
    
    func startAppChangedTimer() {
        self.log.append("\(self.getTimestamp())Started KeyPair\n")
        appChangedTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if let frontmostApp = NSWorkspace.shared.frontmostApplication?.localizedName {
                if self.currentApp != frontmostApp {
                    self.log.append("\(self.getTimestamp())Switched from \(self.currentApp) to \(frontmostApp)\n")
                    self.currentApp = frontmostApp
                }
            }
        })
    }
    
    func appendToLog(s: String) {
        if s.contains(controlKeys) {
            if self.previousInputIsTextInput {
                self.log.append("\n\(self.getTimestamp())\(s)\n")
            } else {
                self.log.append("\(self.getTimestamp())\(s)\n")
            }
            self.previousInputIsTextInput = false
            return
        }
        
        if !self.previousInputIsTextInput {
            self.log.append(self.getTimestamp())
        }

        // Else we want to keep the input in the same line
        self.previousInputIsTextInput = true
        
        if s.count == 1 && s.contains(Array(specialKeys.values)) {
            if s == "␣" {
                self.log.append(" ")
                return
            } else {
                self.log.append(s)
                return
            }
        }
        
        if s.contains(Array(specialKeys.values)) {
            self.log.append(s + "\n")
            return
        }
        
        if s.contains(Array(shiftedSpecialKeys.values)) {
            self.log.append(s)
            return
        }
        
        self.log.append(s)
        return
    }
}
