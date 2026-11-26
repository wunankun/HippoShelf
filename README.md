<p align="center">
  <img src="docs/icon.png" width="120" alt="HippoShelf 图标：一只黑色的卡通河马">
</p>

<h1 align="center">河马置物架 · HippoShelf</h1>

<p align="center">拖文件的时候，一只河马从屏幕右边探出头，张嘴接住你暂时放下的东西。</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13.0%2B-000000?logo=apple&logoColor=white" alt="macOS 13+">
  <img src="https://img.shields.io/badge/Swift-5.9-F05138?logo=swift&logoColor=white" alt="Swift 5.9">
  <img src="https://img.shields.io/badge/Universal-arm64%20%7C%20x86__64-2F81F7" alt="Universal binary">
  <img src="https://img.shields.io/badge/privacy-local%20only-3FB950" alt="100% local">
  <img src="https://img.shields.io/badge/network-none-3FB950" alt="No network">
  <img src="https://img.shields.io/badge/telemetry-none-3FB950" alt="No telemetry">
  <img src="https://img.shields.io/badge/price-free-3FB950" alt="完全免费">
  <a href="https://github.com/wunankun/HippoShelf/releases/latest"><img src="https://img.shields.io/github/v/release/wunankun/HippoShelf?label=download&color=2F81F7" alt="Download"></a>
  <img src="https://img.shields.io/github/license/wunankun/HippoShelf?color=3FB950" alt="MIT">
  <a href="https://github.com/wunankun/HippoShelf/stargazers"><img src="https://img.shields.io/github/stars/wunankun/HippoShelf?style=social" alt="GitHub stars"></a>
</p>

<p align="center"><b>完全免费</b> · 无内购 · 无订阅 · 无广告 · 无需账号</p>

<p align="center"><a href="https://github.com/wunankun/HippoShelf/releases/latest"><b>⬇ 下载 1.9 通用版（约 1.9 MB）</b></a></p>

<p align="center">
  <b>简体中文</b> · <a href="README.en.md">English</a> · <a href="README.es.md">Español</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="LICENSE">MIT</a>
</p>

<p align="center">
  <img src="docs/cartoon.gif" width="170" alt="卡通皮肤：黑色河马依次接住三个文件，清空后缩回">
  &nbsp;&nbsp;
  <img src="docs/glass.gif" width="170" alt="简约皮肤：毛玻璃卡片，拖文件时变高，清空后回到提示">
</p>
<p align="center"><sub>左：卡通皮肤 · 右：简约皮肤（实机录屏）</sub></p>

> **免费开源，没有内购和广告。如果这个小工具帮你少翻了一次桌面，点个 ⭐ Star 就是最好的支持。**

## 它是什么

一个 macOS 上的「随手放一下」置物架。拖任意文件时它从屏幕右边滑出来，把文件丢进河马嘴里暂存；用完拖走，嘴巴空了它就自己躲回去。

它不接管你的文件，也不试图管理文件——只是给"待会儿要用的那几个文件"一个临时的、看得见的地方。比如：

- **发微信 / 邮件**：先把要发的文件都丢进嘴里，再一起拖进对话框
- **做设计 / 写文档**：截图随手丢进去，等会儿统一拖进 Figma 或文档里
- **整理文件**：从不同文件夹挑出来的东西先暂存，再一次性拖去目的地

## 功能

- 🐡 **拖拽唤出**：开始拖任意文件时，从屏幕右边缘滑出，不挡视线
- 👄 **张嘴接住**：拖到河马脸上松手就收下；可以连续放多个，重复的文件自动跳过
- 📚 **临时置物架**：一行一个文件，缩略图 + 文件名；嘴巴随文件数变高，不滚动
- 🫥 **自动隐藏**：清空后自己缩回屏幕边缘，不占地方
- 🖱 **拿回来**：拖出去 = 复制到目标位置（原文件不动）；单击选中、空格 Quick Look、双击打开
- 🎯 **多选**：⌘ 点选、⇧ 连选、空白处按住框选；可以整组拖出
- 🎨 **两种皮肤**：卡通（黑色河马脸）/ 简约（macOS 毛玻璃卡片），菜单栏随时切换
- 📍 **随便摆**：拖动顶部把架子放到屏幕任意位置，下次显示还在那儿
- 🧠 **小动作**：眨眼、耳朵摆动、眼珠跟着鼠标转（卡通皮肤）
- ⚙️ **设置窗口**：⌘, 打开——切换界面语言、开机自启、检查更新
- 🌐 **5 种语言**：简体中文 / English / Español / 日本語 / 한국어，随时切换
- 🔄 **检查更新**：一键查看 GitHub 最新版本，有新版直接跳转下载
- 💸 **完全免费**：没有内购、订阅或广告，也不用注册账号
- 🔒 **默认本地**：不上传文件、无账号、无埋点；只有你主动点「检查更新」时才联网

## 隐私

**这是这个项目最重要的设计决定：默认不联网，也完全免费。**

- **默认零网络**：不拖入云、没有埋点、没有崩溃上报、没有账号体系
- **只有「检查更新」会联网**：而且必须由你亲手点；只向 GitHub 的公开接口查询版本号，不发送文件、路径或设备信息。不点它就完全不联网，也不影响使用
- **不上传文件**：只把「文件路径」放在内存里；退出 App，列表就清空
- **不碰你的文件**：拖出是**复制**，原文件不会被删、被移动、被改名
- **开源可验证**：全部逻辑就在 6 个 Swift 文件里，欢迎逐行审查
- **零第三方依赖**：只用 macOS 自带的 AppKit，没有包管理器、没有二进制依赖
- **不收费**：没有内购、订阅、广告，项目也不引导你注册任何账号

一句话：它只帮你暂存路径，不碰内容；除了你主动点的那一下「检查更新」，它不联网。

## 安装

### 方式一：直接下载（推荐）

到 [Releases](https://github.com/wunankun/HippoShelf/releases/latest) 下载 `HippoShelf-1.9-universal.zip`（约 1.9 MB，Intel / Apple 芯片通用），解压后把 `HippoShelf.app` 拖进「应用程序」。

- **第一次打开：** 右键 App →「打开」→ 再点「打开」（本地签名，未公证）
- 提示「已损坏，无法打开」时：
  ```bash
  xattr -dr com.apple.quarantine /Applications/HippoShelf.app
  ```
- 校验下载（可选）：`shasum -a 256 HippoShelf-1.9-universal.zip`，与 Release 页面的 `.sha256` 对比

> 每次发版都由 GitHub Actions 从源码构建（[release.yml](.github/workflows/release.yml)），Release 里附 `.sha256` 校验文件。

### 方式二：从源码构建

> 已经装过 Command Line Tools 的，直接跳到「第 3 步」。

**第 1 步：检查环境**（整段粘进终端）

```bash
sw_vers -productVersion   # 需要 13.0 或更高
xcode-select -p           # 有路径 = 命令行工具已安装
swiftc --version          # 能打印版本 = 编译器可用
git --version             # 能打印版本 = git 可用
```

**第 2 步：缺什么装什么**

| 你会看到 | 该怎么办 |
| --- | --- |
| `xcode-select -p` 报 `unable to get active developer directory` | 运行 `xcode-select --install`，弹窗点「安装」，等 5–15 分钟 |
| 弹窗没出现 / 下载卡住 | 打开「系统设置 → 通用 → 软件更新」看看有没有更新；或到 https://developer.apple.com/download/all/ 手动下载（免费 Apple ID） |
| 装完还是报错 | 运行 `sudo xcode-select -s /Library/Developer/CommandLineTools`，再检查一次 |
| `swiftc` 提示 license | 运行 `sudo xcodebuild -license accept` |
| macOS 低于 13 | 升级系统，或换一台 Mac（这个 App 最低 13） |
| 公司电脑没有管理员权限 | 让 IT 装，或者直接用上面的「方式一」下载现成包 |

**第 3 步：编译**

```bash
git clone https://github.com/wunankun/HippoShelf.git
cd HippoShelf
./build.sh
open HippoShelf.app
```

> 不需要完整的 Xcode（几个 GB），Command Line Tools 就够。`build.sh` 会分别编译 arm64 和 x86_64，用 `lipo` 合成一个通用 App。

### 首次打开

- 第一次**不要直接双击**：在 Finder 里右键 →「打开」→ 再点「打开」（本地签名，未经过公证）
- 如果提示「已损坏，无法打开」，在终端执行：
  ```bash
  xattr -dr com.apple.quarantine /Applications/HippoShelf.app
  ```
- 打开后 Dock 里没有图标，菜单栏会出现一只小河马，这是正常的
- 第一次拖桌面 / 文稿 / 下载里的文件时，系统会询问权限，允许即可
- 开机自启：菜单栏小河马 →「设置」→ 打开「开机自启」开关（也可以去 系统设置 → 通用 → 登录项 里添加）

## 使用

- 拖任意文件 → 河马滑出 → 松手放进嘴里
- 点文件选中，空格 Quick Look，双击打开；⌘ / ⇧ / 框选可以多选
- 按住选中的文件往嘴里外面拖 = 复制出去（原文件还在），同时从置物架移除
- 右耳的红色小鸟 = 清空；清空后自动缩回屏幕边缘
- 顶部横条可以拖动整个架子；位置会记住（菜单栏「显示置物架」⌘S 随时叫回）
- 菜单栏：显示/隐藏、清空、卡通/简约皮肤、设置（⌘,）、退出
- 设置里可以切换语言、开关开机自启、检查更新

## 常见问题

**Q：每台 Mac 都自带 Xcode Command Line Tools 吗？**
A：不是。先跑 `xcode-select -p` 检查：打印出路径就说明已装好；只有报错时才需要 `xcode-select --install`（约几百 MB）。Command Line Tools 就够，不需要完整的 Xcode。

**Q：文件多了会怎样？**
A：河马的嘴会一直变高，不滚动；屏幕放不下时先清空。

**Q：会删除我的文件吗？**
A：不会。置物架只记录路径；从嘴里拖出去是复制，原文件不动；退出 App 只是清空列表。

**Q：它会把我的文件传到网上吗？**
A：不会。默认没有任何网络请求，也不收集数据。唯一的联网是你主动点「检查更新」时向 GitHub 查询版本号，可以在源码 `UpdateChecker.swift` 里逐行核对。

**Q：支持多显示器和多桌面空间吗？**
A：支持，置物架会跟着你拖到的那块屏幕，并记住位置。

**Q：可以商用吗？**
A：可以，MIT 协议，保留版权声明即可。

**Q：为什么叫河马？**
A：因为嘴巴大，能装。

## 项目结构

```
Sources/
  ShelfStore.swift   置物架的文件列表（只在内存）
  HippoPanel.swift   河马脸绘制、窗口、文件格、拖放
  L10n.swift         五种语言的界面文案
  SettingsWindow.swift 设置窗口（语言 / 开机自启 / 检查更新）
  UpdateChecker.swift  GitHub Release 版本查询
  main.swift         App 入口、菜单栏、拖拽监听
Resources/           App 图标
docs/                README 截图
build.sh             构建通用二进制（arm64 + x86_64）
Info.plist           App 元信息（LSUIElement 无 Dock 图标）
```

## 参与

- 觉得有用 → ⭐ Star（真的很有用）
- 发现 bug / 想要功能 → 开 Issue
- 想改代码 → 欢迎 PR；改完跑一遍 `./build.sh` 确认通用版能构建

图标由作者用 AI 工具生成后处理，随项目以 MIT 协议发布。

## License

[MIT](LICENSE) © 2026 wunankun
