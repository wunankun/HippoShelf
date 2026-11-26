import Foundation

/// The five UI languages that the app, the menu bar and the README share.
enum AppLanguage: String, CaseIterable {
    case zh
    case en
    case es
    case ja
    case ko

    var nativeName: String {
        switch self {
        case .zh: return "简体中文"
        case .en: return "English"
        case .es: return "Español"
        case .ja: return "日本語"
        case .ko: return "한국어"
        }
    }

    /// First supported language from the system preferences, English otherwise.
    static var systemDefault: AppLanguage {
        for preferred in Locale.preferredLanguages {
            let code = preferred.split(separator: "-").first.map(String.init) ?? preferred
            if let match = AppLanguage(rawValue: String(code)) { return match }
        }
        return .en
    }
}

enum L10n {
    static let defaultsKey = "appLanguage"

    static var language: AppLanguage {
        get {
            if let raw = UserDefaults.standard.string(forKey: defaultsKey),
               let lang = AppLanguage(rawValue: raw) {
                return lang
            }
            return AppLanguage.systemDefault
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: defaultsKey)
        }
    }

    static func t(_ key: String) -> String {
        tables[language]?[key] ?? tables[.en]?[key] ?? key
    }

    static func t(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: t(key), arguments: arguments)
    }

    // MARK: - Tables

    private static let tables: [AppLanguage: [String: String]] = [
        .zh: [
            "app.name": "河马置物架",
            "menu.show": "显示置物架",
            "menu.hide": "隐藏置物架",
            "menu.clear": "清空置物架",
            "menu.cartoon": "卡通皮肤",
            "menu.glass": "简约皮肤",
            "menu.settings": "设置…",
            "menu.quit": "退出置物架",
            "hint.drop": "拖文件到这里",
            "tip.clear": "清空置物架",

            "settings.title": "设置",
            "settings.language": "语言",
            "settings.language.note": "菜单和提示会立即切换语言。",
            "settings.login": "开机自启",
            "settings.login.note": "登录后自动在菜单栏运行，不显示 Dock 图标。",
            "settings.updates": "更新",
            "settings.updates.note": "到 GitHub 检查是否有新版本。",
            "settings.version": "当前版本 %@",
            "settings.check": "检查更新",
            "settings.checking": "检查中…",
            "settings.upToDate": "已是最新版本",
            "settings.found": "发现新版本 %@",
            "settings.download": "去下载",
            "settings.networkNote": "检查更新是唯一会联网的操作：只有你点击时才会访问 GitHub，不发送任何数据。",

            "update.title": "检查更新",
            "update.body": "当前版本 %@，最新版本 %@。",
            "update.download": "去下载",
            "update.later": "以后再说",
            "update.failed": "检查更新失败",
            "update.failedInfo": "请检查网络后再试一次。",

            "login.on": "已开启",
            "login.off": "未开启",
            "login.pending": "等待系统批准",
            "login.failedTitle": "无法设置开机自启",
            "login.failedInfo": "请在「系统设置 → 通用 → 登录项」中手动添加「HippoShelf」。\n\n%@",

            "file.missingTitle": "文件已不在原位置",
            "file.missingInfo": "“%@” 可能已经被移动或删除。截图缩略图拖进来的文件有时是临时文件，拖完就会被系统清掉。",
            "file.remove": "从嘴里拿出来",
            "file.ok": "好",
            "file.permTitle": "没有权限读取这个文件",
            "file.permInfo": "请在「系统设置 → 隐私与安全性 → 文件与文件夹」里允许「HippoShelf」访问这个位置，然后再点一次。\n\n%@",
            "file.openSettings": "打开系统设置",
            "file.cannotOpenTitle": "打不开这个文件",
            "file.cannotOpenInfo": "没有找到能打开“%@”的应用。",
        ],
        .en: [
            "app.name": "HippoShelf",
            "menu.show": "Show shelf",
            "menu.hide": "Hide shelf",
            "menu.clear": "Clear shelf",
            "menu.cartoon": "Cartoon skin",
            "menu.glass": "Minimal skin",
            "menu.settings": "Settings…",
            "menu.quit": "Quit HippoShelf",
            "hint.drop": "Drop files here",
            "tip.clear": "Clear shelf",

            "settings.title": "Settings",
            "settings.language": "Language",
            "settings.language.note": "Menus and hints switch instantly.",
            "settings.login": "Launch at login",
            "settings.login.note": "Starts quietly in the menu bar after login.",
            "settings.updates": "Updates",
            "settings.updates.note": "Check GitHub for a newer version.",
            "settings.version": "Version %@",
            "settings.check": "Check for updates",
            "settings.checking": "Checking…",
            "settings.upToDate": "You're up to date",
            "settings.found": "New version %@ available",
            "settings.download": "Download",
            "settings.networkNote": "Checking for updates is the only network action: it contacts GitHub only when you click, and sends no data.",

            "update.title": "Update check",
            "update.body": "Current version %@ · Latest version %@.",
            "update.download": "Download now",
            "update.later": "Later",
            "update.failed": "Couldn't check for updates",
            "update.failedInfo": "Check your connection and try again.",

            "login.on": "On",
            "login.off": "Off",
            "login.pending": "Waiting for approval",
            "login.failedTitle": "Couldn't enable launch at login",
            "login.failedInfo": "Add HippoShelf manually in System Settings → General → Login Items.\n\n%@",

            "file.missingTitle": "File no longer exists",
            "file.missingInfo": "“%@” may have been moved or deleted. Files dragged from screenshot thumbnails are sometimes temporary.",
            "file.remove": "Remove it",
            "file.ok": "OK",
            "file.permTitle": "Can't read this file",
            "file.permInfo": "Allow HippoShelf in System Settings → Privacy & Security → Files and Folders, then try again.\n\n%@",
            "file.openSettings": "Open System Settings",
            "file.cannotOpenTitle": "Can't open this file",
            "file.cannotOpenInfo": "No app can open “%@”.",
        ],
        .es: [
            "app.name": "HippoShelf",
            "menu.show": "Mostrar estante",
            "menu.hide": "Ocultar estante",
            "menu.clear": "Vaciar estante",
            "menu.cartoon": "Tema caricatura",
            "menu.glass": "Tema minimalista",
            "menu.settings": "Ajustes…",
            "menu.quit": "Salir de HippoShelf",
            "hint.drop": "Suelta archivos aquí",
            "tip.clear": "Vaciar estante",

            "settings.title": "Ajustes",
            "settings.language": "Idioma",
            "settings.language.note": "Los menús y avisos cambian al instante.",
            "settings.login": "Abrir al iniciar sesión",
            "settings.login.note": "Se inicia en la barra de menús al iniciar sesión.",
            "settings.updates": "Actualizaciones",
            "settings.updates.note": "Busca una versión más reciente en GitHub.",
            "settings.version": "Versión %@",
            "settings.check": "Buscar actualizaciones",
            "settings.checking": "Buscando…",
            "settings.upToDate": "Ya tienes la última versión",
            "settings.found": "Nueva versión %@ disponible",
            "settings.download": "Descargar",
            "settings.networkNote": "Buscar actualizaciones es la única acción de red: solo contacta GitHub cuando haces clic y no envía datos.",

            "update.title": "Buscar actualizaciones",
            "update.body": "Versión actual %@ · Última versión %@.",
            "update.download": "Descargar ahora",
            "update.later": "Más tarde",
            "update.failed": "No se pudieron buscar actualizaciones",
            "update.failedInfo": "Revisa tu conexión e inténtalo de nuevo.",

            "login.on": "Activado",
            "login.off": "Desactivado",
            "login.pending": "Esperando aprobación",
            "login.failedTitle": "No se pudo activar la apertura al iniciar sesión",
            "login.failedInfo": "Añade HippoShelf manualmente en Ajustes del Sistema → General → Ítems de inicio.\n\n%@",

            "file.missingTitle": "El archivo ya no existe",
            "file.missingInfo": "«%@» puede haberse movido o eliminado. Los archivos arrastrados desde capturas a veces son temporales.",
            "file.remove": "Quitarlo",
            "file.ok": "Vale",
            "file.permTitle": "No se puede leer este archivo",
            "file.permInfo": "Permite el acceso de HippoShelf en Ajustes del Sistema → Privacidad y seguridad → Archivos y carpetas.\n\n%@",
            "file.openSettings": "Abrir Ajustes",
            "file.cannotOpenTitle": "No se puede abrir este archivo",
            "file.cannotOpenInfo": "Ninguna app puede abrir «%@».",
        ],
        .ja: [
            "app.name": "HippoShelf",
            "menu.show": "シェルフを表示",
            "menu.hide": "シェルフを隠す",
            "menu.clear": "シェルフを空にする",
            "menu.cartoon": "カートゥーンスキン",
            "menu.glass": "ミニマルスキン",
            "menu.settings": "設定…",
            "menu.quit": "HippoShelf を終了",
            "hint.drop": "ここにファイルをドロップ",
            "tip.clear": "シェルフを空にする",

            "settings.title": "設定",
            "settings.language": "言語",
            "settings.language.note": "メニューとヒントの言語がすぐに切り替わります。",
            "settings.login": "ログイン時に起動",
            "settings.login.note": "ログイン後、メニューバーで静かに起動します。",
            "settings.updates": "アップデート",
            "settings.updates.note": "GitHub で新しいバージョンを確認します。",
            "settings.version": "バージョン %@",
            "settings.check": "アップデートを確認",
            "settings.checking": "確認中…",
            "settings.upToDate": "最新バージョンです",
            "settings.found": "新しいバージョン %@ があります",
            "settings.download": "ダウンロード",
            "settings.networkNote": "アップデート確認だけがネットワークを使います。クリック時のみ GitHub にアクセスし、データは送信しません。",

            "update.title": "アップデート確認",
            "update.body": "現在 %@ · 最新 %@。",
            "update.download": "ダウンロードする",
            "update.later": "あとで",
            "update.failed": "アップデートを確認できませんでした",
            "update.failedInfo": "ネットワークを確認して、もう一度お試しください。",

            "login.on": "オン",
            "login.off": "オフ",
            "login.pending": "承認待ち",
            "login.failedTitle": "ログイン時の起動を設定できません",
            "login.failedInfo": "システム設定 → 一般 → ログイン項目 で HippoShelf を手動で追加してください。\n\n%@",

            "file.missingTitle": "ファイルが見つかりません",
            "file.missingInfo": "「%@」は移動または削除された可能性があります。スクリーンショットからドラッグしたファイルは一時ファイルの場合があります。",
            "file.remove": "取り出す",
            "file.ok": "OK",
            "file.permTitle": "このファイルを読み取れません",
            "file.permInfo": "システム設定 → プライバシーとセキュリティ → ファイルとフォルダ で HippoShelf に許可してください。\n\n%@",
            "file.openSettings": "システム設定を開く",
            "file.cannotOpenTitle": "このファイルを開けません",
            "file.cannotOpenInfo": "「%@」を開けるアプリが見つかりません。",
        ],
        .ko: [
            "app.name": "HippoShelf",
            "menu.show": "선반 보이기",
            "menu.hide": "선반 숨기기",
            "menu.clear": "선반 비우기",
            "menu.cartoon": "카툰 스킨",
            "menu.glass": "미니멀 스킨",
            "menu.settings": "설정…",
            "menu.quit": "HippoShelf 종료",
            "hint.drop": "여기에 파일을 놓으세요",
            "tip.clear": "선반 비우기",

            "settings.title": "설정",
            "settings.language": "언어",
            "settings.language.note": "메뉴와 안내 문구가 즉시 바뀝니다.",
            "settings.login": "로그인 시 실행",
            "settings.login.note": "로그인 후 메뉴 막대에서 조용히 실행됩니다.",
            "settings.updates": "업데이트",
            "settings.updates.note": "GitHub에서 새 버전을 확인합니다.",
            "settings.version": "버전 %@",
            "settings.check": "업데이트 확인",
            "settings.checking": "확인 중…",
            "settings.upToDate": "최신 버전입니다",
            "settings.found": "새 버전 %@ 사용 가능",
            "settings.download": "다운로드",
            "settings.networkNote": "업데이트 확인만 네트워크를 사용합니다. 클릭할 때만 GitHub에 접속하며 어떤 데이터도 보내지 않습니다.",

            "update.title": "업데이트 확인",
            "update.body": "현재 %@ · 최신 %@.",
            "update.download": "지금 다운로드",
            "update.later": "나중에",
            "update.failed": "업데이트를 확인할 수 없습니다",
            "update.failedInfo": "네트워크를 확인한 뒤 다시 시도해 주세요.",

            "login.on": "켜짐",
            "login.off": "꺼짐",
            "login.pending": "승인 대기 중",
            "login.failedTitle": "로그인 시 실행을 설정할 수 없습니다",
            "login.failedInfo": "시스템 설정 → 일반 → 로그인 항목에서 HippoShelf를 직접 추가하세요.\n\n%@",

            "file.missingTitle": "파일이 더 이상 존재하지 않습니다",
            "file.missingInfo": "“%@” 파일이 이동되었거나 삭제되었을 수 있습니다. 스크린샷에서 끌어온 파일은 임시 파일일 수 있습니다.",
            "file.remove": "꺼내기",
            "file.ok": "확인",
            "file.permTitle": "이 파일을 읽을 수 없습니다",
            "file.permInfo": "시스템 설정 → 개인정보 보호 및 보안 → 파일 및 폴더에서 HippoShelf를 허용하세요.\n\n%@",
            "file.openSettings": "설정 열기",
            "file.cannotOpenTitle": "이 파일을 열 수 없습니다",
            "file.cannotOpenInfo": "“%@”을 열 수 있는 앱이 없습니다.",
        ],
    ]
}
