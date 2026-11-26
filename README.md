# 河马置物架 · HippoShelf

把文件丢进河马的嘴里。

一个 macOS 上的临时置物架：拖任意文件的时候，一只河马从屏幕右边滑出来，张嘴接住你暂时放下的东西；空了就自己躲回去。

<p align="center">
  <img src="docs/icon.png" width="112" alt="App 图标">
</p>

<p align="center">
  <img src="docs/cartoon.png" width="170" alt="卡通皮肤：黑色河马脸">
  &nbsp;&nbsp;
  <img src="docs/glass.png" width="180" alt="简约皮肤：毛玻璃卡片">
</p>

## 为什么

截图、素材、待发的文件，临时放在桌面上会摊成一堆。这个置物架只在你拖动文件时出现，用完就走——不占桌面，也不打断手头的事。

## 功能

- **拖拽唤出**：开始拖动任意文件时，从屏幕右边缘滑出
- **张嘴接住**：拖到河马脸上松手就收下；可以连续放多个，重复的文件自动跳过
- **临时置物架**：一行一个文件，缩略图 + 文件名；嘴巴随文件数变高，不滚动；清空后自动缩回屏幕边缘
- **拿回来**：拖出去 = 复制到目标位置（原文件不动）；单击选中，空格 Quick Look 预览，双击打开
- **多选**：⌘ 点选、⇧ 连选、在空白处按住框选；可以整组拖出
- **两种皮肤**：卡通（黑色河马脸）/ 简约（macOS 毛玻璃卡片），菜单栏随时切换
- **随便摆**：拖动顶部就能把架子放到屏幕任意位置，下次显示还在那
- **菜单栏控制**：显示/隐藏置物架（⌘S）、清空、皮肤、退出
- **小动作**：眨眼、耳朵摆动、眼珠跟着鼠标转（卡通皮肤）

## 系统要求

macOS 13 或更新，Intel 与 Apple 芯片都可以（通用二进制）。

## 构建

需要 Xcode Command Line Tools（`xcode-select --install`）：

```bash
git clone https://github.com/wunankun/HippoShelf.git
cd HippoShelf
./build.sh
open HippoShelf.app
```

`build.sh` 会用 `swiftc` 分别编译 arm64 与 x86_64，再用 `lipo` 合成通用二进制。

## 使用

把 `HippoShelf.app` 拖进「应用程序」：

- 第一次打开：在「应用程序」里右键 →「打开」，再点一次「打开」（本地签名，不是 App Store 应用）
- 提示「已损坏」时：`xattr -dr com.apple.quarantine /Applications/HippoShelf.app`
- 打开后没有 Dock 图标，只有菜单栏一只小河马，这是正常的
- 第一次访问桌面 / 文稿 / 下载目录时系统会询问权限，允许即可
- 开机自启：系统设置 → 通用 → 登录项 → 添加 HippoShelf

## 说明与限制

- 置物架只记录文件路径，**不移动、不复制、不上传**任何文件；退出 App 后列表清空（原文件当然还在）
- 文件多时嘴巴一直变高、不滚动，屏幕放不下时请先清空
- 从嘴里拖出去是**复制**，原文件不会被删

## 目录结构

```
Sources/
  ShelfStore.swift   置物架的文件列表（内存）
  HippoPanel.swift   河马脸绘制、窗口、文件格、拖放
  main.swift         App 入口、菜单栏、拖拽监听
Resources/           App 图标
docs/                README 截图
build.sh             构建通用二进制
Info.plist           App 元信息
```

## English

A tiny drag-and-drop shelf for macOS shaped like a hippo's mouth. Drag any file and a hippo slides in from the right edge of the screen; drop files into its mouth to park them for a while. It hides when empty, supports multi-select, Quick Look, two skins (cartoon hippo / translucent glass), and a freely draggable position. Built with Swift + AppKit as a universal binary, macOS 13+.

## License

[MIT](LICENSE) © 2026 wunankun

App 图标由作者用 AI 工具生成后处理，随项目一并发布。
