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
    var appChangedTimer = Timer()
    
    init() {
        self.addNewLogLineWithTimestamp(s: "Started KeyPair")
        self.currentApp = "KeyPair"
        self.shouldAddNewline = true
        
        startObservingWorkspace()
    }
    
    func getTimestamp() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = dateFormatter.string(from: currentDate)
        return "\(timestamp): "
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
        addNewLogLineWithTimestamp(s: "screensDidSleepNotification")
    }
    
    @objc private func screensDidWakeNotification(notification: NSNotification) {
        addNewLogLineWithTimestamp(s: "screensDidWakeNotification")
    }
    
    @objc private func sessionDidResignActiveNotification(notification: NSNotification) {
        addNewLogLineWithTimestamp(s: "sessionDidResignActiveNotification")
    }

    @objc private func sessionDidBecomeActiveNotification(notification: NSNotification) {
        addNewLogLineWithTimestamp(s: "sessionDidBecomeActiveNotification")
    }
    
    @objc private func didActivateApplicationNotification(notification: NSNotification) {
        if let frontmostApp = NSWorkspace.shared.frontmostApplication?.localizedName {
            if self.currentApp != frontmostApp {
                self.addNewLogLineWithTimestamp(s: "Switched from \(self.currentApp) to \(frontmostApp)")
                self.printLog()
                self.currentApp = frontmostApp
            }
        }
    }
    
    func appendToLog(s: String) {
        if s.contains(controlKeys) {
            self.addNewLogLineWithTimestamp(s: s)
            self.shouldAddNewline = true
            return
        }
        self.addToExistingLastLogLine(additionalString: s)
    }

    func printLog() {
        print("------------")
        print(self.logAsString())
        print("------------")
    }
    
    func addNewLogLineWithTimestamp(s: String) {
        self.lines.append("\(self.getTimestamp())\t\(s)")
    }

    func addToExistingLastLogLine(additionalString: String) {
        if shouldAddNewline {
            self.lines.append("\(self.getTimestamp())\t\(additionalString)")
            shouldAddNewline = false
        } else {
            let count = self.lines.count
            let currentLastText = self.lines.last
            
            var replacedString = additionalString
            if additionalString == "␣" {
                replacedString = " "
            }
            
            let newText = currentLastText! + replacedString
            self.lines[count - 1] = newText
            shouldAddNewline = false
        }
    }
        
    func logAsString() -> String {
        return self.lines.joined(separator: "\n")
    }
}
