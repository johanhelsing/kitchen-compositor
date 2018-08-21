import QtQuick 2.6
import QtWayland.Compositor 1.3
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ColumnLayout {
    property variant xdgSurface
    property string title: "xdg_surface (v5)"

    CheckBox { text: "Maximized"; checked: xdgSurface.maximized; enabled: false; }
    CheckBox { text: "Fullscreen"; checked: xdgSurface.fullscreen; enabled: false }
    CheckBox { text: "Activated"; checked: xdgSurface.activated; enabled: false }
    CheckBox { text: "Resizing"; checked: xdgSurface.resizing; enabled: false }

    RowLayout {
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
        Button {
            text: "Send maximized"
            onClicked: xdgSurface.requestMaximized(Qt.size(maximizeWidth.text, maximizeHeight.text))
        }
    }
    RowLayout {
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
        Button {
            text: "Send fullscreen"
            onClicked: xdgSurface.requestFullscreen(Qt.size(fullscreenWidth.text, fullscreenHeight.text))
        }
    }
    RowLayout {
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
        Button {
            text: "Send unmaximized"
            onClicked: xdgSurface.requestUnMaximized(Qt.size(unMaximizeWidth.text, unMaximizeHeight.text))
        }
    }
}
