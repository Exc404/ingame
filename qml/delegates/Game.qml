import QtQuick
import "../constants/scene.js" as SceneConstants
//import "../components/" as C

import QtQuick.Controls as C
// Подключить для работы с типом объекта LinearGradient


C.Button {
    property string gameTitle: "Generic title"
    property string gameIcon: ""
    property string gameExec: ""

    id: game
    text: ""
    // Область для считывания нажатий
    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: "AllButtons"
        onClicked: function(){
            if(!game.visible) return;
            game.press();
        }
    }

    function press(){
        if(!visible) return;
        gameInfoScene.title = game.gameTitle;
        gameInfoScene.icon = game.gameIcon;
        gameInfoScene.exec = game.gameExec;
        var globalCoordinates = mapToItem(null,0,0)
        console.log("game coord - X: " + globalCoordinates.x + " y: " + globalCoordinates.y)
        gameInfoScene.startX = globalCoordinates.x
        gameInfoScene.startY = globalCoordinates.y
        gameInfoScene.imgWight = game.width*1.05
        gameInfoScene.imgHight = game.height*1.05

        window.scene = SceneConstants.gameInfoScene;
        gameInfoScene.startAnimation()
    }



    //
    background: Rectangle {
        id: rect
        width:game.width + border.width *2
        height:game.height + border.width*2

        opacity: 1.0
        color: "#000000"
        anchors.centerIn: parent
        border.width: 0
        border.color: "#ffffff"
        radius: 1
    }

    // Состояния
    states: [
        // Карточка в фокуске
        State {
            name: "focus"; when: game.activeFocus
            PropertyChanges { target: rect; border.width: Math.max(game.width / 100 * 2 ,2);}
            PropertyChanges { target: game; scale:1.05 }
            PropertyChanges { target: bgNameGrad; opacity:1 }
        },
        // На карточку навели курсор мыши
        State {
            name: "hover"; when: hoverArea.containsMouse
            PropertyChanges { target: game; scale:1.05 }
            PropertyChanges { target: bgNameGrad; opacity:1 }

        }
    ]

    // Анимации при изменениях состояний
    transitions: [
        Transition  {
            from: "";
            to: "focus";
            reversible: false;
            SequentialAnimation  {
                NumberAnimation{
                    target: rect;
                    property: "border.width"
                    duration: 100
                    to: Math.max(game.width / 100 * 4,4)        // пока x не будет равно 250
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: rect;
                    property: "border.width";
                    duration: 100;
                }
            }
        },
        Transition {
            from: "";
            to: "hover";
            reversible: true
            NumberAnimation {
                target: game;
                property: "scale";
                duration: 100;
            }
        }
    ]
    // вообще должно быть в Transition focus но оно там не рнаботает :(
    SequentialAnimation {
        id: anim
        running: game.activeFocus ? true : false
        loops: Animation.Infinite
        OpacityAnimator {
            target: rect;
            from: 1;
            to: 0.4;
            duration: 1000;
        }
        OpacityAnimator {
            target: rect;
            from: 0.4;
            to: 1;
            duration: 1000;
        }
    }

    // Картинка на карточке
    Image {
        id: image
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        source: game.gameIcon
        fillMode: Image.PreserveAspectFit

        // Градиент + название игры
        Rectangle {
            id: bgNameGrad
            opacity: 0
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 0.6;
                    color: "#00000000";
                }
                GradientStop {
                    position: 1.0;
                    color: "#a0000000";
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    target: bgNameGrad;
                    property: "opacity";
                    duration: 200;
                }
            }
            // Название игры
            Text {
                id: title
                y: 439
                height: 33
                color: "#ffffff"
                text: game.gameTitle
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                font.pixelSize: Math.max(game.width / 100 * 8,10)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignBottom
                anchors.bottomMargin: Math.max(game.width / 100 * 8,10)
            }
        }

    }
}
