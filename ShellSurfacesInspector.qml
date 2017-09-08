import QtQuick 2.6
import QtWayland.Compositor 1.1
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

RowLayout {
    property variant selectedShellSurface
    spacing: 0

    onSelectedShellSurfaceChanged: {
        console.log("Now inspecting shell surface", selectedShellSurface);
        interfacesPage.clear(StackView.Immediate);
        if (selectedShellSurface)
            interfacesPage.push("qrc:/SurfaceInterfaces.qml", {shellSurface: selectedShellSurface}, StackView.ReplaceTransition);
    }

    ListView {
        id: listView
        Layout.fillHeight: true
        implicitWidth: 300
        model: shellSurfaces
        header: ToolBar {
            anchors.left: parent.left
            anchors.right: parent.right
            Label {
                text: "Shell surfaces"
                anchors.centerIn: parent
            }
        }
        delegate: ItemDelegate {
            width: listView.width - listView.leftMargin - listView.rightMargin
            height: row.height
            highlighted: selectedShellSurface === modelData
            onClicked: selectedShellSurface = modelData
            RowLayout {
                id: row
                WaylandQuickItem {
                    Layout.margins: 16
                    id: thumbnail
                    sizeFollowsSurface: false
                    enabled: false
                    width: 32
                    height: 32
                    implicitWidth: 32
                    implicitHeight: 32
                    surface: modelData.surface
                }
                Label {
                    text: modelData.title || (modelData.toplevel && modelData.toplevel.title) || ("Shell surface #" + index)
                }
            }
        }
    }

    StackView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        id: interfacesPage
    }
}
