import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects

import qs.Commons

Rectangle {
  id: clock
  // anchors.centerIn: parent
  implicitWidth: 120
  implicitHeight: 20
  color: Color.primary
  radius: 16

  property alias bgColor: clock.color
  property alias fgColor: clockText.color
  property alias calBgColor: calendar.bgColor
  property alias calFgColor: calendar.fgColor

  readonly property string time: {
    Qt.formatDateTime(systemClock.date, "hh:mm AP")
  }

  readonly property string datetime: {
    Qt.formatDateTime(systemClock.date, "yyyy-MM-dd hh:mm:ss")
  }

  property string calendarText

  Text {
    id: clockText
    anchors.centerIn: parent
    color: Color.onprimary
    text: `    ${time}`
    font.family: "FreeSans"
    font.pointSize: 9
  }

  MouseArea {
    id: clockMouseArea
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onClicked: {
      if (calendar.persist) {
        calendar.visible = false
      } else {
        if (!calendar.visible) {
          calendar.visible = true
          calendarProc.running = true
        }
      }
      calendar.persist = !calendar.persist
    }
    onEntered: {
      clock.color = Qt.darker(clock.color, 1.2)
      clockHoverTimer.running = true
    }
    onExited: {
      clock.color = Color.primary
      clockHoverTimer.running = false
      if (!calendar.persist) calendar.visible = false
    }
  }

  Timer {
    id: clockHoverTimer
    interval: 500
    running: false
    repeat: false
    onTriggered: {
      calendar.visible = true
      calendarProc.running = true
    }
  }

  Tooltip {
    id: calendar
    implicitWidth: 170
    implicitHeight: 130

    target: clock
    text: ` ${datetime}\n${calendarText}`
    textSize: 8
    textFont: "JetBrainsMonoNerdFont"

    bgColor: Color.secondary
    fgColor: Color.onsecondary

    radius: 8
  }

  Process {
    id: calendarProc
    running: true
    command: ["cal"]
    stdout: StdioCollector {
      onStreamFinished: calendarText = this.text.trim()
    }
  }

  SystemClock {
    id: systemClock
    precision: SystemClock.Seconds
  }
}
