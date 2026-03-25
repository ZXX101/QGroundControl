import QtQuick 2.11

Item {
    id: root
    width: 60
    height: 60

    signal clicked()

    property alias image1: image1.source
    property alias image2: image2.source
    property bool checked: false
    property real cornerRadius: 8
    property color borderColor: "white"
    property int borderWidth: 1
    property color backgroundColor: "black"

    Rectangle {
        id: background
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.backgroundColor
        border.color: root.borderColor
        border.width: root.borderWidth
    }

    Image {
        id: image1
        anchors.fill: parent
        anchors.margins: 4
        fillMode: Image.PreserveAspectFit
        visible: !root.checked
    }

    Image {
        id: image2
        anchors.fill: parent
        anchors.margins: 4
        fillMode: Image.PreserveAspectFit
        visible: root.checked
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            root.checked = !root.checked
            root.clicked()
        }
    }
}
