import QtQuick 2.6
import QtWayland.Compositor 1.1
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ColumnLayout {
    property string title: "wl_shell_surface"
    property WlShellSurface shellSurface

    Label { text: "Title: " + shellSurface.title }
    Label { text: "Class name: " + shellSurface.className }
    Label { text: "Window type: " + shellSurface.windowType }

    Button { text: "Send popup done"; onClicked: shellSurface.sendPopupDone() }
    RowLayout {
        TextField {
            id: configureWidth
            inputMethodHints: Qt.ImhDigitsOnly
            text: "400"
        }
        TextField {
            id: configureHeight
            inputMethodHints: Qt.ImhDigitsOnly
            text: "300"
        }
        Button {
            text: "Send configure"
            onClicked: {
                var size = Qt.size(configureWidth, configureHeight);
                shellSurface.sendConfigure(size, wlShellSurface.NoneEdge);
            }
        }
    }
}
