import QtQuick.Layouts 1.3
import QtQuick 2.6
import QtQuick.Controls 2.4
import QtQuick.Window 2.1
import QtWayland.Compositor 1.3

ScrollView {
    id: surfaceDetails
    property WaylandSurface surface
    property string title: "wl_surface"

    function originToString(o) {
        switch (o) {
        case WaylandSurface.OriginTopLeft:
            return "top left";
        case WaylandSurface.OriginBottomLeft:
            return "bottom left";
        }
        return "unknown";
    }

    function orientationToString(o) {
        switch (o) {
        case Qt.PrimaryOrientation:
            return "primary";
        case Qt.PortraitOrientation:
            return "portrait";
        case Qt.LandscapeOrientation:
            return "landscape";
        case Qt.InvertedPortraitOrientation:
            return "inverted portrait";
        case Qt.InvertedLandscapeOrientation:
            return "inverted landscape";
        }
        return "unknown";
    }

    ColumnLayout {
        width: surfaceDetails.width

        Item { Layout.fillWidth: true /* spacer */ }

        WaylandQuickItem {
            enabled: false
            sizeFollowsSurface: false
            surface: surfaceDetails.surface
            Layout.fillWidth: true
            Layout.maximumWidth: implicitWidth
            Layout.preferredHeight: implicitHeight * width / implicitWidth
            Layout.alignment: Qt.AlignCenter
        }

        WaylandQuickItem {
            id: surfaceItemHidden
            enabled: false
            surface: surfaceDetails.surface
            sizeFollowsSurface: false
            visible: false
            function takeScreenshot(surface, filename) {
                surfaceItemHidden.grabToImage(function(image) {
                    if (image.saveToFile(filename)) {
                        console.log(`Saved screenshot: ${filename}`);
                    } else {
                        console.log(`Failed to save screenshot: ${filename}`);
                    }
                });
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignCenter
            RowLayout {
                TextField { id: filename; text: `screenshot-${Date.now()}.png`; }
                Button { text: "Take screenshot"; onClicked: surfaceItemHidden.takeScreenshot(surface, filename.text) }
            }

            Label { text: "Size: " + surface.size }
            Label { text: "Buffer scale: " + surface.bufferScale }
            Label { text: "Origin: " + originToString(surface.origin) }
            Label { text: "Content orientation: " + orientationToString(surface.contentOrientation) }
            Label { text: "Client: " + surface.client }

            CheckBox { text: "Has content"; checked: surface.hasContent; enabled: false }
            CheckBox { text: "Cursor surface"; checked: surface.cursorSurface; enabled: false }

            Button { text: "Close client"; onClicked: surface.client.close() }
            RowLayout {
                Label { text: "Signal: " }
                TextField { id: killSignal; inputMethodHints: Qt.ImhDigitsOnly; text: "9" }
                Button { text: "Kill client"; onClicked: surface.client.close() }
            }

            Label { text: "Client process id: " + surface.client.processId }
            Label { text: "Client user id: " + surface.client.userId }
            Label { text: "Client group id: " + surface.client.groupId }
        }

    }
}
