import Quickshell
import Quickshell.Io
import QtQuick

import qs.Commons

Rectangle {
  id: backlight
  implicitWidth: backlightIcon.width + backlightText.width + 4
  implicitHeight: 15

  color: "transparent"

  property alias textColor: backlightText.color
  property string device: "amdgpu_bl1"
  property int current: 1
  property int max: 1
  property list<string> icons: ["", "", "", "", "", "", "", "", ""]

  Text {
    id: backlightIcon
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    color: backlightText.color
    text: {
      let idx = Math.floor((current / max) * (icons.length - 1))
      return icons[idx]
    }
    font.pointSize: 10
    font.family: "FreeSans"
  }

  Text {
    id: backlightText
    anchors.left: backlightIcon.right
    anchors.verticalCenter: parent.verticalCenter
    color: Color.onsecondary
    text: ` ${Math.round((current/max)*100)}%`
    font.pointSize: 8
    font.family: "FreeSans"
    // font.bold: true
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onEntered: backlightTooltipTimer.running = true
    onExited: {
      backlightTooltipTimer.running = false
      backlightTooltip.visible = false
    }
  }

  Timer {
    id: backlightTooltipTimer
    interval: 500
    repeat: false
    running: false
    onTriggered: backlightTooltip.visible = true 
  }

  Tooltip {
    id: backlightTooltip
    implicitHeight: 30

    target: backlight
    text: `${current}/${max}`
  }

  FileView {
    id: curBl
    path: Qt.resolvedUrl(`/sys/class/backlight/${device}/brightness`)
    watchChanges: true
    onFileChanged: current = parseInt(text().trim())
    onLoaded: current = parseInt(text().trim())
  }

  FileView {
    id: maxBl
    path: Qt.resolvedUrl(`/sys/class/backlight/${device}/max_brightness`)
    watchChanges: true
    onFileChanged: max = parseInt(text().trim())
    onLoaded: max = parseInt(text().trim())
  }
}
