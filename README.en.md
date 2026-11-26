# HippoShelf

Drop files into a hippo's mouth.

A tiny temporary shelf for macOS: start dragging any file and a hippo slides in from the right edge of the screen; drop the files into its mouth and it keeps them for you. When the mouth is empty it hides itself again.

<p align="center">
  <a href="README.md">简体中文</a> · English · <a href="README.es.md">Español</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="LICENSE">MIT</a>
</p>

<p align="center">
  <img src="docs/cartoon.png" width="170" alt="Cartoon skin: black hippo face">
  &nbsp;&nbsp;
  <img src="docs/glass.png" width="180" alt="Simple skin: translucent glass card">
</p>

## Why

Screenshots, assets and files waiting to be sent pile up on the desktop. The hippo only appears while you are dragging, so it stays out of the way.

## Features

- **Shows up on drag**: slides in from the right edge when you start dragging any file
- **Open mouth**: drop files on the hippo's face to park them; duplicates are skipped
- **Temporary shelf**: one file per row with thumbnail and name; the mouth grows taller with more files (no scrolling) and hides itself when cleared
- **Take them back**: drag a file out to copy it somewhere else (the original stays); click to select, Space for Quick Look, double-click to open
- **Multi-select**: ⌘-click, ⇧-click, or drag a marquee on empty space; drag the whole selection out
- **Two skins**: Cartoon (black hippo face) / Simple (translucent glass), switchable from the menu bar
- **Move it anywhere**: drag the top of the shelf; it remembers the position
- **Menu bar**: show/hide (⌘S), clear, skin, quit
- **Little touches**: blinking, ear wiggles, pupils following the mouse (cartoon skin)

## Requirements

macOS 13 or later, Intel and Apple Silicon (universal binary).

## Build

Xcode Command Line Tools are required (`xcode-select --install`):

```bash
git clone https://github.com/wunankun/HippoShelf.git
cd HippoShelf
./build.sh
open HippoShelf.app
```

`build.sh` compiles arm64 and x86_64 with `swiftc`, then merges them into a universal binary with `lipo`.

## Usage

Drag `HippoShelf.app` into Applications:

- First launch: right-click the app → Open, then confirm (locally signed, not from the App Store)
- If macOS says the app is damaged: `xattr -dr com.apple.quarantine /Applications/HippoShelf.app`
- There is no Dock icon — only a small hippo in the menu bar
- macOS may ask for access to Desktop / Documents / Downloads on first use; allow it
- Launch at login: System Settings → General → Login Items

## Notes

- The shelf only stores file paths; it never moves, copies or uploads your files. The list is cleared when the app quits
- The mouth keeps growing with no scrolling — clear it if it runs out of screen
- Dragging a file out copies it; the original file is untouched

## License

[MIT](LICENSE) © 2026 wunankun

The app icon was generated with an AI tool and edited by the author.
