import QtQuick 2.6
import QtWayland.Compositor 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Page {
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

    Layout.fillWidth: true
    header: ToolBar {
        Label {
            text: `${shellSurface}`
            anchors.centerIn: parent
        }
        ToolButton {
            padding: 16
            text: "<"
            onClicked: surfaceInterfaces.StackView.view.pop(); // this doesn't work... controls 2 bug?
        }
    }
    ColumnLayout {
        anchors.fill: parent
        TabBar {
            Layout.fillWidth: true
            id: bar
            currentIndex: 0
            Repeater {
                model: tabs.count
                TabButton { text: tabs.itemAt(index).title }
            }
            z: 1
        }

        StackLayout {
            Layout.maximumWidth: parent.width
            Layout.fillWidth: true
            id: tabs
            currentIndex: bar.currentIndex

            SurfaceDetails {
                property string title: "wl_surface"
                id: surfaceDetails
                surface: shellSurface.surface
            }

            Repeater {
                model: xdgToplevelV6 ? 1 : 0
                XdgToplevelV6Config {
                    toplevel: xdgToplevelV6
                }
            }

            Repeater {
                model: xdgSurfaceV5 ? 1 : 0
                XdgSurfaceV5Config {
                    xdgSurface: xdgSurfaceV5
                }
            }

            Repeater {
                model: xdgToplevel ? 1 : 0
                XdgToplevelV6Config { // Using v6 for now
                    title: "xdg_surface"
                    toplevel: xdgToplevel
                }
            }

            Repeater {
                model: xdgSurface ? 1 : 0
                XdgSurfaceV6Config { // Using v6 for now
                    title: "xdg_surface"
                    xdgSurface: surfaceInterfaces.xdgSurface
                }
            }

            Repeater {
                model: xdgSurfaceV6 ? 1 : 0
                XdgSurfaceV6Config {
                    xdgSurface: xdgSurfaceV6
                }
            }

            Repeater {
                model: wlShellSurface ? 1 : 0
                WlShellSurfaceConfig {
                    shellSurface: wlShellSurface
                }
            }
        }
    }
}
