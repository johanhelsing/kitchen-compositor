import QtQuick 2.6
import QtWayland.Compositor 1.1
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

MouseArea {
    id: fakeTouchArea
    property WaylandSeat seat
    property WaylandSurface surface
    onPressed: {
        seat.sendTouchPointPressed(surface, 0, Qt.point(mouseX, mouseY));
        seat.sendTouchFrameEvent(surface.client);
    }
    onPositionChanged: {
        seat.sendTouchPointMoved(surface, 0, Qt.point(mouseX, mouseY));
        seat.sendTouchFrameEvent(surface.client);
    }
    onReleased: {
        seat.sendTouchPointReleased(surface, 0, Qt.point(mouseX, mouseY));
        seat.sendTouchFrameEvent(surface.client);
    }
    Item {
        x: fakeTouchArea.mouseX
        y: fakeTouchArea.mouseY
        Rectangle {
            visible: fakeTouchArea.pressed
            color: "red"
            anchors.centerIn: parent
            width: 20
            height: 20
            radius: width
        }
    }
}