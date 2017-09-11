import QtQuick 2.6
import QtWayland.Compositor 1.1
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ColumnLayout {
    property WaylandOutput output

    function generateEnumStrings(toString, size) {
        return Array.apply(null, {length: size}).map(Function.call, toString);
    }

    function transformToString(transform) {
        switch(transform) {
        case WaylandOutput.TransformNormal: return "normal";
        case WaylandOutput.Transform90: return "90";
        case WaylandOutput.Transform180: return "180";
        case WaylandOutput.Transform270: return "270";
        case WaylandOutput.TransformFlipped: return "flipped";
        case WaylandOutput.TransformFlipped90: return "flipped 90";
        case WaylandOutput.TransformFlipped180: return "flipped 180";
        case WaylandOutput.TransformFlipped270: return "flipped 270";
        }
        return "unknown";
    }

    function subpixelToString(transform) {
        switch(transform) {
        case WaylandOutput.SubpixelUnknown: return "unknown";
        case WaylandOutput.SubpixelNone: return "none";
        case WaylandOutput.SubpixelHorizontalRgb: return "horizontal rgb";
        case WaylandOutput.SubpixelHorizontalBgr: return "horizontal bgr";
        case WaylandOutput.SubpixelVerticalRgb: return "vertical rgb";
        case WaylandOutput.SubpixelVerticalBgr: return "vertical bgr";
        }
        return "unknown value";
    }

    CheckBox {
        text: "Automatic frame callback"
        checked: output.automaticFrameCallback
        onClicked: output.automaticFrameCallback = !output.automaticFrameCallback;
    }
    CheckBox {
        text: "Size follows window"
        checked: output.sizeFollowsWindow
        onClicked: output.sizeFollowsWindow = !output.sizeFollowsWindow;
    }
    Label { text: "Geometry (may change with window size): " + output.geometry }
    Label { text: "Available geometry (changes with window size): " + output.availableGeometry }
    RowLayout {
        Label { text: "Model" }
        TextField {
            text: output.model
            onTextChanged: output.model = text
        }
    }
    RowLayout {
        Label { text: "Manufacturer" }
        TextField {
            text: output.manufacturer
            onTextChanged: output.manufacturer = text
        }
    }
    RowLayout {
        Label { text: "Physical size (in mm)" }
        TextField {
            inputMethodHints: Qt.ImhDigitsOnly
            text: output.physicalSize.width
            onTextChanged: output.physicalSize.width = text
        }
        TextField {
            inputMethodHints: Qt.ImhDigitsOnly
            text: output.physicalSize.height
            onTextChanged: output.physicalSize.height = text
        }
    }
    RowLayout {
        Label { text: "Scale factor" }
        TextField {
            inputMethodHints: Qt.ImhDigitsOnly
            text: output.scaleFactor
            onTextChanged: output.scaleFactor = text
        }
    }
    RowLayout {
        Label { text: "Transform" }
        ComboBox {
            model: generateEnumStrings(transformToString, 8)
            currentIndex: output.transform
            onCurrentIndexChanged: output.transform = currentIndex
            implicitWidth: 240
        }
    }
    RowLayout {
        Label { text: "Subpixel" }
        ComboBox {
            model: generateEnumStrings(subpixelToString, 6)
            currentIndex: output.subpixel
            onCurrentIndexChanged: output.subpixel = currentIndex
            implicitWidth: 240
        }
    }
}
