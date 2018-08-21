import QtQuick.Layouts 1.3
import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Window 2.1
import QtWayland.Compositor 1.1

ColumnLayout {
    property string title: "wl_surface"
    property WaylandSurface surface

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

    WaylandQuickItem {
        id: ssItem
        enabled: false
        surface: parent.surface
        sizeFollowsSurface: false
        function takeScreenshot(surface, filename) {
            ssItem.grabToImage(function(image) {
                if (image.saveToFile(filename)) {
                    console.log(`Saved screenshot: ${filename}`);
                } else {
                    console.log(`Failed to save screenshot: ${filename}`);
                }
            });
        }
    }

    RowLayout {
        TextField { id: filename; text: "screenshot.png"; }
        //Button { text: "Take screenshot"; onClicked: ssItem.takeScreenshot(surface, filename.text) }
        Button { text: "Take screenshot"; onClicked: ssItem.takeScreenshot(surface, filename.text) }
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
