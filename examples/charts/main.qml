import QtQuick 2.7
import QtCharts 2.2
import QtQuick.Window 2.3

Window {
    width: 400
    height: 300
    title: "Charts"

    Component.onCompleted: visible = true

    ChartView {
        id: view

        anchors.fill: parent

        VXYModelMapper {
            id: mapper
            model: myListModel
            series: lineSeries
            xColumn: 0
            yColumn: 1
        }

        LineSeries {
            id: lineSeries
            name: "LineSeries"
        }
    }
}
