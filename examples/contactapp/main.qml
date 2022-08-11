import QtQuick 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import Qt.labs.qmlmodels 1.0

ApplicationWindow {
    width: 500
    height: 300
    title: "ContactApp"
    visible: true

    menuBar: MenuBar {
        Menu {
            title: "&File"
            MenuItem { text: "&Load"; onTriggered: logic.onLoadTriggered() }
            MenuItem { text: "&Save"; onTriggered: logic.onSaveTriggered() }
            MenuItem { text: "&Exit"; onTriggered: logic.onExitTriggered() }
        }
    }

    Label {
	anchors.centerIn: parent
	visible: view.count <= 0
	text: "No contacts inserted yet.. :("
    }

    ColumnLayout {
        anchors.fill: parent

        ListView {
	    id: view
            model: logic.contactList
            Layout.fillWidth: true
            Layout.fillHeight: true
            delegate: Item {
		implicitHeight: 30
		width: ListView.view.width
		Label {
		    id: firstNameLabel
		    anchors { left: parent.left; top: parent.top; bottom: parent.bottom; }
		    width: (parent.width - deleteButton.width) / 2 
		    text: firstName
		}
		Label {
		    id: lastNameLabel
		    anchors { left: firstNameLabel.right; top: parent.top; bottom: parent.bottom; }
		    width: firstNameLabel.width
		    text: lastName
		}
		Button {
		    id: deleteButton
		    anchors { top: parent.top; bottom: parent.bottom; right: parent.right }
		    width: 100
		    text: "Delete"
		    onClicked: logic.contactList.del(index)
		}
	    }
        }

        RowLayout {
            Label { text: "FirstName" }
            TextField { id: nameTextField; Layout.fillWidth: true; text: "" }
            Label { text: "LastName" }
            TextField { id: surnameTextField; Layout.fillWidth: true; text: "" }
            Button {
                text: "Add"
                onClicked: logic.contactList.add(nameTextField.text, surnameTextField.text)
                enabled: nameTextField.text !== "" && surnameTextField.text !== ""
            }
        }
    }
}
