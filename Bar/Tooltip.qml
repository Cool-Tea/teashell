import Quickshell
import QtQuick
import QtQuick.Effects

import qs.Commons

PopupWindow {
  id: tooltip
  implicitWidth: tooltipText.width + 20
  implicitHeight: 30
  visible: false

  required property var target
  property bool persist: false
  property alias text: tooltipText.text
  property alias textSize: tooltipText.font.pointSize
  property alias textFont: tooltipText.font.family
  property alias bgColor: tooltipRect.color
  property alias fgColor: tooltipText.color
  property alias radius: tooltipRect.radius

  color: "transparent"

  anchor.item: parent
  anchor.rect.x: target.x + target.width / 2 - width / 2
  anchor.rect.y: {
    switch (bar.position) {
      case "top": return target.y + target.height + 4
      case "bottom": return target.y - height - 4
      default: console.log(`Unsupported bar position: ${bar.position}`)
    }
    return target.y + target.height + 4
  }

  RectangularShadow {
    anchors.fill: tooltipRect
    radius: tooltipRect.radius
    blur: 5
    spread: 1
    color: Color.shadow
    opacity: tooltipRect.opacity
  }

  Rectangle {
    id: tooltipRect
    implicitWidth: parent.width - 10
    implicitHeight: parent.height - 10
    anchors.centerIn: parent
    color: Color.secondary
    radius: 8

    Text {
      id: tooltipText
      anchors.centerIn: parent
      color: Color.onsecondary
      text: "Tooltip"
      font.family: "JetBrainsMonoNerdFont"
      font.pointSize: 8
    } 
  }
}
