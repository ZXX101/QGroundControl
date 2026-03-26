import QtQuick 2.11
import QtQuick.Layouts 1.11

import QGroundControl 1.0
import QGroundControl.Controls 1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Palette 1.0

Column {
    id: root
    spacing: 4
    width: 200
    height: 200

    property alias iconSource: iconImage.source
    property alias topLabelText: topLabel.text
    property alias bottomLabelText: bottomLabel.text

    Item { height: 20; width: 1 }

    Row {
        spacing: 8
        anchors.horizontalCenter: parent.horizontalCenter
        height: 40

        Image {
            id: iconImage
            width: 32
            height: 32
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
        }

        QGCLabel {
            id: topLabel
            font.pointSize: ScreenTools.mediumFontPointSize
            color: "white"
            anchors.verticalCenter: parent.verticalCenter

        }
    }

    Item { height: 10; width: 1 }

    Rectangle {
        width: parent.width * 0.8
        height: 2
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Item { height: 10; width: 1 }

    QGCLabel {
        id: bottomLabel
        font.pointSize: ScreenTools.mediumFontPointSize
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
