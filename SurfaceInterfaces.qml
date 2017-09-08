import QtQuick 2.6
import QtWayland.Compositor 1.1
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ColumnLayout {
    id: surfaceInterfaces
    property variant shellSurface

    //TODO: This is ugly, find a better way
    property WaylandSurface surface: shellSurface.surface
    property WlShellSurface wlShellSurface: shellSurface
    property XdgToplevelV6 xdgToplevelV6: shellSurface && shellSurface.toplevel
    property XdgSurfaceV6 xdgSurfaceV6: xdgToplevelV6 && shellSurface
    property XdgSurfaceV5 xdgSurfaceV5: shellSurface

    TabBar {
        Layout.fillWidth: true
        id: bar
        currentIndex: 0
        Repeater {
            model: tabs.count
            TabButton { text: tabs.itemAt(index).title }
        }
    }

    StackLayout {
        id: tabs
        currentIndex: bar.currentIndex

        SurfaceDetails {
            property string title: "wl_surface"
            id: surfaceDetails
            anchors.centerIn: parent
            surface: shellSurface.surface
        }

        Repeater {
            model: xdgToplevelV6 ? 1 : 0
            XdgToplevelV6Config {
                toplevel: xdgToplevelV6
                anchors.centerIn: parent
            }
        }

        Repeater {
            model: xdgSurfaceV5 ? 1 : 0
            XdgSurfaceV5Config {
                xdgSurface: xdgSurfaceV5
                anchors.centerIn: parent
            }
        }

        Repeater {
            model: xdgSurfaceV6 ? 1 : 0
            XdgSurfaceV6Config {
                xdgSurface: xdgSurfaceV6
                anchors.centerIn: parent
            }
        }

        Repeater {
            model: wlShellSurface ? 1 : 0
            WlShellSurfaceConfig {
                anchors.centerIn: parent
                shellSurface: wlShellSurface
            }
        }
    }
}
