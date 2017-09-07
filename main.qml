/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
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
import QtWayland.Compositor 1.1
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

WaylandCompositor {
    id: comp
    property variant lastSurface

    WaylandOutput {
        sizeFollowsWindow: true
        window: ApplicationWindow {
            width: layout.implicitWidth
            height: layout.implicitHeight
            visible: true

            ColumnLayout {
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
                    }

                    WaylandCursorItem {
                        inputEventsEnabled: false
                        x: mouseTracker.mouseX - hotspotX
                        y: mouseTracker.mouseY - hotspotY
                        seat: comp.defaultSeat
                    }
                }

                ColumnLayout {
                    TabBar {
                        Layout.fillWidth: true
                        id: bar
                        currentIndex: 2
                        TabButton { text: "xdg-shell v6" }
                        TabButton { text: "xdg-shell v5" }
                        TabButton { text: "surface-grab" }
                    }

                    StackLayout {
                        currentIndex: bar.currentIndex

                        XdgShellV6Config {}

                        ColumnLayout {
                            id: xdgShellV5Config
                            anchors.centerIn: parent
                            CheckBox {
                                text: "Maximized"
                                checked: xdgShellV5.lastSurface ? xdgShellV5.lastSurface.maximized : false
                                enabled: false
                            }
                            CheckBox {
                                text: "Fullscreen"
                                checked: xdgShellV5.lastSurface ? xdgShellV5.lastSurface.fullscreen : false
                                enabled: false
                            }
                            CheckBox {
                                text: "Activated"
                                checked: xdgShellV5.lastSurface ? xdgShellV5.lastSurface.activated : false
                                enabled: false
                            }
                            CheckBox {
                                text: "Resizing"
                                checked: xdgShellV5.lastSurface ? xdgShellV5.lastSurface.resizing : false
                                enabled: false
                            }
                            RowLayout {
                                Button {
                                    text: "Send maximized"
                                    onClicked: xdgShellV5.lastSurface && xdgShellV5.lastSurface.requestMaximized(Qt.size(maximizeWidth.text, maximizeHeight.text))
                                }
                                TextField {
                                    id: maximizeWidth
                                    inputMethodHints: Qt.ImhDigitsOnly
                                    text: surfaceArea.width
                                }
                                TextField {
                                    id: maximizeHeight
                                    inputMethodHints: Qt.ImhDigitsOnly
                                    text: surfaceArea.height
                                }
                            }
                            RowLayout {
                                Button {
                                    text: "Send fullscreen"
                                    onClicked: xdgShellV5.lastSurface && xdgShellV5.lastSurface.requestFullscreen(Qt.size(fullscreenWidth.text, fullscreenHeight.text))
                                }
                                TextField {
                                    id: fullscreenWidth
                                    inputMethodHints: Qt.ImhDigitsOnly
                                    text: surfaceArea.width
                                }
                                TextField {
                                    id: fullscreenHeight
                                    inputMethodHints: Qt.ImhDigitsOnly
                                    text: surfaceArea.height
                                }
                            }
                            RowLayout {
                                Button {
                                    text: "Send unmaximized"
                                    onClicked: xdgShellV5.lastSurface && xdgShellV5.lastSurface.requestUnMaximized(Qt.size(unMaximizeWidth.text, unMaximizeHeight.text))
                                }
                                TextField {
                                    id: unMaximizeWidth
                                    inputMethodHints: Qt.ImhDigitsOnly
                                    text: "400"
                                }
                                TextField {
                                    id: unMaximizeHeight
                                    inputMethodHints: Qt.ImhDigitsOnly
                                    text: "300"
                                }
                            }
                        }
                        ColumnLayout {
                            anchors.centerIn: parent
                            Button {
                                text: "Grab surface"
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
            console.log("wlshellsurface created", shellSurface);
            shellSurfaceItem.createObject(surfaceArea, { "shellSurface": shellSurface } );
        }
    }

    XdgShellV5 {
        id: xdgShellV5
        property variant lastSurface
        onXdgSurfaceCreated: {
            console.log("xdgtoplevel v5 created", xdgSurface);
            shellSurfaceItem.createObject(surfaceArea, { "shellSurface": xdgSurface } );
            lastSurface = xdgSurface;
        }
    }

    XdgShellV6 {
        id: xdgShellV6
        property variant lastSurface
        onToplevelCreated: {
            console.log("xdgtoplevel v6 created", xdgSurface, toplevel);
            shellSurfaceItem.createObject(surfaceArea, { "shellSurface": xdgSurface } );
            lastSurface = xdgSurface;
        }
    }

    Component {
        id: shellSurfaceItem
        ShellSurfaceItem {
//            autoCreatePopupItems: true
            onSurfaceDestroyed: destroy();
            Component.onCompleted: console.log("shell surface item created");
        }
    }

//    Component {
//        id: xdgSurfaceItem
//        XdgSurfaceItem {
//            id: xdgChrome
//            onSurfaceDestroyed: {
//                xdgChrome.destroy();
//            }
//            Rectangle { x: -5; width: 11; height: 1; color: "red" }
//            Rectangle { y: -5; width: 1; height: 11; color: "red" }
//
//            Rectangle {
//                width: xdgSurface.surface.size.width
//                height: xdgSurface.surface.size.height
//                color: "transparent"
//                border {
//                    width: 2
//                    color: Qt.rgba(0, 1, 0, 1)
//                }
//            }
//
//            Rectangle {
//                id: windowGeometryGizmo
//                x: xdgSurface.windowGeometry.x
//                y: xdgSurface.windowGeometry.y
//                width: xdgSurface.windowGeometry.width
//                height: xdgSurface.windowGeometry.height
//                color: "transparent"
//                border {
//                    width: 2
//                    color: "red"
//                }
//            }
//        }
//    }

    onSurfaceCreated: {
        lastSurface = surface;
    }
}
