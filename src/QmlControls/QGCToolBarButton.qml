/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Controls 2.4

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0

// Important Note: Toolbar buttons must manage their checked state manually in order to support
// view switch prevention. This means they can't be checkable or autoExclusive.

Button {
    id:                 button
    height:             ScreenTools.defaultFontPixelHeight * 3
    leftPadding:        _horizontalMargin
    rightPadding:       _horizontalMargin
    implicitWidth: {
            var textWidth = _label.implicitWidth
            var iconWidth = _icon.visible ? _icon.width : 0
            var spacing = _icon.visible ? ScreenTools.defaultFontPixelWidth : 0
            return leftPadding + rightPadding + textWidth + iconWidth + spacing
        }
    checkable:          false

    property bool logo: false
    property bool showIcon: true

    property real _horizontalMargin: ScreenTools.defaultFontPixelWidth

    onCheckedChanged: checkable = false

    background: Rectangle {
        anchors.fill:   parent
        color:          button.checked ? qgcPal.buttonHighlight : Qt.rgba(0,0,0,0)
        border.color:   "red"
        border.width:   QGroundControl.corePlugin.showTouchAreas ? 3 : 0
    }

    contentItem: Item {
        anchors.fill: parent

        QGCColoredImage {
            id:                     _icon
            visible:                showIcon && button.icon.source !== ""
            anchors.left:           parent.left
            anchors.verticalCenter: parent.verticalCenter
            height:                 ScreenTools.defaultFontPixelHeight * 2
            width:                  height*3
            sourceSize.height:      height
            fillMode:               Image.PreserveAspectFit
            color:                  logo ? "transparent" : (button.checked ? qgcPal.buttonHighlightText : qgcPal.buttonText)
            source:                 button.icon.source
        }

        Text {
            id:                     _label
            visible:                text !== ""
            text:                   button.text
            anchors.left:           _icon.visible ? _icon.right : parent.left
            anchors.leftMargin:     _icon.visible ? ScreenTools.defaultFontPixelWidth : 0
            // anchors.right:          parent.right
            anchors.top:            parent.top
            anchors.bottom:         parent.bottom
            font.family:            button.font.family
            font.bold:              button.font.bold
            font.pointSize:         button.font.pointSize
            // font.pixelSize:         height * 0.6
            // fontSizeMode:           Text.Fit
            // minimumPixelSize:       8
            horizontalAlignment:    text == "" ?  Text.AlignHCenter:Text.AlignLeft
            verticalAlignment:      Text.AlignVCenter
            color:                  button.checked ? qgcPal.buttonHighlightText : qgcPal.buttonText
        }
    }
}
