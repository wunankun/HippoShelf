<p align="center">
  <img src="docs/icon.png" width="120" alt="Icono de HippoShelf: un hipopótamo negro de dibujos">
</p>

<h1 align="center">HippoShelf</h1>

<p align="center">Empieza a arrastrar un archivo y un hipopótamo se asoma desde el borde derecho de la pantalla con la boca abierta, listo para guardarlo por ti.</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13.0%2B-000000?logo=apple&logoColor=white" alt="macOS 13+">
  <img src="https://img.shields.io/badge/Swift-5.9-F05138?logo=swift&logoColor=white" alt="Swift 5.9">
  <img src="https://img.shields.io/badge/Universal-arm64%20%7C%20x86__64-2F81F7" alt="Universal">
  <img src="https://img.shields.io/badge/privacy-local%20only-3FB950" alt="100% local">
  <img src="https://img.shields.io/badge/network-none-3FB950" alt="Sin red">
  <img src="https://img.shields.io/badge/telemetry-none-3FB950" alt="Sin telemetría">
  <img src="https://img.shields.io/badge/price-free-3FB950" alt="Gratis">
  <a href="https://github.com/wunankun/HippoShelf/releases/latest"><img src="https://img.shields.io/github/v/release/wunankun/HippoShelf?label=download&color=2F81F7" alt="Download"></a>
  <img src="https://img.shields.io/github/license/wunankun/HippoShelf?color=3FB950" alt="MIT">
  <a href="https://github.com/wunankun/HippoShelf/stargazers"><img src="https://img.shields.io/github/stars/wunankun/HippoShelf?style=social" alt="Estrellas"></a>
</p>

<p align="center"><b>Gratis para siempre</b> · Sin compras dentro de la app · Sin suscripción · Sin anuncios · Sin cuenta</p>

<p align="center"><a href="https://github.com/wunankun/HippoShelf/releases/latest"><b>⬇ Descargar 1.8 (universal, 1,8 MB)</b></a></p>

<p align="center">
  <a href="README.md">简体中文</a> · <a href="README.en.md">English</a> · <b>Español</b> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="LICENSE">MIT</a>
</p>

<p align="center">
  <img src="docs/cartoon.png" width="170" alt="Skin dibujos: hipopótamo negro con dos archivos">
  &nbsp;&nbsp;
  <img src="docs/glass.png" width="180" alt="Skin simple: tarjeta de cristal esmerilado">
</p>
<p align="center"><sub>Izquierda: skin dibujos · Derecha: skin simple</sub></p>

> **Gratis y de código abierto, sin anuncios ni compras. Si te ahorra un viaje al escritorio, una ⭐ Star es el mejor apoyo.**

## Qué es

Un estante de "déjalo aquí un momento" para macOS. Al empezar a arrastrar cualquier archivo, se desliza desde el borde derecho de la pantalla; suelta los archivos en la boca del hipopótamo para guardarlos un rato. Cuando los necesites, arrástralos fuera; cuando la boca queda vacía, se esconde otra vez.

No se apropia de tus archivos ni intenta gestionarlos: solo le da un lugar temporal y visible a "esos pocos archivos que voy a necesitar en un minuto". Por ejemplo:

- **Enviar archivos** (WhatsApp, Mail, Slack): reúne en la boca los que quieres enviar y arrástralos todos al chat a la vez
- **Diseño / escritura**: deja ahí las capturas y luego arrástralas a Figma o al documento
- **Ordenar**: separa archivos de distintas carpetas y llévalos al destino de una sola vez

## Funciones

- 🐡 **Aparece al arrastrar**: empieza a arrastrar cualquier archivo y entra desde el borde derecho
- 👄 **Abre la boca**: suelta sobre la cara del hipopótamo; los duplicados se omiten automáticamente
- 📚 **Un estante, no un gestor**: un archivo por fila, miniatura + nombre; la boca crece con la cantidad, sin desplazamiento
- 🫥 **Se esconde al vaciarse**: vuelve al borde de la pantalla
- 🖱 **Recuperar**: arrastrar fuera **copia** el archivo (el original queda); clic para seleccionar, espacio para Vista rápida, doble clic para abrir
- 🎯 **Selección múltiple**: ⌘, ⇧ o marco en el espacio vacío; arrastra toda la selección
- 🎨 **Dos skins**: Dibujos (hipopótamo negro) / Simple (cristal esmerilado de macOS), desde la barra de menús
- 📍 **Muévelo donde quieras**: arrastra la barra superior; recuerda la posición
- 🧠 **Detalles**: parpadea, mueve las orejas, los ojos siguen al ratón (skin dibujos)
- 💸 **Totalmente gratis**: sin compras, sin suscripción, sin anuncios, sin cuenta
- 🔒 **Todo local**: sin red, sin telemetría

## Privacidad

**La decisión de diseño más importante del proyecto: nunca se conecta a internet, y es gratis.**

- **Sin código de red**: no hay `URLSession`, ni analíticas, ni reportes de fallos, ni cuentas
- **No sube nada**: solo guarda *rutas* en memoria; al cerrar la app, la lista se vacía
- **No toca tus archivos**: arrastrar fuera **copia**; el original nunca se borra, mueve ni renombra
- **Código abierto**: toda la lógica está en tres archivos Swift, auditable línea por línea
- **Cero dependencias de terceros**: solo AppKit de Apple
- **Sin cobros**: sin compras, suscripciones ni anuncios; el proyecto nunca te pide registrarte

En una frase: guarda rutas, nunca contenidos, y nunca llama a casa.

## Instalación

### Opción 1: Descargar (recomendado)

Descarga `HippoShelf-1.8-universal.zip` desde [Releases](https://github.com/wunankun/HippoShelf/releases/latest) (~1,8 MB, universal para Intel y Apple silicon), descomprímelo y arrastra `HippoShelf.app` a Aplicaciones.

- **Primera apertura:** clic derecho en la app → Abrir → Abrir otra vez (firmada localmente, sin notarizar).
- Si macOS dice que la app está dañada:
  ```bash
  xattr -dr com.apple.quarantine /Applications/HippoShelf.app
  ```
- Comprobación opcional: compara `shasum -a 256 HippoShelf-1.8-universal.zip` con el archivo `.sha256` de la página de la release.

> Cada release se compila desde el código con GitHub Actions ([release.yml](.github/workflows/release.yml)) e incluye un `.sha256`.

### Opción 2: Compilar desde el código

> ¿Ya tienes las Command Line Tools? Salta al paso 3.

**Paso 1: Comprueba el entorno**

```bash
sw_vers -productVersion   # necesitas 13.0 o superior
xcode-select -p           # una ruta = herramientas instaladas
swiftc --version          # imprime versión = compilador listo
git --version             # imprime versión = git listo
```

**Paso 2: Instala solo lo que falte**

| Lo que ves | Qué hacer |
| --- | --- |
| `xcode-select -p` falla con `unable to get active developer directory` | Ejecuta `xcode-select --install`, pulsa Instalar y espera 5–15 min |
| No aparece el diálogo / la descarga se atasca | Revisa Ajustes → General → Actualización de software, o descarga manual desde https://developer.apple.com/download/all/ (Apple ID gratis) |
| Sigue fallando después de instalar | Ejecuta `sudo xcode-select -s /Library/Developer/CommandLineTools` y comprueba otra vez |
| `swiftc` pide aceptar la licencia | Ejecuta `sudo xcodebuild -license accept` |
| macOS es anterior a 13 | Actualiza macOS o usa otro Mac (se requiere 13+) |
| Sin permisos de administrador (Mac de empresa) | Pídelo a IT o usa la descarga ya compilada de arriba |

**Paso 3: Compila**

```bash
git clone https://github.com/wunankun/HippoShelf.git
cd HippoShelf
./build.sh
open HippoShelf.app
```

> No necesitas el Xcode completo (varios GB): basta con Command Line Tools. `build.sh` compila arm64 y x86_64 y los une con `lipo` en una app universal.

### Primera apertura

- No hagas doble clic la primera vez: **clic derecho → Abrir → Abrir** (firma local, sin notarizar)
- Si macOS dice que está dañada:
  ```bash
  xattr -dr com.apple.quarantine /Applications/HippoShelf.app
  ```
- No hay icono en el Dock: el hipopótamo vive en la barra de menús, es normal
- macOS pedirá permiso la primera vez que sueltes archivos de Escritorio / Documentos / Descargas
- Iniciar al arrancar: Ajustes del Sistema → General → Ítems de inicio

## Uso

- Arrastra cualquier archivo → aparece el hipopótamo → suéltalo en la boca
- Clic para seleccionar, espacio para Vista rápida, doble clic para abrir; ⌘ / ⇧ / marco para varios
- Arrastra los archivos seleccionados fuera de la boca para **copiarlos** (los originales quedan) y quitarlos del estante
- El pájaro rojo de la oreja derecha vacía el estante; se esconde solo cuando está vacío
- Arrastra la barra superior para moverlo; la posición se recuerda (⌘S lo muestra otra vez)
- Barra de menús: mostrar/ocultar, vaciar, skin dibujos/cristal, salir

## Preguntas frecuentes

**¿Todos los Mac traen Xcode Command Line Tools?**
No. Ejecuta primero `xcode-select -p`: si imprime una ruta, ya está listo. Solo si da error necesitas `xcode-select --install` (unos cientos de MB). No hace falta el Xcode completo.

**¿Qué pasa si añado muchos archivos?**
La boca crece sin desplazamiento; vacíalo si no cabe en la pantalla.

**¿Borrará mis archivos?**
No. Solo guarda rutas; arrastrar fuera copia; salir solo vacía la lista.

**¿Sube mis archivos a internet?**
No. No hay código de red: busca `URLSession` en el código.

**¿Varias pantallas y espacios?**
Sí; sigue la pantalla donde lo sueltes y recuerda la posición.

**¿Puedo usarlo comercialmente?**
Sí, bajo MIT, conservando el aviso de copyright.

**¿Por qué un hipopótamo?**
Por la boca.

## Estructura del proyecto

```
Sources/
  ShelfStore.swift   lista de archivos del estante (solo en memoria)
  HippoPanel.swift   dibujo de la cara, ventana, celdas, arrastrar y soltar
  main.swift         entrada de la app, barra de menús, monitor de arrastre
Resources/           icono de la app
docs/                capturas para el README
build.sh             compila el binario universal (arm64 + x86_64)
Info.plist           metadatos (LSUIElement: sin icono en el Dock)
```

## Contribuir

- Si te resulta útil → ⭐ Star (ayuda de verdad)
- ¿Bug o idea? → abre un Issue
- ¿Código? → PRs bienvenidos; ejecuta `./build.sh` antes para confirmar que la compilación universal sigue funcionando

El icono fue generado con una herramienta de IA y editado por el autor; se publica bajo MIT con el proyecto.

## Licencia

[MIT](LICENSE) © 2026 wunankun
