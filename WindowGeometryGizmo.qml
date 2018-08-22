import QtQuick 2.6
import QtWayland.Compositor 1.3
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Rectangle {
    property rect windowGeometry: Qt.rect(0, 0, 0, 0);
    property real bufferScale: 1
    enabled: false
    x: windowGeometry.x * bufferScale
    y: windowGeometry.y * bufferScale
    width: windowGeometry.width * bufferScale
    height: windowGeometry.height * bufferScale
    color: "transparent"
    border {
        width: 2
        color: "red"
    }
}
