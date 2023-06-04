//
//  ContentView.swift
//  MagicSpells
//
//  Created by Alexis Rondeau on 04.06.23.
//

import SwiftUI

@main
struct MagicSpellsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .ignoresSafeArea()
        }
    }
}

struct KeyView: View {
    let key: String.SubSequence
    var body: some View {
        Text(key)
            .font(.title)
            .padding(16)
            .foregroundColor(.white)
            .frame(width: 64, height: 64)
            .background(RoundedRectangle(cornerRadius: 8)
                .fill(.black))
            .transition(.opacity)
            .animation(.easeOut)
            .shadow(radius: 10)
    }
    
    func isSpecialKey() -> Bool {
        if String(self.key) == "⌘" {
            return true
        }
        
        return false
    }
}

struct ContentView: View {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var state = AppState.shared
    @State var keys: [String.SubSequence] = []
    @State private var showingNotice = true

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if showingNotice {
                ForEach(self.keys, id: \.self) { key in
                    KeyView(key: key)
                }
            }
            
            if state.requiresAccessibility {
                VStack {
                    Text("Please Enable Accessibility for KeyPair")
                        .font(.title)
                    
                    Text("System Settings > Security & Privacy > Accesibiity > Add KeyPair > Restart KeyPair.app")
                }
            }
        }
        .animation(.easeInOut(duration: 1))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TranslucentVisualEffectView())
        .onChange(of: state.keyOutput) { newValue in
            if newValue == "" {
                showingNotice = false
            } else {
                self.keys = newValue.split(separator: " ")
                showingNotice = true
            }
        }
    }
}

class AppState: ObservableObject, Equatable {
    static let shared = AppState()
    @Published var requiresAccessibility = true
    @Published var keyOutput = ""
    
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.keyOutput == rhs.keyOutput
    }
}

/// Original implementation from https://github.com/karaggeorge/macos-key-cast/blob/master/Sources/key-cast/KeyCast.swift
class AppDelegate: NSObject, NSApplicationDelegate {
    let state = AppState.shared
    var eventTap: CFMachPort?
    weak var timer: Timer?
    let delay: Double = 2.0
    let keyCombinationsOnly: Bool = true
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if !AXIsProcessTrustedWithOptions(["AXTrustedCheckOptionPrompt": true] as CFDictionary) {
            print("Accessibility Required")
            state.requiresAccessibility = true
        } else {
            state.requiresAccessibility = false
            listenToGlobalKeyboardEvents()
        }
        
        if let window = NSApplication.shared.windows.first {
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
            
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.closeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            
            window.isMovableByWindowBackground = true
            window.level = NSWindow.Level.floating
            // window.styleMask.remove(.resizable)
        }
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {}
    func applicationDidResignActive(_ notification: Notification) {}
    
    func listenToGlobalKeyboardEvents() {
        DispatchQueue.global(qos: .userInteractive).async {
            let eventMask = [CGEventType.keyDown, CGEventType.keyUp, CGEventType.flagsChanged].reduce(CGEventMask(0), { $0 | (1 << $1.rawValue) })
            
            self.eventTap = CGEvent.tapCreate(
                tap: .cgSessionEventTap,
                place: .headInsertEventTap,
                options: .defaultTap,
                eventsOfInterest: eventMask,
                callback: { (_, _, event, delegate_) -> Unmanaged<CGEvent>? in
                    let this = Unmanaged<AppDelegate>.fromOpaque(delegate_!).takeUnretainedValue()
                    return this.keyboardHandler(event)
                },
                userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            )
            
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, self.eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: self.eventTap!, enable: true)
            CFRunLoopRun()
        }
    }
    
    func keyboardHandler(_ cgEvent: CGEvent) -> Unmanaged<CGEvent>? {
        if cgEvent.type == .keyDown || cgEvent.type == .keyUp || cgEvent.type == .flagsChanged {
            if let event = NSEvent(cgEvent: cgEvent) {
                let keyDown = event.type == .keyDown
                let flagsChanged = event.type == .flagsChanged
                
                if flagsChanged && timer == nil {
                    var isCommand = false
                    var needsShift = false
                    var text = ""
                    if event.modifierFlags.contains(.control) {
                        isCommand = true
                        text += " ⌃"
                    }
                    if event.modifierFlags.contains(.option) {
                        isCommand = true
                        text += " ⌥"
                    }
                    if event.modifierFlags.contains(.shift) {
                        if isCommand {
                            text += " ⇧"
                        } else {
                            needsShift = true
                        }
                    }
                    if event.modifierFlags.contains(.command) {
                        if needsShift {
                            text += " ⇧"
                        }
                        text += " ⌘"
                    }
                    
                    DispatchQueue.main.async {
                        self.updateText(text, onlyMeta: true)
                        // print(text)
                    }
                } else if keyDown {
                    DispatchQueue.main.async {
                        self.updateText(getKeyPressText(event, keyCombinationsOnly: self.keyCombinationsOnly))
                    }
                }
            }
        } else if cgEvent.type == .tapDisabledByUserInput || cgEvent.type == .tapDisabledByTimeout {
            CGEvent.tapEnable(tap: eventTap!, enable: true)
        }
        
        // The focused app will receive the event.
        return Unmanaged.passRetained(cgEvent)
    }
    
    func queueClear() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.timer?.invalidate()
            self?.timer = nil
            self?.updateText("")
        }
    }
    
    func updateText(_ untrimmed: String, onlyMeta: Bool = false) {
        let string = untrimmed.trimmingCharacters(in: .whitespacesAndNewlines)
        
        state.keyOutput = string
        
        if string.count == 0 {
            if timer == nil {
                // window.orderOut(self)
            }
            return
        } else if onlyMeta {
            timer?.invalidate()
            timer = nil
        } else {
            queueClear()
        }
    }
}

import Cocoa
import Carbon.HIToolbox.Events

private let shiftedSpecialKeys = [
    48: "⇤",
    50: "~",
    27: "_",
    24: "+",
    33: "{",
    30: "}",
    41: ":",
    39: "\"",
    43: "<",
    47: ">",
    44: "?",
    42: "|",
    29: ")",
    18: "!",
    19: "@",
    20: "#",
    21: "$",
    23: "%",
    22: "^",
    26: "&",
    28: "*",
    25: "(",
    0: "A",
    11: "B",
    8: "C",
    2: "D",
    14: "E",
    3: "F",
    5: "G",
    4: "H",
    34: "I",
    38: "J",
    40: "K",
    37: "L",
    46: "M",
    45: "N",
    31: "O",
    35: "P",
    12: "Q",
    15: "R",
    1: "S",
    17: "T",
    32: "U",
    9: "V",
    13: "W",
    7: "X",
    16: "Y",
    6: "Z"
]

private let specialKeys = [
    126: "↑",
    125: "↓",
    124: "→",
    123: "←",
    48: "⇥",
    53: "⎋",
    71: "⎋",
    51: "⌫",
    117: "⌦",
    114: "?",
    115: "↖",
    119: "↘",
    116: "⇞",
    121: "⇟",
    36: "↩",
    76: "↩",
    122: "F1",
    120: "F2",
    99: "F3",
    118: "F4",
    96: "F5",
    97: "F6",
    98: "F7",
    100: "F8",
    101: "F9",
    109: "F10",
    103: "F11",
    111: "F12",
    105: "F13",
    107: "F14",
    113: "F15",
    106: "F16",
    49: "␣"
]

func getKeyPressText(_ event: NSEvent, keyCombinationsOnly: Bool) -> String {
    let command = event.modifierFlags.contains(.command)
    let shift = event.modifierFlags.contains(.shift)
    let option = event.modifierFlags.contains(.option)
    let control = event.modifierFlags.contains(.control)
    
    var modifiers: UInt32 = 0
    var keyCode: CGKeyCode?
    
    if let cgEvent = event.cgEvent {
        keyCode = CGKeyCode(cgEvent.getIntegerValueField(.keyboardEventKeycode))
    }
    
    var characterCode = keyCode ?? 0
    var isShifted = false
    var needsShiftGlyph = false
    var isCommand = false
    var text = ""
    
    if control {
        modifiers |= UInt32(NSEvent.ModifierFlags.control.rawValue)
        isCommand = true
        text += " ⌃"
    }
    if option {
        modifiers |= UInt32(NSEvent.ModifierFlags.option.rawValue)
        isCommand = true
        text += " ⌥"
    }
    if shift {
        modifiers |= UInt32(NSEvent.ModifierFlags.shift.rawValue)
        isShifted = true
        if isCommand {
            text += " ⇧"
        } else {
            needsShiftGlyph = true
        }
    }
    if command {
        modifiers |= UInt32(NSEvent.ModifierFlags.command.rawValue)
        if needsShiftGlyph {
            text += " ⇧"
            needsShiftGlyph = false
        }
        isCommand = true
        text += " ⌘"
    }
    
    if let code = keyCode {
        if isShifted && !isCommand {
            let character = shiftedSpecialKeys[Int(code)]
            if character != nil {
                return text + " " + character!
            }
        }
        
        let character = specialKeys[Int(code)]
        if character != nil {
            if needsShiftGlyph {
                text += " ⇧"
            }
            
            return text + " " + character!
        }
    }
    
    // Don't log simple keypresses (no modifiers). Only accelerators.
    if text.count == 0 && keyCombinationsOnly {
        return ""
    }
    
    var buffer: [UniChar] = [0, 0, 0, 0]
    var actualStringLength  = 1
    var deadKeys: UInt32 = 0
    
    let keyboard = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
    let rawLayoutData = TISGetInputSourceProperty(keyboard, kTISPropertyUnicodeKeyLayoutData)
    let layoutData = unsafeBitCast(rawLayoutData, to: CFData.self)
    let layout: UnsafePointer<UCKeyboardLayout> = unsafeBitCast(CFDataGetBytePtr(layoutData), to: UnsafePointer<UCKeyboardLayout>.self)
    let result = UCKeyTranslate(layout, characterCode, UInt16(kUCKeyActionDown), (modifiers >> 8) & 0xff, UInt32(LMGetKbdType()), OptionBits(kUCKeyTranslateNoDeadKeysBit), &deadKeys, 4, &actualStringLength, &buffer)
    
    if result != 0 {
        return ""
    }
    
    characterCode = CGKeyCode(buffer[0])
    text += " " + String(UnicodeScalar(UInt8(characterCode)))
    
    // If this is a command string, put it in uppercase.
    if isCommand {
        return text.uppercased()
    }
    
    return text
}

extension Data {
    func jsonDecoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}

extension String {
    func jsonDecoded<T: Decodable>() throws -> T {
        return try data(using: .utf8)!.jsonDecoded()
    }
}

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

