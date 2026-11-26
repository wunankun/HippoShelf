<p align="center">
  <img src="docs/icon.png" width="120" alt="HippoShelf icon: a black cartoon hippo">
</p>

<h1 align="center">HippoShelf</h1>

<p align="center">Drag a file and a hippo leans out from the right edge of your screen, mouth open, ready to hold it for you.</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13.0%2B-000000?logo=apple&logoColor=white" alt="macOS 13+">
  <img src="https://img.shields.io/badge/Swift-5.9-F05138?logo=swift&logoColor=white" alt="Swift 5.9">
  <img src="https://img.shields.io/badge/Universal-arm64%20%7C%20x86__64-2F81F7" alt="Universal binary">
  <img src="https://img.shields.io/badge/privacy-local%20only-3FB950" alt="100% local">
  <img src="https://img.shields.io/badge/network-none-3FB950" alt="No network">
  <img src="https://img.shields.io/badge/telemetry-none-3FB950" alt="No telemetry">
  <img src="https://img.shields.io/badge/price-free-3FB950" alt="Free">
  <img src="https://img.shields.io/github/license/wunankun/HippoShelf?color=3FB950" alt="MIT">
  <a href="https://github.com/wunankun/HippoShelf/stargazers"><img src="https://img.shields.io/github/stars/wunankun/HippoShelf?style=social" alt="GitHub stars"></a>
</p>

<p align="center"><b>Free forever</b> · No in-app purchases · No subscription · No ads · No account</p>

<p align="center">
  <a href="README.md">简体中文</a> · <b>English</b> · <a href="README.es.md">Español</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="LICENSE">MIT</a>
</p>

<p align="center">
  <img src="docs/cartoon.png" width="170" alt="Cartoon skin: black hippo holding two files">
  &nbsp;&nbsp;
  <img src="docs/glass.png" width="180" alt="Simple skin: frosted glass card with a drop hint">
</p>
<p align="center"><sub>Left: Cartoon skin · Right: Simple skin</sub></p>

> **Free and open source — no ads, no in-app purchases. If it saves you a trip to the desktop, a ⭐ Star is the best support.**

## What it is

A "park it here for a second" shelf for macOS. Start dragging any file and it slides in from the right edge of the screen; drop files into the hippo's mouth to keep them for a while. Drag them out when you need them — and when the mouth is empty, it hides itself again.

It doesn't take over your files or try to manage them. It just gives "the few files I'll need in a minute" a temporary, visible place. For example:

- **Sending files** (WeChat, Mail, Slack): collect them in the mouth, then drag them all into the chat at once
- **Design / writing**: park screenshots as you take them, drop them into Figma or your doc later
- **Tidying up**: stage files picked from different folders, then drag them to the destination in one go

## Features

- 🐡 **Drag to summon**: start dragging any file and it slides in from the right edge
- 👄 **Drop to keep**: drop on the hippo's face; duplicates are skipped automatically
- 📚 **A shelf, not a manager**: one file per row, thumbnail + name; the mouth grows taller with more files, no scrolling
- 🫥 **Hides when empty**: clears itself and slides back to the screen edge
- 🖱 **Take it back**: dragging out copies the file (the original stays); click to select, Space for Quick Look, double-click to open
- 🎯 **Multi-select**: ⌘-click, ⇧-click, or drag a marquee on empty space; drag the whole selection out
- 🎨 **Two skins**: Cartoon (black hippo) / Simple (macOS frosted glass), switch from the menu bar
- 📍 **Park it anywhere**: drag the top bar to move the shelf; it remembers where
- 🧠 **Small touches**: blinking, ear wiggles, pupils follow the mouse (cartoon skin)
- 💸 **Completely free**: no in-app purchases, no subscription, no ads, no account
- 🔒 **Fully local**: no network, no telemetry

## Privacy

**The most important design decision of this project: it never goes online — and it is free.**

- **No network code**: no `URLSession`, no analytics, no crash reporting, no accounts
- **No uploads**: only file *paths* are kept in memory; quitting the app clears the list
- **Doesn't touch your files**: dragging out **copies**; the original is never deleted, moved or renamed
- **Open source**: all the logic lives in three Swift files — audit it line by line
- **Zero third-party dependencies**: only Apple's AppKit, no package manager, no binary blobs
- **No charges**: no in-app purchases, subscriptions or ads; the project never asks you to sign up

In one sentence: it parks paths, never contents, and never phones home.

## Install

### Requirements

- macOS 13 or later (Intel and Apple silicon both supported)
- **Xcode Command Line Tools** (a few hundred MB)

> ⚠️ **Not preinstalled on every Mac.** A fresh macOS has no `swiftc` and no full `git`; install the Command Line Tools first. You do *not* need the full Xcode (several GB).

### Build in three steps

```bash
# 1) Install the command line tools (once; click "Install" in the dialog)
xcode-select --install

# 2) Verify the install (prints /Library/Developer/CommandLineTools or the Xcode path)
xcode-select -p

# 3) Clone, build, run
git clone https://github.com/wunankun/HippoShelf.git
cd HippoShelf
./build.sh
open HippoShelf.app
```

Tips:

- `git` itself ships with the Command Line Tools. If `git clone` prompts you to install them, finish step 1 and retry.
- Nothing except the clone touches the network; `build.sh` compiles locally and produces `HippoShelf.app`.
- `build.sh` compiles arm64 and x86_64 with `swiftc`, merges them with `lipo`, then copies `Info.plist` and the icon.

### First launch

- Don't double-click the first time: **right-click → Open → Open** (locally signed, not notarized)
- If macOS says it's damaged, run:
  ```bash
  xattr -dr com.apple.quarantine /Applications/HippoShelf.app
  ```
- No Dock icon — the hippo lives in the menu bar, that's normal
- macOS will ask for permission the first time you drop files from Desktop / Documents / Downloads
- Launch at login: System Settings → General → Login Items

## Usage

- Drag any file → the hippo slides out → drop it into the mouth
- Click to select, Space for Quick Look, double-click to open; ⌘ / ⇧ / marquee for multi-select
- Drag selected files out of the mouth to **copy** them (originals stay) and remove them from the shelf
- The red bird on the right ear clears the shelf; it hides itself when empty
- Drag the top bar to move the shelf; the position is remembered (⌘S shows it again)
- Menu bar: show/hide, clear, cartoon/glass skin, quit

## FAQ

**Q: Does every Mac come with Xcode Command Line Tools?**
A: No. A fresh macOS has no `swiftc`; run `xcode-select --install` (a few hundred MB) before the first build. Full Xcode is not required.

**Q: What happens when I add many files?**
A: The mouth keeps growing and never scrolls. Clear it if it runs out of screen.

**Q: Will it delete my files?**
A: No. The shelf stores paths only; dragging out copies; quitting just clears the list.

**Q: Does it upload my files?**
A: No. There is no network code at all — search the source for `URLSession`.

**Q: Multiple displays and spaces?**
A: Yes. It follows the screen you drop it on and remembers its position.

**Q: Can I use it commercially?**
A: Yes, under MIT — keep the copyright notice.

**Q: Why a hippo?**
A: Big mouth.

## Project structure

```
Sources/
  ShelfStore.swift   the shelf's file list (in memory only)
  HippoPanel.swift   hippo face drawing, window, tiles, drag & drop
  main.swift         app entry, menu bar, drag monitoring
Resources/           app icon
docs/                README screenshots
build.sh             builds the universal binary (arm64 + x86_64)
Info.plist           app metadata (LSUIElement: no Dock icon)
```

## Contributing

- Found it useful → ⭐ Star (it really helps)
- Bug or feature idea → open an Issue
- Code → PRs welcome; run `./build.sh` before opening one to make sure the universal build still works

The icon was generated with an AI tool and edited by the author, released under MIT with the project.

## License

[MIT](LICENSE) © 2026 wunankun
