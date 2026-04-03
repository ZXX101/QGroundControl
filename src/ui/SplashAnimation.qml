import QtQuick 2.12
import QtQuick.Window 2.11

Item {
    id: root
    
    signal animationFinished()
    
    property int totalDuration: 4500
    property int frameCount: 150
    property int startFrame: 60
    property real _progress: 0
    property int _currentFrame: startFrame
    
    Rectangle {
        anchors.fill: parent
        color: "black"
        
        Image {
            id: animationFrame
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            width: parent.width
            height: parent.height
            source: "qrc:/flyviewUnlockBtnAnimSeq/resources/AnimOpenApp/AnimOpenApp_" +
                    _currentFrame.toString().padStart(5, '0') + ".png"
        }
    }
    
    NumberAnimation on _progress {
        id: progressAnimation
        running: false
        from: 0
        to: 1
        duration: root.totalDuration
        onFinished: {
            root.animationFinished()
        }
    }
    
    on_ProgressChanged: {
        _currentFrame = startFrame + Math.floor(_progress * (frameCount - 1))
    }
    
    function start() {
        _progress = 0
        _currentFrame = startFrame
        progressAnimation.start()
    }
    
    function stop() {
        progressAnimation.stop()
    }
}