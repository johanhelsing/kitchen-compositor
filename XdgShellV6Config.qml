import QtQuick 2.6
import QtWayland.Compositor 1.1
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ColumnLayout {
    id: xdgShellV6Config

    CheckBox {
        text: "Maximized"
        checked: xdgShellV6.lastSurface ? xdgShellV6.lastSurface.toplevel.maximized : false
        enabled: false
    }
    CheckBox {
        text: "Fullscreen"
        checked: xdgShellV6.lastSurface ? xdgShellV6.lastSurface.toplevel.fullscreen : false
        enabled: false
    }
    CheckBox {
        text: "Activated"
        checked: xdgShellV6.lastSurface ? xdgShellV6.lastSurface.toplevel.activated : false
        enabled: false
    }
    CheckBox {
        text: "Resizing"
        checked: xdgShellV6.lastSurface ? xdgShellV6.lastSurface.toplevel.resizing : false
        enabled: false
    }
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
            onClicked: xdgShellV6.lastSurface && xdgShellV6.lastSurface.toplevel.sendMaximized(Qt.size(maximizeWidth.text, maximizeHeight.text))
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
            onClicked: xdgShellV6.lastSurface && xdgShellV6.lastSurface.toplevel.sendFullscreen(Qt.size(fullscreenWidth.text, fullscreenHeight.text))
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
            onClicked: xdgShellV6.lastSurface && xdgShellV6.lastSurface.toplevel.sendUnmaximized(Qt.size(unMaximizeWidth.text, unMaximizeHeight.text))
        }
    }
}

