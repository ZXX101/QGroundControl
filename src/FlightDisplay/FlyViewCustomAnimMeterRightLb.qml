/**
 * @file FlyViewCustomAnimMeter.qml
 * @brief 自定义动画仪表组件（ListView实现）
 * 
 * 本组件实现了一个垂直滚动的仪表显示，类似于飞行器的高度计或速度计。
 * 刻度会随着数值变化而平滑滚动，中间的绿色指示条固定显示当前值。
 * 
 * 设计方案：使用ListView实现刻度渲染
 * - 只渲染可见区域内的刻度项，性能优异
 * - 自动回收不可见的delegate，内存占用低
 * - 支持动态范围更新，无需重绘整个Canvas
 * - topValue显示在上方，bottomValue显示在下方
 * 
 * 使用示例：
 * @code
 * FlyViewCustomAnimMeter {
 *     value: 50           // 当前值
 *     topValue: 90        // 上方最大值
 *     bottomValue: -90    // 下方最小值
 *     majorInterval: 30   // 主刻度间隔
 *     minorInterval: 10   // 次刻度间隔
 *     label: "PITCH"      // 仪表标签
 *     unit: "°"           // 单位
 * }
 * @endcode
 */

import QtQuick 2.11
import QtQuick.Controls 2.4

/**
 * @brief 自定义动画仪表根组件
 * 
 * 使用ListView实现刻度渲染，只绘制可见区域的刻度线，
 * 通过调整contentY实现刻度随数值滚动。
 */
Item {
    id: root
    width: 80
    height: 300

    //范围示意框
    // Rectangle {
    //     anchors.fill: root
    //     border.width: 2
    //     border.color: "black"
    //     color:"transparent"
    // }

    // ==================== 公共属性 ====================
    
    /** @brief 当前显示的数值 */
    property real value: 0
    
    /** @brief 刻度表上方显示的值（大值） */
    property real biggerValue: 90
    
    /** @brief 刻度表下方显示的值（小值） */
    property real smallerValue: -90
    
    /** @brief 主刻度间隔（带数值标注的刻度线） */
    property real majorInterval: 100

    //中刻度间隔(二分之一主刻度间隔）
    // property real mediumInterval: 50
    
    /** @brief 次刻度间隔（无标注的细分刻度线） */
    property real minorInterval: 20

    property string prefix: "H"
    
    /** @brief 数值单位（如"m"表示米，"km/h"表示公里每小时） */
    property string unit: "m"
    
    /** @brief 仪表标签（如"ALT"表示高度，"SPD"表示速度） */
    property string label: "ALT"
    
    /** @brief 字体族名称（由外部FontLoader提供） */
    property string fontFamily: ""
    
    /** @brief 默认字体大小（用于数值显示） */
    property real defaultFontPointSize: 12
    
    /** @brief 小字体大小（用于标签和单位） */
    property real smallFontPointSize: 5

    // ==================== 内部计算属性 ====================
    
    /**
     * @brief 刻度值列表模型
     * 
     * 从topValue到bottomValue递减生成，确保大值在上方，小值在下方。
     */
    property var tickModel: {
        console.log("[INFO] 调用model")
        console.log("[INFO] topValue:",biggerValue,"bottomValue",smallerValue)
        var ticks = []
        // 从topValue向下对齐到minorInterval的整数倍
        var startTick = Math.floor(biggerValue / minorInterval) * minorInterval
        for (var v = startTick; v >= smallerValue; v -= minorInterval) {
            ticks.push(v)
        }
        return ticks
    }
    
    /**
     * @brief 可见范围内的数值单位数
     * 
     * 动态计算为刻度范围，确保所有刻度都能显示。
     */
    property real visibleUnits: Math.max(biggerValue - smallerValue, 50)
    
    /**
     * @brief 每单位数值对应的像素高度
     */
    property real _pixelsPerUnit: 1
    
    /**
     * @brief 单个刻度项的高度
     */
    property real tickHeight: Math.max(minorInterval * _pixelsPerUnit, 1)

    //字体大小
    property int fontpointsize: 15

    // ==================== 数值显示框 ====================
    
    /**
     * @brief 当前数值显示框
     * 
     * 位于组件右侧中央的透明边框框，显示当前数值的整数部分。
     * //TODO:设置文本中心对齐到root的verticalCenter
     */
    Rectangle {
        id: valueLable
        anchors.left: tickListView.right
        // anchors.left: prefixLabel.right

        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width/2
        height: 30
        color: "transparent"
        //范围示意框
        // Rectangle {
        //     anchors.fill: valueLable
        //     border.width: 2
        //     border.color: "red"
        //     color:"transparent"
        // }
        FontMetrics {
            id: fontMetrics
            font: valueLableText.font
        }
        Text {
            id:valueLableText
            // anchors.centerIn: parent
            anchors.baseline: parent.verticalCenter
            anchors.baselineOffset: -(fontMetrics/2)+fontMetrics.descent
            anchors.horizontalCenter: parent.horizontalCenter
            text: prefix + " "+ Math.round(value) + unit
            // text:  value.toFixed(1) + unit
            color: "#ffffff"
            font.bold: true
            width: 70
            horizontalAlignment:  Text.AlignHCenter
            // verticalAlignment: Text.AlignVCenter
            font.pointSize: fontpointsize
            font.family: fontFamily
            style: Text.Outline
            styleColor: "black"

        }
    }

    // Rectangle {
    //     id: prefixLabel
    //     anchors.left: tickListView.right
    //     anchors.verticalCenter: parent.verticalCenter
    //     width: 40
    //     height: 30
    //     color: "transparent"
    //     FontMetrics {
    //         id: fontMetrics1
    //         font: prefixLabelText.font
    //     }
    //     z:2
    //     Text {
    //         id:prefixLabelText
    //         anchors.baseline: parent.verticalCenter
    //         anchors.baselineOffset: -(fontMetrics1/2)+fontMetrics1.descent
    //         anchors.horizontalCenter: parent.horizontalCenter
    //         // text: prefix + " "+ Math.round(value) + unit
    //         text: prefix
    //         color: "#00ff00"
    //         font.bold: true
    //         width: 70
    //         horizontalAlignment:  Text.AlignLeft
    //         // verticalAlignment: Text.AlignVCenter
    //         font.pointSize: fontpointsize
    //         font.family: fontFamily
    //         style: Text.Outline
    //         styleColor: "black"
    //     }
    // }

    // ==================== 刻度ListView ====================
    
    /**
     * @brief 刻度列表视图
     * 
     * 使用ListView实现刻度渲染，只创建可见区域内的delegate，
     * 自动回收不可见的刻度项，性能优异。
     */
    ListView {
        id: tickListView
        anchors.left: parent.left
        width:parent.width/2
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 8
        
        model: tickModel
        spacing: 0
        interactive: false
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        highlightFollowsCurrentItem: false
        
        /**
         * @brief 计算contentY偏移
         * 
         * 根据当前value计算contentY，使当前值对应的刻度线位于视图中央。
         * topValue在上，bottomValue在下，value增大时刻度向上滚动。
         */
        contentY: (biggerValue - value) * _pixelsPerUnit - height / 2
        //范围示意框
        // Rectangle {
        //     anchors.fill: parent
        //     border.width: 2
        //     border.color: "red"
        //     color:"transparent"
        // }

        // 垂直连接线
        Rectangle {
            id:verticalLine
            anchors.right:  parent.right
            anchors.rightMargin: 2
            width:  3
            height: parent.height
            color: "#cccccc"
        }

        /**
         * @brief 刻度项委托
         */
        delegate: Item {
            width: tickListView.width
            height: tickHeight
            
            property real tickValue: modelData
            property bool isMajor: (tickValue % majorInterval === 0)

            
            // 刻度线 - 白色确保在绿色背景上可见
            Rectangle {
                id: tickLine
                // anchors.left: parent.left
                // anchors.leftMargin: 5
                anchors.right: parent.right

                anchors.rightMargin: 2
                // anchors.horizontalCenter: parent.horizontalCenter
                width: isMajor ? parent.width/3:parent.width/4
                height: isMajor ? 3 : 1
                anchors.verticalCenter: parent.verticalCenter
                color: isMajor ? "white" : "#cccccc"
            }
            
            // 刻度数值（仅主刻度显示）
            Text {
                anchors.right: tickLine.left
                anchors.rightMargin: 2
                anchors.verticalCenter: parent.verticalCenter
                text: tickValue.toString()
                color: "white"
                font.pointSize: smallFontPointSize
                // font.family: fontFamily
                font.bold: true
                style: Text.Outline
                styleColor: "black"
                visible: isMajor
            }
        }
    }

    // ==================== 中心指示器 ====================
    
    /**
     * @brief 中心位置指示条
     */
    Rectangle {
        id: centerIndicator
        anchors.left: tickListView.right
        anchors.leftMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        width: tickListView.width/4
        height: 3
        color: "#00ff00"
        radius: 1
        visible: false
    }

    // // ==================== 标题 ====================
    
    // Text {
    //     id: titleLabel
    //     anchors.horizontalCenter: parent.horizontalCenter
    //     anchors.top: parent.top
    //     anchors.topMargin: 4
    //     text: label
    //     color: "white"
    //     font.pointSize: smallFontPointSize
    //     font.family: fontFamily
    //     style: Text.Outline
    //     styleColor: "black"
    //     visible:false
    // }
}
