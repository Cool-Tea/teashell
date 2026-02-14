import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

import qs.Commons

Rectangle {
  id: backlight
  implicitWidth: audioIcon.width + audioText.width + 4
  implicitHeight: 15

  color: "transparent"

  property alias  textColor: audioText.color
  property list<string> icons: ["", "", ""]
  property string mutedIcon: "婢"
  property string errorIcon: ""

  PwObjectTracker {
    id: audioTracker
    objects: [ Pipewire.defaultAudioSink ]
  }

  states: State {
    name: "onHover"
    when: audioMouseArea.containsMouse
    PropertyChanges {
      audioText { color: Color.source }
    }
  }

  transitions: Transition {
    to: "onHover"
    reversible: true
    ColorAnimation { duration: 100 }
  }

  Text {
    id: audioIcon
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    color: audioText.color
    text: {
      if (!Pipewire.ready) return errorIcon
      let device = Pipewire.defaultAudioSink
      if (!device || !device.ready || !device.audio) return errorIcon
      if (device.audio.muted) {
        return mutedIcon
      } else {
        let idx = Math.round(device.audio.volume * (icons.length - 1))
        if (isNaN(idx)) return errorIcon
        return icons[idx]
      }
    }
    font.pointSize: 14
    font.family: "FreeSans"
  }

  Text {
    id: audioText
    anchors.left: audioIcon.right
    anchors.verticalCenter: parent.verticalCenter
    color: Color.onsecondary
    text: {
      if (!Pipewire.ready) return ""
      let device = Pipewire.defaultAudioSink
      if (!device || !device.ready || !device.audio) return ""
      if (device.audio.muted) {
        return " 0%"
      } else {
        return ` ${Math.round(device.audio.volume * 100)}%`
      }
    }
    font.pointSize: 8
    font.family: "FreeSans"
    // font.bold: true
  }

  MouseArea {
    id: audioMouseArea
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onClicked: audioControlProc.running = true
    onEntered: audioTooltipTimer.running = true
    onExited: {
      audioTooltipTimer.running = false
      audioTooltip.visible = false
    }
  }

  Process {
    id: audioControlProc
    running: false
    command: [ "pavucontrol", "-t", "3" ]
  }

  Timer {
    id: audioTooltipTimer
    interval: 500
    repeat: false
    running: false
    onTriggered: audioTooltip.visible = true
  }

  Tooltip {
    id: audioTooltip
    implicitHeight: 30

    target: audio
    bgColor: Color.tertiary
    fgColor: Color.ontertiary
    text: {
      let device = Pipewire.defaultAudioSink
      if (!device) return "Unknown"
      return device.description
    }
  }
}
