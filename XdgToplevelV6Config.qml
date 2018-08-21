import QtQuick 2.6
import QtWayland.Compositor 1.3
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ColumnLayout {
    property variant toplevel
    property string title: "zxdg_toplevel_v6"

    Label { text: "Title: " + toplevel.title }
    Label { text: "App id: " + toplevel.appId }
    Label { text: "Max size: " + toplevel.maxSize }
    Label { text: "Min size: " + toplevel.minSize }
    Label { text: "Parent toplevel: " + toplevel.parentToplevel }

    CheckBox { text: "Maximized"; checked: toplevel.maximized; enabled: false }
    CheckBox { text: "Fullscreen"; checked: toplevel.fullscreen; enabled: false }
    CheckBox { text: "Activated"; checked: toplevel.activated; enabled: false }
    CheckBox { text: "Resizing"; checked: toplevel.resizing; enabled: false }

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
            onClicked: toplevel.sendMaximized(Qt.size(maximizeWidth.text, maximizeHeight.text))
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
            onClicked: toplevel.sendFullscreen(Qt.size(fullscreenWidth.text, fullscreenHeight.text))
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
            onClicked: toplevel.sendUnmaximized(Qt.size(unMaximizeWidth.text, unMaximizeHeight.text))
        }
    }
    Button { text: "Send close"; onClicked: toplevel.sendClose() }
}

