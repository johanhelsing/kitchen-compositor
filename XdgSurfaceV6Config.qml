import QtQuick 2.6
import QtWayland.Compositor 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

ScrollView {
    id: xdgSurfaceV6Config
    property variant xdgSurface // variant because of duck typing with the stable version
    property string title: "zxdg_surface_v6"
    ColumnLayout {
        width: xdgSurfaceV6Config.width
        Item { Layout.fillWidth: true /* spacer */ }
        WaylandQuickItem {
            Layout.maximumWidth: Math.min(implicitWidth, parent.width)
            Layout.preferredHeight: surface.size.height * width / surface.size.width
            Layout.alignment: Qt.AlignCenter
            id: windowGeometryView
            surface: xdgSurface.surface
            enabled: false
            property real ratio: width / surface.size.width
            width: xdgSurface.surface.size.width
            height: xdgSurface.surface.size.height
            Rectangle {
                anchors.fill: parent
                border.color: "blue"
                border.width: 1
                color: "transparent"
            }
            Rectangle {
                border.color: "red"
                border.width: 1
                color: "transparent"
                x: xdgSurface.windowGeometry.x * windowGeometryView.ratio
                y: xdgSurface.windowGeometry.y * windowGeometryView.ratio
                width: xdgSurface.windowGeometry.width * windowGeometryView.ratio
                height: xdgSurface.windowGeometry.height * windowGeometryView.ratio
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignCenter
            Label { text: `Window geometry: ${xdgSurface.windowGeometry}`; color: "red" }
            Label { text: `Surface size: ${xdgSurface.surface.size}`; color: "blue" }
            CheckBox { text: "Toplevel"; checked: xdgSurface.toplevel; enabled: false }
            CheckBox { text: "Popup"; checked: xdgSurface.popup; enabled: false }
        }
    }

}
