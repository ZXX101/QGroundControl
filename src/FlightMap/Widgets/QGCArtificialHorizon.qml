/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


/**
 * @file
 *   @brief QGC Artificial Horizon
 *   @author Gus Grubba <gus@auterion.com>
 */

import QtQuick 2.3
import QtGraphicalEffects 1.15
Item {
    id: root
    property real rollAngle :   0
    property real pitchAngle:   0
    clip:           true
    anchors.fill:   parent

    property real angularScale: pitchAngle * root.height / 45

    Item {
        id: artificialHorizon
        width:  root.width  * 4
        height: root.height * 8
        anchors.centerIn: parent
        // 原始渐变色天空背景（已注释，改用自定义图片）
        Rectangle {
            id: sky
            anchors.fill: parent
            smooth: true
            antialiasing: true
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.hsla(0.0, 0.0, 1.0) }
                GradientStop { position: 1; color: Qt.hsla(0.0, 0.0, 0.5) }
            }
        }
        // 原始渐变色地面背景（已注释，改用自定义图片）
        Rectangle {
            id: ground
            height: sky.height / 2
            anchors {
                left:   sky.left;
                right:  sky.right;
                bottom: sky.bottom
            }
            smooth: true
            antialiasing: true
            gradient: Gradient {
                GradientStop { position: 0.0;  color: Qt.hsla(0.0, 0.0, 0.0) }
                GradientStop { position: 0.25; color: Qt.hsla(0.0, 0.0, 0.0) }
            }
        }
        //天空底色（适配半透明图片）
        // Item {
        //     id: skyBackground
        //     anchors.fill: parent
        //     clip: true

        //     RadialGradient {
        //         width: parent.width/2
        //         height: parent.height/2
        //         anchors.horizontalCenter: parent.horizontalCenter
        //         anchors.bottom: parent.bottom
        //         // verticalOffset: -height/2
        //         gradient: Gradient {
        //             GradientStop { position: 0.0;color:"#efefef"}
        //             GradientStop { position: 0.3;color:"#b0b0b0"}
        //             GradientStop { position: 1.0;color:"black"}
        //         }
        //     }
        // }

        // // 使用自定义图片作为天空背景
        // Image {
        //     id: sky
        //     anchors.fill: parent
        //     fillMode: Image.Stretch

        // }
        // // 使用自定义图片作为地面背景
        // Image {
        //     id: ground
        //     height: sky.height / 2
        //     anchors {
        //         left:   sky.left
        //         right:  sky.right
        //         bottom: sky.bottom
        //     }
        //     fillMode: Image.Stretch
        //     source: "qrc:/qmlimages/resources/zxxAttitudeGround.png"
        // }
        transform: [
            Translate {
                y:  angularScale
            },
            Rotation {
                origin.x: artificialHorizon.width  / 2
                origin.y: artificialHorizon.height / 2
                angle:    -rollAngle
            }]
    }
}
