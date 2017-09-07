import QtQuick 2.6
import QtWayland.Compositor 1.1
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ColumnLayout {
    id: xdgShellV5Config
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
