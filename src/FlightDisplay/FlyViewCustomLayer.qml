/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.12
import QtQuick.Controls         2.4
import QtQuick.Dialogs          1.3
import QtQuick.Layouts          1.12

import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Window           2.2
import QtQml.Models             2.1

import QGroundControl               1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0

// To implement a custom overlay copy this code to your own control in your custom code source. Then override the
// FlyViewCustomLayer.qml resource with your own qml. See the custom example and documentation for details.
Item {
    id: _root

    property var parentToolInsets               // These insets tell you what screen real estate is available for positioning the controls in your overlay
    property var totalToolInsets:   _toolInsets // These are the insets for your custom overlay additions
    property var mapControl

    //左侧高度刻度条
    FlyViewCustomAnimMeter {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 80
        height: 300

        //ZTODO::
        // value: vehicle.altitude.rawValue  // 绑定飞行器高度
        minValue: 0
        maxValue: 500
        majorInterval: 100
        minorInterval: 20
        label: "H"
        unit: "m"
    }
    //右侧离家距离刻度条
    FlyViewCustomAnimMeter {
        anchors.right:  unlockButton.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 50
        width: 80
        height: 300

        // value: vehicle.altitude.rawValue  // 绑定飞行器高度
        minValue: 0
        maxValue: 500
        majorInterval: 100
        minorInterval: 20
        label: "D"
        unit: "m"
    }
    //下方左侧上升速度和高度

    //下方右侧水平速度和离家距离

    //右侧三个按钮
    //解锁（演示模式）
    FlyViewUnlockButton {
        id: unlockButton
        width: 60
        height: 60
        anchors.right: parent.right
        anchors.rightMargin:  10
        anchors.bottom: landLunchButton.top
        anchors.bottomMargin: 10
        totalDuration: 3000  // 3秒

        onStarted: console.log("开始长按解锁")
        onCancelled: console.log("取消解锁")
        onCompleted: {
            console.log("解锁完成")
            // 执行解锁逻辑
        }
    }

    //起飞/降落按钮
    FlyViewCustomButton {
        id: landLunchButton
        width: 60
        height: 60
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin:  10
        image1: "qrc:/qmlimages/resources/customFlyviewOverLay/起飞-1.png"
        image2: "qrc:/qmlimages/resources/customFlyviewOverLay/降落-1.png"

        onClicked: {
            console.log("起飞降落按钮点击：",checked)

        }
    }


    //返航按钮
    FlyViewCustomButton {
        id: gohomeButton
        width: 60
        height: 60
        anchors.right: parent.right
        anchors.top: landLunchButton.bottom
        anchors.rightMargin:  10
        anchors.topMargin: 10
        image1: "qrc:/qmlimages/resources/customFlyviewOverLay/返回-1.png"
        image2: "qrc:/qmlimages/resources/customFlyviewOverLay/返回-1.png"

        onClicked: {
            console.log("返航按钮点击：",checked)

        }
    }

    // since this file is a placeholder for the custom layer in a standard build, we will just pass through the parent insets
    QGCToolInsets {
        id:                     _toolInsets
        leftEdgeTopInset:       parentToolInsets.leftEdgeTopInset
        leftEdgeCenterInset:    parentToolInsets.leftEdgeCenterInset
        leftEdgeBottomInset:    parentToolInsets.leftEdgeBottomInset
        rightEdgeTopInset:      parentToolInsets.rightEdgeTopInset
        rightEdgeCenterInset:   parentToolInsets.rightEdgeCenterInset
        rightEdgeBottomInset:   parentToolInsets.rightEdgeBottomInset
        topEdgeLeftInset:       parentToolInsets.topEdgeLeftInset
        topEdgeCenterInset:     parentToolInsets.topEdgeCenterInset
        topEdgeRightInset:      parentToolInsets.topEdgeRightInset
        bottomEdgeLeftInset:    parentToolInsets.bottomEdgeLeftInset
        bottomEdgeCenterInset:  parentToolInsets.bottomEdgeCenterInset
        bottomEdgeRightInset:   parentToolInsets.bottomEdgeRightInset
    }
}
