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
  <a href="https://github.com/wunankun/HippoShelf/releases/latest"><img src="https://img.shields.io/github/v/release/wunankun/HippoShelf?label=download&color=2F81F7" alt="Download"></a>
  <img src="https://img.shields.io/github/license/wunankun/HippoShelf?color=3FB950" alt="MIT">
  <a href="https://github.com/wunankun/HippoShelf/stargazers"><img src="https://img.shields.io/github/stars/wunankun/HippoShelf?style=social" alt="GitHub stars"></a>
</p>

<p align="center"><b>Free forever</b> · No in-app purchases · No subscription · No ads · No account</p>

<p align="center"><a href="https://github.com/wunankun/HippoShelf/releases/latest"><b>⬇ Download 1.9 (universal, ~1.9 MB)</b></a></p>

<p align="center">
  <a href="README.md">简体中文</a> · <b>English</b> · <a href="README.es.md">Español</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="LICENSE">MIT</a>
</p>

<p align="center">
  <img src="docs/cartoon.gif" width="170" alt="Cartoon skin: the black hippo takes three files, then empties">
  &nbsp;&nbsp;
  <img src="docs/glass.gif" width="170" alt="Simple skin: frosted glass card grows as files arrive">
</p>
<p align="center"><sub>Left: Cartoon skin · Right: Simple skin (screen recordings)</sub></p>

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
- ⚙️ **Settings window**: ⌘, to switch language, launch at login, or check for updates
- 🌐 **5 languages**: English / 简体中文 / Español / 日本語 / 한국어, switchable anytime
- 🔄 **Check for updates**: one click asks GitHub for the latest version and takes you to the download
- 💸 **Completely free**: no in-app purchases, no subscription, no ads, no account
- 🔒 **Local by default**: no uploads, no accounts, no telemetry; it only goes online when *you* click "Check for updates"

## Privacy

**The most important design decision of this project: local by default — and free.**

- **No network by default**: no cloud, no analytics, no crash reporting, no accounts
- **"Check for updates" is the only online call**: it runs only when you click it, asks GitHub's public API for the latest release tag, and never sends your files, paths or device details. Skip it and the app is fully offline — everything still works
- **No uploads**: only file *paths* are kept in memory; quitting the app clears the list
- **Doesn't touch your files**: dragging out **copies**; the original is never deleted, moved or renamed
- **Open source**: all the logic lives in six Swift files — audit it line by line
- **Zero third-party dependencies**: only Apple's AppKit, no package manager, no binary blobs
- **No charges**: no in-app purchases, subscriptions or ads; the project never asks you to sign up

In one sentence: it parks paths, never contents — and the only time it goes online is the update check you trigger yourself.

## Install

### Option 1: Download (recommended)

Get `HippoShelf-1.9-universal.zip` from [Releases](https://github.com/wunankun/HippoShelf/releases/latest) (~1.9 MB, universal for Intel and Apple silicon), unzip it, and drag `HippoShelf.app` into Applications.

- **First launch:** right-click the app → Open → Open again (locally signed, not notarized).
- If macOS says the app is damaged:
  ```bash
  xattr -dr com.apple.quarantine /Applications/HippoShelf.app
  ```
- Optional checksum: compare `shasum -a 256 HippoShelf-1.9-universal.zip` with the `.sha256` file on the release page.

> Every release is built from source by GitHub Actions ([release.yml](.github/workflows/release.yml)) and ships with a `.sha256` checksum.

### Option 2: Build from source

> Already have Command Line Tools? Skip to Step 3.

**Step 1: Check your environment** (paste into Terminal)

```bash
sw_vers -productVersion   # need 13.0 or newer
xcode-select -p           # a path = tools installed
swiftc --version          # a version = compiler works
git --version             # a version = git works
```

**Step 2: Install only what is missing**

| What you see | What to do |
| --- | --- |
| `xcode-select -p` errors with `unable to get active developer directory` | Run `xcode-select --install`, click Install, wait 5–15 min |
| No dialog appears / download stuck | Check System Settings → General → Software Update, or download manually from https://developer.apple.com/download/all/ (free Apple ID) |
| Still errors after installing | Run `sudo xcode-select -s /Library/Developer/CommandLineTools`, then check again |
| `swiftc` asks about the license | Run `sudo xcodebuild -license accept` |
| macOS is older than 13 | Upgrade macOS, or use another Mac (13+ required) |
| No admin rights (work Mac) | Ask IT to install them, or use the prebuilt download above |

**Step 3: Build**

```bash
git clone https://github.com/wunankun/HippoShelf.git
cd HippoShelf
./build.sh
open HippoShelf.app
```

> Full Xcode (several GB) is not needed — Command Line Tools are enough. `build.sh` compiles arm64 and x86_64, then `lipo`s them into one universal app.

### First launch

- Don't double-click the first time: **right-click → Open → Open** (locally signed, not notarized)
- If macOS says it's damaged, run:
  ```bash
  xattr -dr com.apple.quarantine /Applications/HippoShelf.app
  ```
- No Dock icon — the hippo lives in the menu bar, that's normal
- macOS will ask for permission the first time you drop files from Desktop / Documents / Downloads
- Launch at login: menu bar hippo → Settings → turn on "Launch at login" (or add it in System Settings → General → Login Items)

## Usage

- Drag any file → the hippo slides out → drop it into the mouth
- Click to select, Space for Quick Look, double-click to open; ⌘ / ⇧ / marquee for multi-select
- Drag selected files out of the mouth to **copy** them (originals stay) and remove them from the shelf
- The red bird on the right ear clears the shelf; it hides itself when empty
- Drag the top bar to move the shelf; the position is remembered (⌘S shows it again)
- Menu bar: show/hide, clear, cartoon/glass skin, Settings (⌘,), quit
- Settings holds language, launch at login and update check

## FAQ

**Q: Does every Mac come with Xcode Command Line Tools?**
A: No. Run `xcode-select -p` first: if it prints a path, you are ready. Only if it errors do you need `xcode-select --install` (a few hundred MB). Full Xcode is not required.

**Q: What happens when I add many files?**
A: The mouth keeps growing and never scrolls. Clear it if it runs out of screen.

**Q: Will it delete my files?**
A: No. The shelf stores paths only; dragging out copies; quitting just clears the list.

**Q: Does it upload my files?**
A: No. By default the app makes no network requests. The only online call is "Check for updates", which asks GitHub for a version number when you click it — see `UpdateChecker.swift`.

**Q: Multiple displays and spaces?**
A: Yes. It follows the screen you drop it on and remembers its position.

**Q: Can I use it commercially?**
A: Yes, under MIT — keep the copyright notice.

**Q: Why a hippo?**
A: Big mouth.

## Project structure

```
Sources/
  ShelfStore.swift    the shelf's file list (in memory only)
  HippoPanel.swift    hippo face drawing, window, tiles, drag & drop
  L10n.swift          UI strings in five languages
  SettingsWindow.swift settings window (language / launch at login / updates)
  UpdateChecker.swift  GitHub release version check
  main.swift          app entry, menu bar, drag monitoring
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
