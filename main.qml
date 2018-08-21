/****************************************************************************
**
** Copyright (C) 2018 The Qt Company Ltd.
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.6
import QtWayland.Compositor 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

WaylandCompositor {
    id: comp
    property alias selectedShellSurface: shellSurfacesInspector.selectedShellSurface
    property bool emulateTouch: false
    property bool showGizmos: false

    ListModel { id: shellSurfaces }

    WaylandOutput {
        id: output
        sizeFollowsWindow: true
        availableGeometry: win.contentItem.mapFromItem(surfaceArea, 0, 0, surfaceArea.width, surfaceArea.height)
        window: ApplicationWindow {
            id: win
            width: layout.implicitWidth
            height: layout.implicitHeight
            visible: true
            visibility: Window.Maximized
            title: "Kitchen Compositor - " + comp.socketName

            ColumnLayout {
                spacing: 0
                id: layout
                anchors.fill: parent
                WaylandMouseTracker {
                    id: mouseTracker
                    Layout.fillWidth: true
                    Layout.preferredHeight: 768
                    Layout.preferredWidth: 1024
                    Layout.fillHeight: true
                    clip: true

                    Rectangle {
                        id: surfaceArea
                        color: "black"
                        anchors.fill: parent
                        Repeater {
                            model: shellSurfaces
                            ShellSurfaceItem {
                                id: ssItem
                                shellSurface: modelData
                                onSurfaceDestroyed: {
                                    shellSurfaces.remove(index);
                                    if (shellSurface === comp.selectedShellSurface) {
                                        comp.selectedShellSurface = null;
                                    }
                                }
                                Component.onCompleted: console.log("Shell surface item created");
                                WindowGeometryGizmo {
                                    visible: comp.showGizmos
                                    windowGeometry: (ssItem.shellSurface && ssItem.shellSurface.windowGeometry) || Qt.rect(0,0,0,0)
                                }
                                FakeTouchArea {
                                    visible: comp.emulateTouch
                                    anchors.fill: parent
                                    seat: comp.defaultSeat
                                    surface: modelData.surface
                                }
                            }
                        }
                    }

                    WaylandCursorItem {
                        x: mouseTracker.mouseX
                        y: mouseTracker.mouseY
                        seat: comp.defaultSeat
                    }
                }

                StackLayout {
                    id: inspectorRoot
                    Layout.fillWidth: true
                    Layout.preferredHeight: 500
                    currentIndex: 1
                    Page {
                        anchors.fill: parent
                        header: ToolBar {
                            Label {
                                text: "Choose tool"
                                anchors.centerIn: parent
                            }
                        }
                        ListView {
                            anchors.fill: parent
                            model: inspectorRoot.count - 1
                            delegate: ItemDelegate {
                                text: inspectorRoot.itemAt(modelData+1).title
                                anchors.left: parent.left
                                anchors.right: parent.right
                                onClicked: inspectorRoot.currentIndex = modelData+1
                            }
                        }
                    }
                    Page {
                        title: "Shell surface inspector"
                        anchors.fill: parent
                        id: shellSurfacesInspectorPage
                        header: ToolBar {
                            ToolButton {
                                padding: 16
                                text: "<"
                                onClicked: inspectorRoot.currentIndex = 0
                            }

                            Label {
                                text: "Shell Surfaces"
                                anchors.centerIn: parent
                            }
                        }
                        ShellSurfacesInspector {
                            anchors.fill: parent
                            id: shellSurfacesInspector
                        }
                    }
                    Page {
                        title: "Output configuration"
                        anchors.fill: parent
                        header: ToolBar {
                            ToolButton {
                                padding: 16
                                text: "<"
                                onClicked: inspectorRoot.currentIndex = 0
                            }
                            Label {
                                text: "Output configuration"
                                anchors.centerIn: parent
                            }
                        }
                        OutputConfiguration {
                            anchors.centerIn: parent
                            output: output
                        }
                    }
                    Page {
                        title: "Misc settings"
                        anchors.fill: parent
                        header: ToolBar {
                            ToolButton {
                                padding: 16
                                text: "<"
                                onClicked: inspectorRoot.currentIndex = 0
                            }
                            Label {
                                text: "Misc settings"
                                anchors.centerIn: parent
                            }
                        }
                        ColumnLayout {
                            anchors.centerIn: parent
                            CheckBox {
                                text: "Emulate touch events"
                                checked: comp.emulateTouch
                                onCheckStateChanged: comp.emulateTouch = checked
                            }
                            CheckBox {
                                text: "Show gizmos for window geometry"
                                checked: comp.showGizmos
                                onCheckStateChanged: comp.showGizmos = checked
                            }
                        }
                    }
                }
            }
        }
    }

    WlShell {
        id: wlShell
        onWlShellSurfaceCreated: {
            console.log("wl_shell_surface created", shellSurface);
            shellSurfaces.append({shellSurface: shellSurface});
        }
    }

    XdgShellV5 {
        id: xdgShellV5
        onXdgSurfaceCreated: {
            console.log("xdg_surface (v5) created", xdgSurface);
            shellSurfaces.append({shellSurface: xdgSurface});
        }
    }

    XdgShellV6 {
        id: xdgShellV6
        onToplevelCreated: {
            console.log("zxdg_toplevel_v6 created", xdgSurface, toplevel);
            shellSurfaces.append({shellSurface: xdgSurface});
        }
    }

    onSurfaceCreated: {
        console.log("Surface created", surface);
    }
}
