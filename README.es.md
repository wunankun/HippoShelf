# HippoShelf

Deja caer tus archivos en la boca de un hipopótamo.

Un estante temporal para macOS: al empezar a arrastrar cualquier archivo, un hipopótamo se asoma desde el borde derecho de la pantalla; suelta los archivos en su boca y los guarda por ti. Cuando la boca queda vacía, se esconde otra vez.

<p align="center">
  <a href="README.md">简体中文</a> · <a href="README.en.md">English</a> · Español · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="LICENSE">MIT</a>
</p>

<p align="center">
  <img src="docs/cartoon.png" width="170" alt="Piel de dibujo: cara de hipopótamo negra">
  &nbsp;&nbsp;
  <img src="docs/glass.png" width="180" alt="Piel simple: tarjeta de cristal translúcida">
</p>

## Por qué

Las capturas, los recursos y los archivos por enviar se acumulan en el escritorio. El hipopótamo solo aparece mientras arrastras, así que no estorba.

## Funciones

- **Aparece al arrastrar**: se desliza desde el borde derecho cuando empiezas a arrastrar un archivo
- **Boca abierta**: suelta los archivos sobre su cara para guardarlos; los duplicados se ignoran
- **Estante temporal**: una fila por archivo con miniatura y nombre; la boca crece con más archivos (sin desplazamiento) y se esconde al vaciarse
- **Recuperarlos**: arrastra un archivo fuera para copiarlo a otro sitio (el original se queda); clic para seleccionar, espacio para Vista rápida, doble clic para abrir
- **Selección múltiple**: ⌘+clic, ⇧+clic o arrastrando un marco en el espacio vacío; puedes sacar toda la selección
- **Dos pieles**: Dibujo (cara de hipopótamo negra) / Simple (cristal translúcido), se cambian desde la barra de menús
- **Muévelo donde quieras**: arrastra la parte superior del estante; recuerda la posición
- **Barra de menús**: mostrar/ocultar (⌘S), vaciar, piel, salir
- **Pequeños detalles**: parpadeos, orejas que se mueven, pupilas que siguen el ratón (piel de dibujo)

## Requisitos

macOS 13 o superior, Intel y Apple Silicon (binario universal).

## Compilar

Requiere Xcode Command Line Tools (`xcode-select --install`):

```bash
git clone https://github.com/wunankun/HippoShelf.git
cd HippoShelf
./build.sh
open HippoShelf.app
```

`build.sh` compila arm64 y x86_64 con `swiftc` y los une en un binario universal con `lipo`.

## Uso

Arrastra `HippoShelf.app` a Aplicaciones:

- Primera apertura: clic derecho en la app → Abrir y confirma (firma local, no es de la App Store)
- Si macOS dice que la app está dañada: `xattr -dr com.apple.quarantine /Applications/HippoShelf.app`
- No hay icono en el Dock, solo un pequeño hipopótamo en la barra de menús
- macOS puede pedir acceso a Escritorio / Documentos / Descargas la primera vez; concédelo
- Iniciar al arrancar: Ajustes del Sistema → General → Ítems de inicio

## Notas

- El estante solo guarda rutas de archivos; nunca mueve, copia ni sube tus archivos. La lista se vacía al salir de la app
- La boca sigue creciendo sin desplazamiento: vacíala si no cabe en pantalla
- Arrastrar un archivo fuera lo copia; el original no se toca

## Licencia

[MIT](LICENSE) © 2026 wunankun

El icono de la app fue generado con una herramienta de IA y editado por el autor.
