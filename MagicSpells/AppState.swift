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
    case logControlKeyCombinationsOnly = "logControlKeyCombinationsOnly"
    case logContextSwitches = "logContextSwitches"
    case logAnything = "logAnything"
}

class AppState: ObservableObject, Equatable {
    static let shared = AppState()
    static let DEFAULT_IS_PINNED_STATE = true
    
    static let DEFAULT_LOG_CONTROL_KEY_COMBINATIONS_ONLY = true
    static let DEFAULT_LOG_CONTEXT_SWITCHES = true
    static let DEFAULT_LOG_ANYTHING = false
    
    @Published var requiresAccessibility = true
    @Published var keyOutput = ""
    @Published var currentLogLine = ""
    @Published var currentApp = "KeyPair"
    @Published var lines: [String] = []
    
    var shouldAddNewline = false
    
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.keyOutput == rhs.keyOutput
    }
    
    @AppStorage(SettingsKeys.isPinned.rawValue) var isPinned = AppState.DEFAULT_IS_PINNED_STATE {
        didSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage(SettingsKeys.logControlKeyCombinationsOnly.rawValue) var logControlKeyCombinationsOnly = AppState.DEFAULT_LOG_CONTROL_KEY_COMBINATIONS_ONLY {
        didSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage(SettingsKeys.logContextSwitches.rawValue) var logContextSwitches = AppState.DEFAULT_LOG_CONTEXT_SWITCHES {
        didSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage(SettingsKeys.logAnything.rawValue) var logAnything = AppState.DEFAULT_LOG_ANYTHING {
        didSet {
            objectWillChange.send()
        }
    }
    
    init() {
        if self.logAnything {
            self.addNewLogLineWithTimestamp(s: "Started KeyPair", type: "Context Switch")
            self.currentApp = "KeyPair"
            self.shouldAddNewline = true
            if self.logContextSwitches {
                self.startObservingWorkspace()
            }
        }
    }
    
    func getUnixTimestamp() -> Int {
        return Int(NSDate().timeIntervalSince1970)
    }
    
    func startObservingWorkspace() {
            let workspace = NSWorkspace.shared
            
            workspace.notificationCenter.addObserver(self,
                                                     selector: #selector(self.didActivateApplicationNotification),
                                                     name: NSWorkspace.didActivateApplicationNotification,
                                                     object: workspace)
            
            workspace.notificationCenter.addObserver(self,
                                                     selector: #selector(self.sessionDidBecomeActiveNotification),
                                                     name: NSWorkspace.sessionDidBecomeActiveNotification,
                                                     object: workspace)
            
            workspace.notificationCenter.addObserver(self,
                                                     selector: #selector(self.sessionDidResignActiveNotification),
                                                     name: NSWorkspace.sessionDidResignActiveNotification,
                                                     object: workspace)
            
            workspace.notificationCenter.addObserver(self,
                                                     selector: #selector(self.screensDidWakeNotification),
                                                     name: NSWorkspace.screensDidWakeNotification,
                                                     object: workspace)
            
            workspace.notificationCenter.addObserver(self,
                                                     selector: #selector(self.screensDidSleepNotification),
                                                     name: NSWorkspace.screensDidSleepNotification,
                                                     object: workspace)
            
        
    }
    
    @objc private func screensDidSleepNotification(notification: NSNotification) {
        addNewLogLineWithTimestamp(s: "screensDidSleepNotification", type: "Context Switch")
    }
    
    @objc private func screensDidWakeNotification(notification: NSNotification) {
        addNewLogLineWithTimestamp(s: "screensDidWakeNotification", type: "Context Switch")
    }
    
    @objc private func sessionDidResignActiveNotification(notification: NSNotification) {
        addNewLogLineWithTimestamp(s: "sessionDidResignActiveNotification", type: "Context Switch")
    }
    
    @objc private func sessionDidBecomeActiveNotification(notification: NSNotification) {
        addNewLogLineWithTimestamp(s: "sessionDidBecomeActiveNotification", type: "Context Switch")
    }
    
    @objc private func didActivateApplicationNotification(notification: NSNotification) {
        if let frontmostApp = NSWorkspace.shared.frontmostApplication?.localizedName {
            if self.currentApp != frontmostApp {
                self.addNewLogLineWithTimestamp(s: "Switched from \(self.currentApp) to \(frontmostApp)", type: "Context Switch")
                self.printLog()
                self.currentApp = frontmostApp
            }
        }
    }
    
    func appendToLog(s: String) {
        if s.contains(controlKeys) {
            self.addNewLogLineWithTimestamp(s: s, type: "Keyboard Shortcut")
            self.shouldAddNewline = true
            return
        }
        if !self.logControlKeyCombinationsOnly {
            self.addToExistingLastLogLine(additionalString: s)
        }
    }
    
    func printLog() {
        print("------------")
        print(self.logAsString())
        print("------------")
    }
    
    func addNewLogLineWithTimestamp(s: String, type: String) {
        self.lines.append("\(self.getUnixTimestamp())\t\t\(type)\t\t\(s)")
    }
    
    func addToExistingLastLogLine(additionalString: String) {
        if shouldAddNewline {
            self.lines.append("\(self.getUnixTimestamp())\t\tWriting\t\t\(additionalString)")
            shouldAddNewline = false
        } else {
            let count = self.lines.count
            let currentLastText = self.lines.last
            
            var replacedString = additionalString
            if additionalString == "␣" {
                replacedString = " "
            }
            
            if currentLastText != nil {
                let newText = currentLastText! + replacedString
                self.lines[count - 1] = newText
            } else {
                self.lines[count - 1] = replacedString
            }
            shouldAddNewline = false
        }
    }
    
    func logAsString() -> String {
        return self.lines.joined(separator: "\n")
    }
}
