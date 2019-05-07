import QtQuick 2.6
import QtWayland.Compositor 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

StackView {
    id: surfacesInspector
    Component {
        id: detailsPage
        Page {
            property alias surface: details.surface
            header: ToolBar {
                Label {
                    text: `${surface}`
                    anchors.centerIn: parent
                }
                ToolButton {
                    padding: 16
                    text: "<"
                    onClicked: surfacesInspector.pop(null)
                }
            }
            SurfaceDetails {
                id: details
                anchors.centerIn: parent
            }
        }
    }
    initialItem: ListView {
        id: listView
        Layout.fillHeight: true
        implicitWidth: 300
        model: surfaces
        delegate: ItemDelegate {
            width: listView.width - listView.leftMargin - listView.rightMargin
            height: row.height
            onClicked: {
                surfacesInspector.push(detailsPage, {surface: modelData});
            }
            RowLayout {
                id: row
                WaylandQuickItem {
                    Layout.margins: 16
                    id: thumbnail
                    sizeFollowsSurface: false
                    enabled: false
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    surface: modelData
                }
                Label {
                    text: `surface #${index}`
                }
            }
        }
    }
}
