<p align="center">
  <img src="docs/icon.png" width="120" alt="HippoShelf のアイコン：黒いカバ">
</p>

<h1 align="center">HippoShelf</h1>

<p align="center">ファイルをドラッグし始めると、画面の右端からカバが口を開けて現れ、しばらく預かってくれます。</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13.0%2B-000000?logo=apple&logoColor=white" alt="macOS 13+">
  <img src="https://img.shields.io/badge/Swift-5.9-F05138?logo=swift&logoColor=white" alt="Swift 5.9">
  <img src="https://img.shields.io/badge/Universal-arm64%20%7C%20x86__64-2F81F7" alt="ユニバーサル">
  <img src="https://img.shields.io/badge/privacy-local%20only-3FB950" alt="完全ローカル">
  <img src="https://img.shields.io/badge/network-none-3FB950" alt="ネット接続なし">
  <img src="https://img.shields.io/badge/telemetry-none-3FB950" alt="テレメトリなし">
  <img src="https://img.shields.io/badge/price-free-3FB950" alt="無料">
  <a href="https://github.com/wunankun/HippoShelf/releases/latest"><img src="https://img.shields.io/github/v/release/wunankun/HippoShelf?label=download&color=2F81F7" alt="Download"></a>
  <img src="https://img.shields.io/github/license/wunankun/HippoShelf?color=3FB950" alt="MIT">
  <a href="https://github.com/wunankun/HippoShelf/stargazers"><img src="https://img.shields.io/github/stars/wunankun/HippoShelf?style=social" alt="スター"></a>
</p>

<p align="center"><b>ずっと無料</b> · アプリ内課金なし · サブスクなし · 広告なし · アカウント不要</p>

<p align="center"><a href="https://github.com/wunankun/HippoShelf/releases/latest"><b>⬇ 1.8 をダウンロード（ユニバーサル, 1.8 MB）</b></a></p>

<p align="center">
  <a href="README.md">简体中文</a> · <a href="README.en.md">English</a> · <a href="README.es.md">Español</a> · <b>日本語</b> · <a href="README.ko.md">한국어</a> · <a href="LICENSE">MIT</a>
</p>

<p align="center">
  <img src="docs/cartoon.png" width="170" alt="カートゥーンスキン：2つのファイルをくわえた黒いカバ">
  &nbsp;&nbsp;
  <img src="docs/glass.png" width="180" alt="シンプルスキン：すりガラスのカード">
</p>
<p align="center"><sub>左：カートゥーンスキン · 右：シンプルスキン</sub></p>

> **無料・オープンソース。広告も課金もありません。デスクトップを開く手間が減ったら、⭐ スターで応援してもらえると嬉しいです。**

## これは何

macOS 用の「ちょっとここに置いとく」置き場です。ファイルをドラッグし始めると右端からスッと現れ、カバの口に落とせば一時的に預かります。必要になったら外へドラッグ。口が空になれば、また隠れます。

ファイルを管理したり置き換えたりはしません。「あとで使ういくつかのファイル」に、目に見える一時的な場所を用意するだけです。たとえば：

- **ファイルを送るとき**（LINE、メール、Slack）：送るファイルを口に集めて、まとめてチャットへ
- **デザイン・執筆中**：スクリーンショットをいったん口へ。あとで Figma や書類へ
- **整理中**：いろいろなフォルダから選んだファイルを一時的に集めて、目的地へ一気に

## 機能

- 🐡 **ドラッグで出現**：ファイルをドラッグし始めると右端からスライドイン
- 👄 **口で受け止める**：カバの顔の上で離せば収納。重複は自動でスキップ
- 📚 **置き場であって管理ソフトではない**：1行1ファイル、サムネイル＋名前。ファイルが増えると口が縦に伸びる（スクロールなし）
- 🫥 **空になったら隠れる**：画面の端へ戻ります
- 🖱 **取り出す**：外へドラッグすると**コピー**（元ファイルはそのまま）。クリックで選択、スペースでクイックルック、ダブルクリックで開く
- 🎯 **複数選択**：⌘／⇧／空白で範囲選択。まとめて取り出せます
- 🎨 **2つのスキン**：カートゥーン（黒いカバ）／シンプル（macOS のすりガラス）。メニューバーから切り替え
- 📍 **好きな位置へ**：上部のバーをドラッグして移動。位置を覚えます
- 🧠 **小さな動き**：まばたき、耳の揺れ、マウスを追う瞳（カートゥーン）
- 💸 **完全無料**：課金・サブスク・広告・アカウント一切なし
- 🔒 **完全ローカル**：ネット接続なし、テレメトリなし

## プライバシー

**このプロジェクトで最も大事な設計判断：ネットにつながらず、無料です。**

- **ネットワークコードなし**：`URLSession` も、解析も、クラッシュ送信も、アカウントもありません
- **アップロードなし**：メモリに保存するのはファイルの**パス**だけ。アプリを終了するとリストは消えます
- **ファイルに触らない**：外へドラッグすると**コピー**。元ファイルは削除・移動・改名されません
- **オープンソース**：ロジックは Swift 3ファイルのみ。行単位で監査できます
- **外部依存ゼロ**：Apple の AppKit のみ。パッケージマネージャもバイナリ依存もなし
- **料金なし**：課金・サブスク・広告なし。登録を求めることもありません

ひとことで：パスだけを預かり、中身には触れず、外部に何も送りません。

## インストール

### 方法 1: ダウンロード（おすすめ）

[Releases](https://github.com/wunankun/HippoShelf/releases/latest) から `HippoShelf-1.8-universal.zip`（約 1.8 MB、Intel / Apple シリコン共通）をダウンロードして解凍し、`HippoShelf.app` を「アプリケーション」へドラッグします。

- **初回起動:** アプリを右クリック →「開く」→ もう一度「開く」（ローカル署名のみ、公証なし）。
- 「壊れているため開けません」と出たら:
  ```bash
  xattr -dr com.apple.quarantine /Applications/HippoShelf.app
  ```
- チェックサム（任意）: `shasum -a 256 HippoShelf-1.8-universal.zip` の結果を Release ページの `.sha256` と照合。

> 各リリースは GitHub Actions がソースからビルドし（[release.yml](.github/workflows/release.yml)）、`.sha256` を添付します。

### 方法 2: ソースからビルド

macOS 13 以降が必要です。**まず確認**し、無い場合だけインストール:

```bash
xcode-select -p
```

- パス（例 `/Library/Developer/CommandLineTools`）が出れば準備完了。インストールは不要。
- `unable to get active developer directory` と出たら:
  ```bash
  xcode-select --install
  ```
  ダイアログで「インストール」を押し、再度 `xcode-select -p` で確認。

```bash
git clone https://github.com/wunankun/HippoShelf.git
cd HippoShelf
./build.sh
open HippoShelf.app
```

> 完全版の Xcode（数 GB）は不要で、Command Line Tools で十分です。`build.sh` は arm64 と x86_64 をビルドし、`lipo` でユニバーサル App にまとめます。

### 初回起動

- 初回はダブルクリックせず、**右クリック →「開く」→ もう一度「開く」**（ローカル署名・公証なし）
- 「壊れているため開けません」と出たら：
  ```bash
  xattr -dr com.apple.quarantine /Applications/HippoShelf.app
  ```
- Dock にアイコンは出ません。メニューバーのカバが本体です（正常）
- デスクトップ／書類／ダウンロードから初めてドロップするとき、権限を聞かれたら許可してください
- ログイン時に起動：システム設定 → 一般 → ログイン項目

## 使い方

- ファイルをドラッグ → カバが出現 → 口にドロップ
- クリックで選択、スペースでクイックルック、ダブルクリックで開く。⌘／⇧／範囲選択で複数選択
- 選択したファイルを口の外へドラッグすると**コピー**され、置き場から外れます（元ファイルは残ります）
- 右耳の赤い鳥＝空にする。空になると自動で隠れます
- 上部のバーをドラッグして移動。位置は記憶されます（⌘S でいつでも呼び出し）
- メニューバー：表示/隠す、空にする、スキン、終了

## よくある質問

**Q: すべての Mac に Xcode Command Line Tools は入っていますか？**
A: いいえ。まず `xcode-select -p` を実行してください。パスが出れば準備完了です。エラーになった場合だけ `xcode-select --install`（数百 MB）が必要です。Xcode 本体は不要です。

**Q: ファイルが増えるとどうなりますか？**
A: 口がどんどん高くなり、スクロールしません。画面に収まらないときは空にしてください。

**Q: ファイルは削除されますか？**
A: いいえ。パスだけを保持します。外へドラッグするとコピー。終了するとリストだけ消えます。

**Q: ファイルはアップロードされますか？**
A: いいえ。ネットワークコードは一切ありません。ソースで `URLSession` を検索してみてください。

**Q: マルチディスプレイ／スペースは？**
A: 対応しています。移動した画面に追従し、位置を覚えます。

**Q: 商用利用はできますか？**
A: MIT なので可能です。著作権表示を残してください。

**Q: なぜカバ？**
A: 口が大きいから。

## プロジェクト構成

```
Sources/
  ShelfStore.swift   置き場のファイルリスト（メモリのみ）
  HippoPanel.swift   カバの顔の描画、ウィンドウ、セル、ドラッグ＆ドロップ
  main.swift         アプリの入口、メニューバー、ドラッグ監視
Resources/           アプリアイコン
docs/                README 用スクリーンショット
build.sh             ユニバーサルバイナリをビルド（arm64 + x86_64）
Info.plist           アプリ情報（LSUIElement：Dock アイコンなし）
```

## コントリビュート

- 役に立った → ⭐ スター（本当に励みになります）
- バグ・要望 → Issue を立ててください
- コード → PR 歓迎。`./build.sh` を実行してユニバーサルビルドが通ることを確認してください

アイコンは AI ツールで生成し、作者が加工したものです。MIT でプロジェクトと一緒に公開しています。

## ライセンス

[MIT](LICENSE) © 2026 wunankun
