import QtQuick 2.6
import QtWayland.Compositor 1.3
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Rectangle {
    property rect windowGeometry: Qt.rect(0, 0, 0, 0);
    enabled: false
    x: windowGeometry.x
    y: windowGeometry.y
    width: windowGeometry.width
    height: windowGeometry.height
    color: "transparent"
    border {
        width: 2
        color: "red"
    }
}
