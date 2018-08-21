import QtQuick 2.6
import QtWayland.Compositor 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ColumnLayout {
    id: surfaceInterfaces
    property variant shellSurface

    //TODO: This is ugly, find a better way
    function castQmlType(obj, type) {
        return (obj && obj instanceof type) ? obj : null;
    }
    function castClassName(obj, name) {
        return (obj && obj.toString().includes(name+"(")) ? obj : null;
    }
    property variant surface: shellSurface.surface

    property XdgToplevel xdgToplevel: shellSurface && castQmlType(shellSurface.toplevel, XdgToplevel)
    property variant xdgSurface: castClassName(shellSurface, "QWaylandXdgSurface")

    property XdgToplevelV6 xdgToplevelV6: shellSurface && castQmlType(shellSurface.toplevel, XdgToplevelV6)
    property variant xdgSurfaceV6: castClassName(shellSurface, "QWaylandXdgSurfaceV6")

    property variant xdgSurfaceV5: castClassName(shellSurface, "QWaylandXdgSurfaceV5")

    property variant wlShellSurface: castClassName(shellSurface, "QWaylandWlShellSurface")

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
