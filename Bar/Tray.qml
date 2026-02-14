import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

import qs.Commons

WrapperRectangle {
  id: tray
  implicitHeight: 20
  leftMargin: 15
  rightMargin: 15
  color: Color.secondary
  radius: 16

  property alias bgColor: tray.color
  property color fgColor: Color.onsecondary

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 6
    anchors.rightMargin: 6
    spacing: 0

    Repeater {
      model: SystemTray.items

      Rectangle {
        id: trayItem
        required property var modelData

        implicitWidth: 18
        implicitHeight: 18
        color: fgColor
        radius: 4

        visible: modelData.status !== Status.Passive

        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

        IconImage {
          anchors.centerIn: parent
          source: modelData.icon
          implicitSize: 16
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
          hoverEnabled: true
          onClicked: mevent => {
            switch (mevent.button) {
              case Qt.LeftButton:
                modelData.activate()
                break
              case Qt.MiddleButton:
                modelData.secondaryActivate()
                break
              case Qt.RightButton:
                let pos = parent.mapToItem(bar.contentItem, 0, 0)
                modelData.display(bar, pos.x + parent.width / 2, pos.y + parent.height / 2)
                break
            }
          }
          onEntered: trayItemTooltipTimer.running = true
          onExited: {
            trayItemTooltipTimer.running = false
            trayItemTooltip.visible = false
          }
        }

        Timer {
          id: trayItemTooltipTimer
          interval: 500
          running: false
          repeat: false
          onTriggered: trayItemTooltip.visible = true
        }

        Tooltip {
          id: trayItemTooltip
          implicitHeight: 30

          target: trayItem
          text: modelData.tooltipTitle || modelData.title
          textSize: 8
          textFont: "JetBrainsMonoNerdFont"
        }
      }
    }
  }
}
