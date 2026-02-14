import Quickshell
import Quickshell.Services.UPower
import QtQuick

import qs.Commons

Rectangle {
  id: battery
  implicitWidth: batteryIcon.width + batteryText.width + 4
  implicitHeight: 15

  color: "transparent"

  property alias  textColor: batteryText.color
  property list<string> icons: ["", "", "", "", ""]
  property string chargeIcon: ""
  property string errorIcon: ""

  states: State {
    name: "onHover"
    when: batteryMouseArea.containsMouse
    PropertyChanges {
      batteryText { color: Color.source }
    }
  }

  transitions: Transition {
    to: "onHover"
    reversible: true
    ColorAnimation { duration: 100 }
  }

  Text {
    id: batteryIcon
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    color: batteryText.color
    text: {
      let device = UPower.displayDevice
      if (!device.ready) return errorIcon
      if (UPower.onBattery) {
        let idx = Math.round(device.percentage * (icons.length - 1))
        return icons[idx]
      } else {
        return chargeIcon
      }
    }
    font.pointSize: 10
    font.family: "FreeSans"
  }

  Text {
    id: batteryText
    anchors.left: batteryIcon.right
    anchors.verticalCenter: parent.verticalCenter
    color: Color.onsecondary
    text: {
      let device = UPower.displayDevice
      if (!device.ready) return ""
      return ` ${device.percentage * 100}%`
    }
    font.pointSize: 8
    font.family: "FreeSans"
    // font.bold: true
  }

  MouseArea {
    id: batteryMouseArea
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onEntered: batteryTooltipTimer.running = true
    onExited: {
      batteryTooltipTimer.running = false
      batteryTooltip.visible = false
    }
  }

  Timer {
    id: batteryTooltipTimer
    interval: 500
    repeat: false
    running: false
    onTriggered: batteryTooltip.visible = true
  }

  Tooltip {
    id: batteryTooltip
    implicitHeight: 30

    target: battery
    bgColor: Color.tertiary
    fgColor: Color.ontertiary
    text: {
      let device = UPower.displayDevice
      if (!device.ready) return errorIcon
      if (UPower.onBattery) {
        let emptyHour = device.timeToEmpty / 3600
        return `${emptyHour}h remains`
      } else if (device.timeToFull > 0) {
        let chargeHour = device.timeToFull / 3600
        return `${chargeHour}h before full`
      } else {
        return `Battery full`
      }
    }
  }
}
