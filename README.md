# KeyPair makes using keyboard shortcuts during pair programming sessions easier

[🎁 Download KeyPair!](https://github.com/akaalias/keypair/releases/latest/download/KeyPair.dmg)

## The problem with hotkeys and pair programming
The problem I've had is that when one person is the “driver” in a pair programming session and the other is the ‘navigator’, when the driver uses keyboard shortcuts (while using the IDE for example) things start happening on the screen for the ‘navigator’ but it’s unclear why (because the navigator is looking at the screen, not the driver’s hands)

So, the app I made is a small window that shows when the driver uses any keyboard shortcuts that are triggered with the command, option, control, shift and function keys. 

From simple things like Command-C/Command-V for copy and paste to complex commands like Command-shift-enter for code refactoring in IntelliJ. 

[🎁 Download KeyPair!](https://github.com/akaalias/keypair/releases/latest/download/KeyPair.dmg)

## Reference and License
- The main global key monitor that works with Accessibility _and_ keeping the Sandbox intact for notarization by Apple was developed by @karaggeorge in their [key-cast](https://github.com/karaggeorge/macos-key-cast/blob/master/Sources/key-cast/KeyCast.swift) project. As their project is MIT licensed (and their code does the heavy-lifting here), this project is also MIT licensed and public.

## Tasks

- [x] Basic hotkey display
- [x] Top-top-level floating (.screensaver)
- [x] Optional pinning
- [x] Adjust fidelity and snappiness
- [ ] Better documentation on Accessibility Settings
- [ ] Automatic updates (How does that affect Accessibility?)
- [ ] ...?
