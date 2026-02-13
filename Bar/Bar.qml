import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.Commons

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      id: bar
      implicitHeight: 30
      color: Color.background

      property string position: "top"

      anchors {
        top: position !== "bottom"
        bottom: position !== "top"
        left: position !== "right"
        right: position !== "left"
      }

      margins {
        top: 0
        left: 0
        bottom: 0
        right: 0
      }

      RowLayout {
        id: barLeft
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        // anchors.right: barCenter.left
        spacing: 0

        Item { width: 12 }

        Workspace { 
          id: workspace
        }

        Item { width: 12 }

        WinTitle {
          id: winTitle
        }
      }

      RowLayout {
        id: barCenter
        anchors.centerIn: parent
        spacing: 0

        Clock { 
          id: clock
          // bgColor: Color.primary
          // fgColor: Color.onprimary
          // calBgColor: Color.secondary
          // calFgColor: Color.onsecondary
        }
      }

      RowLayout {
        id: barRight
        anchors.verticalCenter: parent.verticalCenter
        // anchors.left: barCenter.right
        anchors.right: parent.right
        spacing: 0
        layoutDirection: Qt.RightToLeft

        Item { width: 12 }

        Tray {
          id: tray
        }

        Item { width: 12 }

        // System Info
        WrapperRectangle { 
          implicitHeight: 20
          leftMargin: 10
          rightMargin: 10
          color: Color.secondary
          radius: 16

          RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 4
            spacing: 0
            layoutDirection: Qt.RightToLeft

            Battery {
              id: battery
              Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            }

            Backlight {
              id: backlight
              Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            }

            Audio {
              id: audio
              Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            }

            Network {
              id: network
              Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            } 
          }
        }
      }
    }
  }
}
