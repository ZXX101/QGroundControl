// FlyViewUnlockButton.qml
import QtQuick 2.12
import QGroundControl 1.0
import QGroundControl.Palette 1.0
import QGroundControl.ScreenTools 1.0
Item {
    id: root
    width: 60
    height: 60

    signal completed()
    signal started()
    signal cancelled()

    property int totalDuration: 3000
    property int frameCount: 121  // 00000~00120 共121帧

    property bool _isPressed: false
    property bool _isCompleted: false
    property real _progress: 0
    property int _currentFrame: 0

    //圆角和背景
    property real cornerRadius: 8
    property color borderColor: "white"
    property int borderWidth: 1
    property color backgroundColor: "black"

    QGCPalette { id: qgcPal }

    Rectangle {
        id:background
        anchors.fill:  parent
        radius:root.cornerRadius
        color: root.backgroundColor
        border.color: root.borderColor
        border.width: root.borderWidth

    }

    // 默认状态图片（锁定）
    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "qrc:/qmlimages/resources/customFlyviewOverLay/locked.png"
        visible: _isCompleted ? false:true
        z: 0
    }

    // 完成状态图片（解锁）
    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "qrc:/qmlimages/resources/customFlyviewOverLay/unlocked.png"
        visible: _isCompleted
        z: 2
    }

    // 动画帧图片
    Image {
        id: animationFrame
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        visible: _isPressed && !_isCompleted
        z: 1
        // 5位零填充帧号：按钮开_00000.png ~ 按钮开_00120.png
        source: "qrc:/FlyViewUnlockButtonPNGSeq/resources/unlockAnime/按钮开_" +
                _currentFrame.toString().padStart(5, '0') + ".png"
    }

    // 进度动画
    NumberAnimation on _progress {
        id: progressAnimation
        running: false
        from: 0
        to: 1
        duration: root.totalDuration
        onFinished: {
            root._isCompleted = true
            root.completed()
        }
    }

    // 帧号随进度更新
    on_ProgressChanged: {
        _currentFrame = Math.floor(_progress * (frameCount - 1))
    }

    MouseArea {
        anchors.fill: parent

        onPressed: {
            if (root._isCompleted) {
                root._isCompleted = false
            }
            root._isPressed = true
            root._progress = 0
            progressAnimation.start()
            root.started()
        }

        onReleased: {
            if (!root._isCompleted) {
                progressAnimation.stop()
                root._progress = 0
                root._isPressed = false
                root.cancelled()
            }
        }

        onCanceled: {
            if (!root._isCompleted) {
                progressAnimation.stop()
                root._progress = 0
                root._isPressed = false
            }
        }
    }

    function reset() {
        progressAnimation.stop()
        root._progress = 0
        root._currentFrame = 0
        root._isPressed = false
        root._isCompleted = false
    }
}
