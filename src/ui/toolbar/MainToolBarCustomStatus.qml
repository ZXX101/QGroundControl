import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.15

import QGroundControl 1.0
import QGroundControl.Controls 1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Palette 1.0
import QGroundControl.MultiVehicleManager 1.0

RowLayout {
    id: root
    // spacing: ScreenTools.defaultFontPixelWidth

    anchors.bottomMargin:   1
    anchors.top:            parent.top
    anchors.bottom:         parent.bottom
    spacing:                ScreenTools.defaultFontPixelWidth / 2


    signal motorTestSettingChanged(int throttleVal,int times)

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property bool _isReturning: _activeVehicle ? (_activeVehicle.flightMode === _activeVehicle.rtlFlightMode || _activeVehicle.flightMode === _activeVehicle.smartRTLFlightMode) : false

    // 卫星阈值配置
    property int gpsThreshold: 6
    property string gpsIconGood: "qrc:/qmlimages/resources/customFlyviewOverLay/gpsgood.png"
    property string gpsIconBad: "qrc:/qmlimages/resources/customFlyviewOverLay/gpsbad.png"
    property color gpsColorGood: "white"
    property color gpsColorBad: "red"

    // 电池阈值配置（电压，单位V）
    property real voltageThreshold: 10.5
    property string batteryIconGood: "qrc:/qmlimages/resources/customFlyviewOverLay/voltagegood.png"
    property string batteryIconBad: "qrc:/qmlimages/resources/customFlyviewOverLay/voltagebad.png"
    property color batteryColorGood: "white"
    property color batteryColorBad: "red"

    // 返航状态标签 + 分隔符
    // QGCLabel {
    //     text: qsTr("返航中")
    //     color: "orange"
    //     font.bold: true
    //     font.pointSize: ScreenTools.mediumFontPointSize
    //     visible: _isReturning
    //     anchors.verticalCenter: parent.verticalCenter
    // }

    MainStatusIndicator {
        Layout.preferredHeight: root.height
        visible:                currentToolbar === flyViewToolbar
        // visible: false
    }


    Rectangle {
        width: 1
        height: parent.height * 0.6
        color: qgcPal.text
        // visible: _isReturning
        // anchors.verticalCenter: parent.verticalCenter
    }

    // 卫星图标 + 数量
    Item {
        width: gpsIcon.width + gpsValue.width + ScreenTools.defaultFontPixelWidth / 2
        height: parent.height
        visible: _activeVehicle

        property int _gpsCount: _activeVehicle ? _activeVehicle.gps.count.value : 0
        property bool _isGood: _gpsCount >= gpsThreshold

        QGCColoredImage {
            id: gpsIcon
            width: height
            height: parent.height * 0.6
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            source: parent._isGood ? gpsIconGood : gpsIconBad
            fillMode: Image.PreserveAspectFit
            // color: parent._isGood ? gpsColorGood : gpsColorBad
        }

        QGCLabel {
            id: gpsValue
            anchors.left: gpsIcon.right
            anchors.leftMargin: ScreenTools.defaultFontPixelWidth / 4
            anchors.verticalCenter: parent.verticalCenter
            text: parent._gpsCount.toString()
            color: parent._isGood ? gpsColorGood : gpsColorBad
            font.pointSize: ScreenTools.mediumFontPointSize
        }
    }

    // 分隔符
    Rectangle {
        width: 1
        height: parent.height * 0.6
        color: qgcPal.text
        // visible: _activeVehicle
        // anchors.verticalCenter: parent.verticalCenter
    }

    // 电池图标 + 电压
    Item {
        width: batteryIcon.width + batteryValue.width + ScreenTools.defaultFontPixelWidth / 2
        height: parent.height
        visible: _activeVehicle && _activeVehicle.batteries.count > 0

        property real _voltage: _activeVehicle && _activeVehicle.batteries.count > 0 ? _activeVehicle.batteries.get(0).voltage.rawValue : 0
        property bool _isGood: _voltage >= voltageThreshold

        QGCColoredImage {
            id: batteryIcon
            width: height
            height: parent.height * 0.6
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            source: parent._isGood ? batteryIconGood : batteryIconBad
            fillMode: Image.PreserveAspectFit
            // color: parent._isGood ? batteryColorGood : batteryColorBad
        }

        QGCLabel {
            id: batteryValue
            anchors.left: batteryIcon.right
            anchors.leftMargin: ScreenTools.defaultFontPixelWidth / 4
            anchors.verticalCenter: parent.verticalCenter
            text: parent._voltage.toFixed(1) + "V"
            color: parent._isGood ? batteryColorGood : batteryColorBad
            font.pointSize: ScreenTools.mediumFontPointSize
        }
    }

    // 分隔符
    Rectangle {
        width: 1
        height: parent.height * 0.6
        color: qgcPal.text
        visible: _activeVehicle
        // anchors.verticalCenter: parent.verticalCenter
    }

    // 日期时间
    QGCLabel {
        id: datetimeLabel
        text: Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss")
        color: qgcPal.text
        font.pointSize: ScreenTools.mediumFontPointSize
        // font.family: tecentfont.name
        // anchors.verticalCenter: parent.verticalCenter

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: parent.text = Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss")
        }
        MouseArea {
            id: hidedMotorTestSetupButton
            anchors.fill: parent

            onClicked: {

                motorTestSetupDialog.open()
            }
        }
    }

    //打开电机测试界面的隐藏按钮
    //放在maintoolbar的时间标签上



    Dialog {
        id: motorTestSetupDialog
        title: "电机测试参数设置"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        GridLayout {
            anchors.fill: parent
            anchors.margins: 10
            columnSpacing: 10
            rowSpacing: 16
            columns: 2  // 两列布局：标签 | 控件
            Text {
                text: "油门（%）："
                verticalAlignment: Text.AlignVCenter
            }

            SpinBox {
                id: throttleVal
                width: 90
                from: 0
                to:15
                value: 0
            }

            Text {
                text: "时间（秒）："
                verticalAlignment: Text.AlignVCenter
            }

            SpinBox {
                id: continueTimeVal
                from:1
                to:60*60*12
                width: 90
                value: 600
            }
        }


        onAccepted: {
            console.log("设置参数",throttleVal.value,continueTimeVal.value)
            globals.motorTestThrottle = throttleVal.value
            globals.motorTestTime = continueTimeVal.value  // 注意拼写
            // globals.motorTestSettingReceived(throttleVal.value, continueTimeVal.value)

        }


    }

    QGCPalette { id: qgcPal }
}
