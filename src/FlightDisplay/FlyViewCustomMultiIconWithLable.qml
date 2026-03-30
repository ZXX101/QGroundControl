import QtQuick 2.11
import QtQuick.Layouts 1.11

import QGroundControl 1.0
import QGroundControl.Controls 1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Palette 1.0

Column {
    id: root
    spacing: 4


    property alias iconSource: iconImage.source
    property alias topLabelText: topLabel.text
    property alias bottomLabelText: bottomLabel.text

    Row {
        id:toprow
        spacing: 11
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: iconImage
            width: 32
            height: 32
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
        }

        QGCLabel {
            id: topLabel
            font.pointSize:  ScreenTools.largeFontPointSize

            font.family:            tecentfont.name
            color: "white"
            anchors.verticalCenter: parent.verticalCenter

        }
    }

    // Item { height: 3; width: 1 }

    Rectangle {
        width: toprow.width
        height: 1
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    // Item { height: 3; width: 1 }

    QGCLabel {
        id: bottomLabel
        font.pointSize:  ScreenTools.largeFontPointSize
        font.family:            tecentfont.name
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
