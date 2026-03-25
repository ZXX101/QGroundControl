import QtQuick 2.11
import QtQuick.Controls 2.4

import QGroundControl 1.0
import QGroundControl.Palette 1.0
import QGroundControl.ScreenTools 1.0

Item {
    id: root
    width: 80
    height: 300

    property real value: 0
    property real minValue: 0
    property real maxValue: 500
    property real majorInterval: 100
    property real minorInterval: 20
    property string unit: "m"
    property string label: "ALT"

    property real _pixelsPerUnit: flickable.height / (maxValue - minValue + visibleRange)
    property real visibleRange: 100

    QGCPalette { id: qgcPal }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.6)
        radius: 4
    }

    Flickable {
        id: flickable
        anchors.left: parent.left
        anchors.right: valueLabel.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 4

        contentWidth: width
        contentHeight: rulerCanvas.height
        contentY: _contentY

        property real _contentY: -(value - minValue) * _pixelsPerUnit + height / 2

        clip: true
        interactive: false

        Canvas {
            id: rulerCanvas
            width: parent.width
            height: (maxValue - minValue + root.visibleRange) * _pixelsPerUnit
            y: -(root.visibleRange / 2) * _pixelsPerUnit

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                ctx.fillStyle = "white"
                ctx.font = ScreenTools.defaultFontPointSize + "px sans-serif"

                var startX = 10
                var majorX = width - 40
                var minorX = width - 25

                for (var v = minValue - root.visibleRange; v <= maxValue + root.visibleRange; v += minorInterval) {
                    var y = (v - (minValue - root.visibleRange)) * _pixelsPerUnit

                    var isMajor = (v % majorInterval === 0)

                    if (isMajor && v >= minValue && v <= maxValue) {
                        ctx.strokeStyle = "white"
                        ctx.lineWidth = 2
                        ctx.beginPath()
                        ctx.moveTo(startX, y)
                        ctx.lineTo(majorX, y)
                        ctx.stroke()

                        ctx.fillStyle = "white"
                        ctx.textAlign = "right"
                        ctx.fillText(v.toString(), width - 5, y + 4)
                    } else if (v >= minValue && v <= maxValue) {
                        ctx.strokeStyle = "#888888"
                        ctx.lineWidth = 1
                        ctx.beginPath()
                        ctx.moveTo(startX, y)
                        ctx.lineTo(minorX, y)
                        ctx.stroke()
                    }
                }
            }

            Connections {
                target: root
                onMinValueChanged: rulerCanvas.requestPaint()
                onMaxValueChanged: rulerCanvas.requestPaint()
                onMajorIntervalChanged: rulerCanvas.requestPaint()
                onMinorIntervalChanged: rulerCanvas.requestPaint()
            }
        }
    }

    Rectangle {
        id: centerIndicator
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width - valueLabel.width - 12
        height: 3
        color: "#00ff00"
        radius: 1
    }

    Rectangle {
        id: valueLabel
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 50
        height: 30
        color: "#00ff00"
        radius: 4

        Text {
            anchors.centerIn: parent
            text: Math.round(value)
            color: "black"
            font.bold: true
            font.pointSize: ScreenTools.defaultFontPointSize
        }
    }

    Text {
        id: titleLabel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 4
        text: label
        color: "white"
        font.pointSize: ScreenTools.smallFontPointSize
    }

    Text {
        id: unitLabel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        text: unit
        color: "white"
        font.pointSize: ScreenTools.smallFontPointSize
    }

    onValueChanged: {
        rulerCanvas.requestPaint()
    }
}
