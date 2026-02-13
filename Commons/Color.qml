pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects

Singleton {
  id: color

  FileView {
    id: colorFile
    path: Qt.resolvedUrl("../Themes/matugen.json")
    blockLoading: true

    watchChanges: true
    onFileChanged: reload()
  }

  property string wallpaper: "Themes/wallpaper.jpg"

  readonly property var   colorData:    JSON.parse(colorFile.text())
  readonly property bool  darkMode:     colorData["is_dark_mode"]
  readonly property color primary:      colorData["primary"]
  readonly property color onprimary:    colorData["on_primary"]
  readonly property color secondary:    colorData["secondary"]
  readonly property color onsecondary:  colorData["on_secondary"]
  readonly property color tertiary:     colorData["tertiary"]
  readonly property color ontertiary:   colorData["on_tertiary"]
  readonly property color error:        colorData["error"]
  readonly property color onerror:      colorData["on_error"]
  readonly property color background:   colorData["background"]
  readonly property color onbackground: colorData["on_background"]
  readonly property color surface:      colorData["surface"]
  readonly property color onsurface:    colorData["on_surface"]
  readonly property color outline:      colorData["outline"]
  readonly property color shadow:       colorData["shadow"]
  readonly property color scrim:        colorData["scrim"]
  readonly property color source:       colorData["source_color"]

  function invert(c: color): color {
    return Qt.rgba(1 - c.r, 1 - c.g, 1 - c.b, c.a)
  }

  function darken(c: color, factor: real): color {
    return Qt.darker(c, factor)
  }

  function lighten(c: color, factor: real): color {
    return Qt.lighter(c, factor)
  }

  function genColors() {
    matugen.running = true
  }

  Process {
    id: matugen
    running: true
    command: [ "matugen", "image", wallpaper, "-c", "Themes/config.toml", "-m", (color.darkMode ? "dark" : "light") ]
    stdout: StdioCollector {
      onStreamFinished: {
        if (this.text) console.log(this.text)
      }
    }
    stderr: StdioCollector {
      onStreamFinished: {
        if (this.text) console.log(this.text)
      }
    }
    onExited: (code, status) => {
      if (code != 0) console.log(`Failed to run process with code=${code} and status='${status}'`)
    }
  }
}
