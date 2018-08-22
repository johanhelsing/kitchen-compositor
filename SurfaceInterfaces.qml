import QtQuick 2.6
import QtWayland.Compositor 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

Page {
    id: surfaceInterfaces
    property variant shellSurface

    //TODO: This is ugly, find a better way
    function cast(type, obj) {
        return (obj && obj instanceof type) ? obj : null;
    }
    property WaylandSurface surface: cast(WaylandSurface, shellSurface.surface)

    property XdgToplevel xdgToplevel: shellSurface && cast(XdgToplevel, shellSurface.toplevel)
    property XdgSurface xdgSurface: cast(XdgSurface, shellSurface)

    property XdgToplevelV6 xdgToplevelV6: shellSurface && cast(XdgToplevelV6, shellSurface.toplevel)
    property XdgSurfaceV6 xdgSurfaceV6: cast(XdgSurfaceV6, shellSurface)

    property XdgSurfaceV5 xdgSurfaceV5: cast(XdgSurfaceV5, shellSurface)

    property WlShellSurface wlShellSurface: cast(WlShellSurface, shellSurface)

    signal backClicked

    Layout.fillWidth: true
    header: ToolBar {
        Label {
            text: `${shellSurface}`
            anchors.centerIn: parent
        }
        ToolButton {
            padding: 16
            text: "<"
            onClicked: surfaceInterfaces.backClicked()
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
                    title: "xdg_toplevel"
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
