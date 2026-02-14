import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.Commons

WrapperRectangle {
  id: winTitle
  implicitHeight: 20
  leftMargin: 10
  rightMargin: 10
  color: Color.tertiary
  radius: 16

  property alias bgColor: winTitle.color
  property color fgColor: Color.ontertiary
  property color actColor: Color.source
  property int   maxWidth: 200

  RowLayout {
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.leftMargin: 6
    anchors.rightMargin: 4
    spacing: 2

    Repeater {
      model: ToplevelManager.toplevels

      Rectangle {
        id: winIcon
        required property var modelData

        implicitWidth: active ? 30 : 15
        implicitHeight: 15
        color: active ? actColor : "transparent"
        radius: 10

        Layout.alignment: Qt.AlignVCenter

        readonly property bool active: modelData.activated

        Behavior on implicitWidth {
          NumberAnimation {
            duration: 200
            easing.type: Easing.InOutCubic
          }
        }

        Behavior on color {
          ColorAnimation { duration: 200 }
        }

        states: State {
          name: "onHover"
          when: winIconMouseArea.containsMouse
          PropertyChanges {
            winIcon {
              implicitWidth: 30
              color: actColor
            }
          }
        }

        transitions: Transition {
          to: "onHover"
          reversible: true
          ParallelAnimation {
            ColorAnimation {
              duration: 50
              easing.type: Easing.InOutCubic
            }
            NumberAnimation {
              properties: "implicitWidth"
              duration: 200
              easing.type: Easing.InOutCubic
            }
          }
        }

        IconImage {
          anchors.centerIn: parent
          source: Quickshell.iconPath(modelData.appId)
          implicitSize: 16
        }

        MouseArea {
          id: winIconMouseArea
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          hoverEnabled: true
          onClicked: modelData.activate()
          onEntered: winTooltipTimer.running = true
          onExited: {
            winTooltipTimer.running = false
            winTooltip.visible = false
          }
        }

        Timer {
          id: winTooltipTimer
          interval: 500
          running: false
          repeat: false
          onTriggered: winTooltip.visible = true
        }

        Tooltip {
          id: winTooltip
          implicitHeight: 30

          target: winIcon
          bgColor: Color.tertiary
          fgColor: Color.ontertiary
          text: modelData.title
          textSize: 8
          textFont: "JetBrainsMonoNerdFont"
        }
      }
    }

    Text {
      text: "|"
      color: fgColor
      Layout.alignment: Qt.AlignVCenter
      font.pointSize: 8
      font.family: "JetBrainsMonoNerdFont"
    }

    Text {
      text: {
        let toplevels = ToplevelManager.toplevels
        let actTop = ToplevelManager.activeToplevel
        if (!actTop) return ""
        let toplevelLen = toplevels.values.length
        let titleLen = actTop.title ? actTop.title.length : 0
        let totalLen = toplevelLen * 15 + 40 + titleLen * 8
        let title = actTop.title
        if (totalLen > maxWidth) {
          titleLen = Math.floor((maxWidth - toplevelLen * 15 - 40) / 8)
          title = title.slice(0, titleLen) + "..."
        }
        return title
      }
      color: fgColor
      Layout.alignment: Qt.AlignVCenter
      font.pointSize: 8
      font.family: "JetBrainsMonoNerdFont"
    }
  }
}
