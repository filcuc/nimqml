import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import ContactModule 1.0

ApplicationWindow {
    width: 400
    height: 300
    title: "qmlregistertype"

    Component.onCompleted: visible = true

    Contact {
        id: contact
        firstName: "John"
        lastName: "Doo"
    }

    Label {
        anchors.centerIn: parent;
        text: contact.firstName + " " + contact.lastName
    }

    RowLayout {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        Item { Layout.fillWidth: true }
        Label { text: "FirstName:" }
        TextField { onEditingFinished: contact.firstName = text }
        Item { width: 30 }
        Label { text: "LastName: " }
        TextField { onEditingFinished: contact.lastName = text }
        Item { Layout.fillWidth: true }
    }
}
