import QtQuick 2.6
import QtWayland.Compositor 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ColumnLayout {
    property string title: "zxdg_surface_v6"
    property variant xdgSurface
    Label { text: "Window geometry: " + xdgSurface.windowGeometry }
    Label { text: "Surface size: " + xdgSurface.surface.size }
    CheckBox { text: "Toplevel"; checked: xdgSurface.toplevel; enabled: false }
    CheckBox { text: "Popup"; checked: xdgSurface.popup; enabled: false }
}
