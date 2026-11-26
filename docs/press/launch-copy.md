# HippoShelf — Launch copy

Ready-to-paste copy for the places that need an account: Product Hunt, Hacker News, Reddit, 小红书, 少数派, V2EX. Adjust the personal bits (your name, screenshots) before posting.

Repo: https://github.com/wunankun/HippoShelf · Download: https://github.com/wunankun/HippoShelf/releases/latest

---

## Product Hunt

**Name:** HippoShelf

**Tagline (60 chars max):** A hippo-shaped drop shelf for your Mac files

**Topics:** Mac, Productivity, Menu Bar, Open Source, Developer Tools

**Description (260 chars max):**

Drag a file and a little hippo slides out from the right edge of your screen. Drop files into its mouth to park them for later, drag them out to copy them back, and it hides when empty. Free, open source, native Swift. No account, no telemetry — local by default.

**First comment:**

Hi Product Hunt! 👋

I built HippoShelf because I kept dragging the same three files — a screenshot, a PDF, an image — between Finder windows every day. Dropover and Yoink solve this well, but I wanted something free, open source, and a bit silly.

So: a hippo. It lives in the menu bar. When you start dragging a file, its head slides out from the right edge. Drop files in its mouth, they stack one per row, and you can drag them out again (it copies, never moves). Empty mouth → it hides.

Two skins (cartoon hippo / frosted glass), five languages, multi-select, Quick Look, launch at login, update check. macOS 13+, universal binary, MIT.

Happy to answer anything — especially "why a hippo?" (big mouth).

**Launch checklist:** add 3 gallery images (cartoon.png, glass.png, cartoon.gif), pick Tuesday–Thursday, reply to every comment in the first 4 hours.

---

## Hacker News — Show HN

**Title:** Show HN: HippoShelf – a hippo-shaped temporary shelf for macOS files

**Text:**

I made a small macOS menu-bar utility called HippoShelf. Start dragging a file and a drawn hippo head slides out from the right edge of the screen; drop files into its mouth to park them temporarily, drag them out to copy them back, and it hides when the mouth is empty.

It is Swift + AppKit (no Electron), universal binary, macOS 13+, MIT. Two skins (cartoon hippo and a frosted-glass card), five UI languages, ⌘/⇧ or marquee multi-select, Space for Quick Look.

The privacy angle: no accounts, no telemetry, no uploads. File paths live in memory only; quitting clears the shelf. The only network call is the optional "Check for updates", which asks GitHub for the latest tag when you click it. The whole app is six Swift files, so it is auditable.

Not notarized yet (ad-hoc signed), so first launch needs right-click → Open. Source and download: https://github.com/wunankun/HippoShelf

I would love feedback on the drag-and-drop edge cases — that part was much harder than the drawing.

---

## Reddit — r/macapps

**Title:** I made a free, open-source hippo that holds your files while you drag them around

**Body:**

Hey r/macapps,

I built a small menu-bar app called **HippoShelf**. It is a temporary shelf for the files you are moving between windows: start dragging, and a hippo head slides out from the right edge of the screen. Drop files into its mouth, they stack one per row; drag them out and they are copied back (originals untouched); when the mouth is empty it hides.

- Free and open source (MIT), native Swift + AppKit, universal binary, macOS 13+
- Two skins: cartoon hippo and a frosted-glass card
- Five languages: English, 简体中文, Español, 日本語, 한국어
- Multi-select with ⌘/⇧ or drag a marquee; Space for Quick Look
- No accounts, no telemetry, no uploads; the only optional network call is the update check
- `brew install --cask wunankun/tap/hipposhelf` or download from GitHub

It is not notarized yet (ad-hoc signed), so first launch is right-click → Open. I am the developer, so happy to answer questions and take feature requests.

GitHub: https://github.com/wunankun/HippoShelf

---

## 小红书

**标题（选一个）：**
- 花 0 块钱做了只河马，帮我接住拖来拖去的文件
- 我的 Mac 右边住了一只河马，专门替我拿文件
- 拖文件的时候，屏幕右边会冒出一只河马

**正文：**

每次写东西，都有几个文件在 Finder 里拖来拖去：截图、PDF、配图。
烦了，就做了个自己的小工具 —— 一只河马。

它住在 Mac 菜单栏。你一开始拖文件，它就从屏幕右边探出头；把文件丢进它嘴里，就帮你暂存着，一行一个。要用的时候再拖出来（是复制，原文件不动），嘴空了它就自己躲回去。

- 免费、开源，Mac / Intel 都能用
- 两种皮肤：卡通河马 / 简约毛玻璃
- 5 种语言，支持多选、空格预览
- 不联网、不传文件、不用登录

GitHub 搜 HippoShelf 就能找到（链接放评论区）。
第一次打开要右键 →「打开」，因为还没做苹果公证。

#Mac #效率工具 #独立开发 #开源 #桌面整理 #AI做的小玩意

**置顶评论：** 项目地址：https://github.com/wunankun/HippoShelf （免费，点个 star 就是最大的支持 🙏）

---

## 少数派（Matrix 投稿 / 文章）

**标题：** 拖文件时，屏幕右边会冒出一只河马：我做了个免费的 Mac 临时置物架

**导语：** 写东西的时候，总有那么几个文件在 Finder 里拖来拖去。我做了一只河马，专门替你把它们含在嘴里，空了就躲起来。

**文章结构：**

1. 起因：每天在 Finder 之间搬同样的几个文件
2. 它是什么：拖文件时从右边滑出的河马头，嘴就是置物架
3. 怎么用：拖入 / 拖出 / 多选 / 清空 / 换皮肤 / 设置
4. 为什么是河马：嘴大（认真）
5. 隐私：不联网、不上传、路径只在内存里；唯一的联网是主动点检查更新
6. 技术：Swift + AppKit，6 个文件，MIT，通用二进制
7. 下载与源码：GitHub Releases；brew 一行安装
8. 已知限制：暂未公证，首次打开需右键

**配图：** docs/cartoon.gif、docs/glass.gif、设置窗口截图。

---

## V2EX（分享创造）

**标题：** 做了个免费的 Mac 小工具：拖文件时右边会冒出一只河马，帮你暂存

**正文：**

写东西时经常有几个文件在 Finder 里搬来搬去，于是做了个置物架：

- 一开始拖文件，河马从屏幕右边滑出来
- 丢进嘴里暂存，一行一个；拖出去就是复制，原文件不动
- 嘴空了自动隐藏
- 两种皮肤：卡通河马 / 毛玻璃卡片
- 5 种语言；⌘/⇧ 多选；空格预览
- 菜单栏常驻；设置里可以改语言、开机自启、检查更新

技术：Swift + AppKit，通用二进制，macOS 13+，MIT。默认不联网、不传文件，只有你点「检查更新」时才请求 GitHub。

源码和下载：https://github.com/wunankun/HippoShelf
Homebrew：`brew install --cask wunankun/tap/hipposhelf`

还没公证（ad-hoc 签名），第一次打开要右键 → 打开。欢迎提意见。

---

## 即刻 / 微博（短版）

做了一只住在 Mac 菜单栏的河马：拖文件时它从屏幕右边探头，把文件放进嘴里暂存，空了就躲回去。免费开源，5 种语言，不联网。GitHub 搜 HippoShelf 🦛

---

## 目录站一句话（MacUpdate / AlternativeTo / Softpedia 等）

**EN:** Free, open-source menu-bar shelf for macOS. Drag files into a hippo's mouth to park them temporarily, drag them out to copy them back, and it hides when empty. Native Swift, universal binary, no telemetry.

**ZH:** 免费的 macOS 菜单栏临时置物架：拖文件时从屏幕右侧滑出一只河马，把文件放进嘴里暂存，拖出即复制取回，空嘴自动隐藏。原生 Swift，通用二进制，不联网。
