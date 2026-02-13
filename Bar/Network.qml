import Quickshell
import Quickshell.Networking
import QtQuick

import qs.Commons

Rectangle {
  id: network
  implicitWidth: networkIcon.width + networkText.width + 4
  implicitHeight: 15

  color: "transparent"

  // property alias  textColor: networkText.color
  property string wifiIcon: ""
  property string etheIcon: ""
  property string discIcon: ""
  property string upIcon: ""
  property string downIcon: ""

  Text {
    id: networkIcon
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    color: networkText.color
    text: {
      let device = Networking.devices.values[0]
      if (!device) return discIcon
      if (!device.connected) return discIcon
      if (device.type === DeviceType.Wifi) {
        return wifiIcon
      } else {
        return etheIcon
      }
    }
    font.pointSize: 10
    font.family: "FreeSans"
  }

  Text {
    id: networkText
    anchors.left: networkIcon.right
    anchors.verticalCenter: parent.verticalCenter
    color: Color.onsecondary
    text: {
      let device = Networking.devices.values[0]
      if (!device) return " disc"
      if (!device.connected) return " disc"
      return " conn"
    }
    font.pointSize: 8
    font.family: "FreeSans"
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onEntered: networkTooltipTimer.running = true
    onExited: {
      networkTooltipTimer.running = false
      networkTooltip.visible = false
    }
  }

  Timer {
    id: networkTooltipTimer
    interval: 500
    repeat: false
    running: false
    onTriggered: networkTooltip.visible = true
  }

  Tooltip {
    id: networkTooltip
    implicitHeight: 30

    target: network
    text: {
      let device = Networking.devices.values[0]
      if (!device) return "Disconnected"
      if (!device.connected) return "Disconnected"
      let name = device.name
      let address = device.address
      if (device.type === DeviceType.Wifi) {
        let nw = device.networks.values[0]
        if (nw) return `Wifi ${name}(${address}) | ${nw.name}`
        else return `Wifi ${name}(${address})`
      } else {
        return `Ethernet ${name}(${address})`
      }
    }
  }
}
