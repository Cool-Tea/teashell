import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.Commons

Rectangle {
  id: workspace
  implicitWidth: 100
  implicitHeight: 20
  color: Color.secondary
  radius: 16

  property alias bgColor: workspace.color
  property color fgColor: Color.onsecondary
  property color actColor: Color.source
  property color useColor: Color.source

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 4
    anchors.rightMargin: 4
    spacing: 0

    Repeater {
      model: 5

      Rectangle {
        id: workspaceRect
        implicitWidth: 9
        implicitHeight: 9
        color: active ? actColor : (used ? useColor : fgColor)
        radius: active ? 2 : 10

        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

        property var ws: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
        readonly property bool active: Hyprland.focusedWorkspace?.id === (index + 1)
        readonly property bool used: ws !== null

        Behavior on color {
          ColorAnimation { duration: 200 }
        }

        Behavior on radius {
          NumberAnimation {
            duration: 200
            easing.type: Easing.InOutCubic
          }
        }

        states: State {
          name: "onHover"
          when: workspaceRectMouseArea.containsMouse
          PropertyChanges {
            workspaceRect {
              radius: 2
              rotation: 45
              color: actColor
            }
          }
        }

        transitions: Transition {
          to: "onHover"
          reversible: true
          ParallelAnimation {
            ColorAnimation {
              duration: 100
              easing.type: Easing.InOutCubic
            }
            RotationAnimation {
              duration: 200
              easing.type: Easing.InOutCubic
            }
            NumberAnimation {
              properties: "radius"
              duration: 50
              easing.type: Easing.InOutCubic
            }
          }
        }

        MouseArea {
          id: workspaceRectMouseArea
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          hoverEnabled: true
          onClicked: Hyprland.dispatch(`workspace ${index + 1}`)
          onEntered: {
            workspaceTooltipTimer.running = true
          }
          onExited: {
            workspaceTooltipTimer.running = false
            workspaceTooltip.visible = false
          }
        }

        Timer {
          id: workspaceTooltipTimer
          interval: 500
          repeat: false
          running: false
          onTriggered: workspaceTooltip.visible = true
        }

        Tooltip {
          id: workspaceTooltip
          // implicitWidth: 30
          implicitHeight: 30

          target: workspaceRect
          text: `${index + 1}`
          textSize: 8
          textFont: "JetBrainsMonoNerdFont"
        }
      }
    }
  }
}
