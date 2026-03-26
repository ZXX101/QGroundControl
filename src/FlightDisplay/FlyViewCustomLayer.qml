

/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/
import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QGroundControl.Controls 1.0
import QGroundControl.FactSystem 1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap 1.0
import QGroundControl.Palette 1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Vehicle 1.0
import QtLocation 5.3
import QtPositioning 5.3
import QtQml.Models 2.1
import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import QtQuick.Window 2.2

// To implement a custom overlay copy this code to your own control in your custom code source. Then override the
// FlyViewCustomLayer.qml resource with your own qml. See the custom example and documentation for details.
Item {
    id: _root

    property var parentToolInsets
    // These insets tell you what screen real estate is available for positioning the controls in your overlay
    property var totalToolInsets: _toolInsets // These are the insets for your custom overlay additions
    property var mapControl
    // 保存 actuatorTest 引用供 Timer 使用
    property var _currentActuatorTest: null

    function mapPercentToValue(actuator, percent) {
        if (percent === 0)
            return actuator.defaultValue

        return actuator.min + (actuator.max - actuator.min) * (percent / 100)
    }

    // 获取 actuatorTest 的函数
    function getActuatorTest() {
        if (!globals.activeVehicle)
            return null

        var actuators = globals.activeVehicle.actuators
        if (!actuators)
            return null

        return actuators.actuatorTest
    }

    Timer {
        id: motorTestRefreshTimer

        interval: 50
        repeat: true
        running: false
        onTriggered: {
            if (_currentActuatorTest
                    && _currentActuatorTest.actuators.count > 0) {
                for (var i = 0; i < _currentActuatorTest.actuators.count; i++) {
                    var actuator = _currentActuatorTest.actuators.get(i)
                    if (actuator.isMotor) {
                        var value = mapPercentToValue(actuator,
                                                      globals.motorTestThrottle)
                        _currentActuatorTest.setChannelTo(i, value)
                    }
                }
            }
        }
    }

    Timer {
        id: motorTestCommandTimer

        interval: 50
        repeat: true
        running: false
        property int remainingTime: 0
        property int currentMotor: 1
        property int motorCount: 4
        onTriggered: {
            if (globals.activeVehicle && remainingTime > 0) {
                globals.activeVehicle.motorTest(currentMotor, globals.motorTestThrottle, 1, true)
                currentMotor++
                if (currentMotor > motorCount) {
                    currentMotor = 1
                }
                remainingTime -= interval
                if (remainingTime <= 0) {
                    stop()
                    console.log("motorTest 定时器结束")
                }
            }
        }
    }

    Timer {
        id: motorTestShowSpeed

        interval: 200
        repeat: true
        running: false
        onTriggered: {
            if (globals.activeVehicle && globals.activeVehicle.servoOutput) {
                var servo1 = globals.activeVehicle.servoOutput.servo1Raw ? globals.activeVehicle.servoOutput.servo1Raw.rawValue : 0
                var servo2 = globals.activeVehicle.servoOutput.servo2Raw ? globals.activeVehicle.servoOutput.servo2Raw.rawValue : 0
                var servo3 = globals.activeVehicle.servoOutput.servo3Raw ? globals.activeVehicle.servoOutput.servo3Raw.rawValue : 0
                var servo4 = globals.activeVehicle.servoOutput.servo4Raw ? globals.activeVehicle.servoOutput.servo4Raw.rawValue : 0

                console.log("Servo Output (PWM us) - S1:", servo1, "S2:", servo2, "S3:", servo3, "S4:", servo4)
            }
        }
    }

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
        anchors.right: unlockButton.left
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

    //右侧三个按钮
    //解锁（演示模式）
    FlyViewUnlockButton {
        id: unlockButton

        width: 60
        height: 60
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: lockButton.top
        anchors.bottomMargin: 10
        totalDuration: 3000 // 3秒
        onStarted: {
            console.log("开始长按解锁")
            console.log("电机参数为：油门：", globals.motorTestThrottle, "时间：",
                        globals.motorTestTime)
        }
        onCancelled: console.log("取消解锁")
        onCompleted: {
            ///
            // console.log("=== 电机测试调试 ===");
            // console.log("globals:", globals);
            // console.log("globals.activeVehicle:", globals ? globals.activeVehicle : "globals is null");
            // console.log("globals.activeVehicle.actuators:", globals && globals.activeVehicle ? globals.activeVehicle.actuators : "N/A");
            // console.log("_actuators:", _actuators);
            // console.log("_actuatorTest:", _actuatorTest);
            // console.log("_actuatorTest.actuators.count:", _actuatorTest ? _actuatorTest.actuators.count : "N/A");
            // console.log("===================");
            ///
            var actuatorTest = getActuatorTest()
            console.log("actuatorTest:", actuatorTest)
            if (actuatorTest)
                console.log("actuatorTest.actuators.count:",
                            actuatorTest.actuators ? actuatorTest.actuators.count : "N/A")

            if (actuatorTest && actuatorTest.actuators
                    && actuatorTest.actuators.count > 0) {
                console.log("使用新版 actuators API")
                _currentActuatorTest = actuatorTest
                actuatorTest.setActive(true)
                motorTestRefreshTimer.start()
                motorTestShowSpeed.start()
            } else if (globals.activeVehicle) {
                console.log("使用旧版 motorTest API")
                var mCount = globals.activeVehicle.motorCount
                        > 0 ? globals.activeVehicle.motorCount : 4
                console.log("motorCount:", mCount, ", throttle:", globals.motorTestThrottle + "%", ", duration:", globals.motorTestTime + "s")
                motorTestCommandTimer.motorCount = mCount
                motorTestCommandTimer.currentMotor = 1
                motorTestCommandTimer.remainingTime = globals.motorTestTime * 1000
                motorTestCommandTimer.start()
                motorTestShowSpeed.start()
            } else {
                console.log("电机测试：未连接飞行器")
            }
        }
    }

    //停止电机测试
    FlyViewCustomButton {
        id: lockButton

        width: 60
        height: 60
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: layBtnlocation.top
        anchors.bottomMargin: 10
        image1: "qrc:/qmlimages/resources/customFlyviewOverLay/起飞-1.png"
        image2: "qrc:/qmlimages/resources/customFlyviewOverLay/降落-1.png"
        onClicked: {
            console.log("停止电机测试")
            unlockButton.reset()
            motorTestRefreshTimer.stop()
            motorTestCommandTimer.stop()
            var actuatorTest = getActuatorTest()
            if (actuatorTest) {
                actuatorTest.stopControl(-1)
                actuatorTest.setActive(false)
                motorTestShowSpeed.stop()
            } else if (globals.activeVehicle) {
                var motorCount = globals.activeVehicle.motorCount
                        > 0 ? globals.activeVehicle.motorCount : 4
                for (var i = 1; i <= motorCount; i++) {
                    globals.activeVehicle.motorTest(i, 0, 0, true)
                }
                motorTestShowSpeed.stop()
            }
            _currentActuatorTest = null
        }
    }

    Item {
        id: layBtnlocation

        width: 0
        height: 0
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    }

    //起飞/降落按钮
    FlyViewCustomButton {
        id: landLunchButton

        width: 60
        height: 60
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: layBtnlocation.bottom
        anchors.topMargin: 10
        image1: "qrc:/qmlimages/resources/customFlyviewOverLay/起飞-1.png"
        image2: "qrc:/qmlimages/resources/customFlyviewOverLay/降落-1.png"
        onClicked: {
            console.log("起飞降落按钮点击：" + checked ? "起飞" : "降落")
        }
    }

    //返航按钮
    FlyViewCustomButton {
        id: gohomeButton

        width: 60
        height: 60
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: landLunchButton.bottom
        anchors.topMargin: 10
        image1: "qrc:/qmlimages/resources/customFlyviewOverLay/返回-1.png"
        image2: "qrc:/qmlimages/resources/customFlyviewOverLay/返回-1.png"
        onClicked: {
            console.log("返航按钮点击")
        }
    }

    // since this file is a placeholder for the custom layer in a standard build, we will just pass through the parent insets
    QGCToolInsets {
        id: _toolInsets

        leftEdgeTopInset: parentToolInsets.leftEdgeTopInset
        leftEdgeCenterInset: parentToolInsets.leftEdgeCenterInset
        leftEdgeBottomInset: parentToolInsets.leftEdgeBottomInset
        rightEdgeTopInset: parentToolInsets.rightEdgeTopInset
        rightEdgeCenterInset: parentToolInsets.rightEdgeCenterInset
        rightEdgeBottomInset: parentToolInsets.rightEdgeBottomInset
        topEdgeLeftInset: parentToolInsets.topEdgeLeftInset
        topEdgeCenterInset: parentToolInsets.topEdgeCenterInset
        topEdgeRightInset: parentToolInsets.topEdgeRightInset
        bottomEdgeLeftInset: parentToolInsets.bottomEdgeLeftInset
        bottomEdgeCenterInset: parentToolInsets.bottomEdgeCenterInset
        bottomEdgeRightInset: parentToolInsets.bottomEdgeRightInset
    }
}
