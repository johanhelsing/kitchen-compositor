import QtQuick 2.6
import QtWayland.Compositor 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

StackView {
    property variant selectedShellSurface
    id: shellSurfaceInspector

    Component {
        id: interfacesPage
        SurfaceInterfaces {
            onBackClicked: {
                shellSurfaceInspector.pop()
                selectedShellSurface = null;
            }
        }
    }

    onSelectedShellSurfaceChanged: {
        console.log("Now inspecting shell surface", selectedShellSurface);
        if (selectedShellSurface)
            shellSurfaceInspector.push(interfacesPage, {shellSurface: selectedShellSurface}, StackView.ReplaceTransition);
    }

    initialItem: ListView {
        id: listView
        Layout.fillHeight: true
        implicitWidth: 300
        model: shellSurfaces
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
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    surface: modelData.surface
                }
                Label {
                    text: modelData.title || (modelData.toplevel && modelData.toplevel.title) || ("Shell surface #" + index)
                }
            }
        }
    }
}
