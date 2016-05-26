AbstractButton { 
                id: root; 
                property var cardData; 
                property string backgroundShapeStyle: "inset"; 
                property real fontScale: 1.0; 
                property var scopeStyle: null; 
                readonly property string title: cardData && cardData["title"] || "";
                property bool showHeader: true;
                implicitWidth: childrenRect.width;
                enabled: false;
                property int fixedHeaderHeight: -1; 
                property size fixedArtShapeSize: Qt.size(-1, -1); 
signal action(var actionId);
readonly property size artShapeSize: artShapeLoader.item ? Qt.size(artShapeLoader.item.width, artShapeLoader.item.height) : Qt.size(-1, -1);
Loader  {
                                id: artShapeLoader; 
                            anchors { horizontalCenter: parent.horizontalCenter; }
                                objectName: "artShapeLoader"; 
                                readonly property string cardArt: cardData && cardData["art"] || "";
                                onCardArtChanged: { if (item) { item.image.source = cardArt; } }
                                active: cardArt != "";
                                asynchronous: true;
                                visible: status === Loader.Ready;
                                sourceComponent: Item {
                                    id: artShape;
                                    objectName: "artShape";
                                    visible: image.status === Image.Ready;
                                    readonly property alias image: artImage;
                                    width: root.fixedArtShapeSize.width;
                                    height: root.fixedArtShapeSize.height;
                                    CroppedImageMinimumSourceSize {
                                        id: artImage;
                                        objectName: "artImage";
                                        source: artShapeLoader.cardArt;
                                        asynchronous: true;
                                        visible: true;
                                        width: root.width;
                                        height: width / (root.fixedArtShapeSize.width / root.fixedArtShapeSize.height);
                                    }
                                } 
                        }
Loader { 
                            id: overlayLoader; 
                            readonly property real overlayHeight: root.fixedHeaderHeight + units.gu(2);
                            anchors.fill: artShapeLoader;
                            active: artShapeLoader.active && artShapeLoader.item && artShapeLoader.item.image.status === Image.Ready || false; 
                            asynchronous: true;
                            visible: showHeader && status === Loader.Ready;
                            sourceComponent: UbuntuShapeOverlay { 
                                id: overlay; 
                                property real luminance: Style.luminance(overlayColor); 
                                aspect: UbuntuShape.Flat; 
                                radius: "medium"; 
                                overlayColor: cardData && cardData["overlayColor"] || "#99000000"; 
                                overlayRect: Qt.rect(0, 1 - overlayLoader.overlayHeight / height, 1, 1); 
                            } 
                        }
readonly property int headerHeight: titleLabel.height + subtitleLabel.height + subtitleLabel.anchors.topMargin;
Label { 
                        id: titleLabel;
                        objectName: "titleLabel"; 
                        anchors { right: parent.right; 
                        rightMargin: units.gu(1); 
                        left: parent.left; 
                        leftMargin: units.gu(1); 
                        top: overlayLoader.top; 
                        topMargin: units.gu(1) + overlayLoader.height - overlayLoader.overlayHeight; 
                        } 
                        elide: Text.ElideRight; 
                        fontSize: "small"; 
                        wrapMode: Text.Wrap; 
                        maximumLineCount: 2; 
                        font.pixelSize: Math.round(FontUtils.sizeToPixels(fontSize) * fontScale); 
                        color: root.scopeStyle && overlayLoader.item ? root.scopeStyle.getTextColor(overlayLoader.item.luminance) : (overlayLoader.item && overlayLoader.item.luminance > 0.7 ? theme.palette.normal.baseText : "white");
                        visible: showHeader && overlayLoader.active; 
                        width: undefined;
                        text: root.title; 
                        font.weight: cardData && cardData["subtitle"] ? Font.DemiBold : Font.Normal; 
                        horizontalAlignment: Text.AlignLeft;
                    }
Label { 
                            id: subtitleLabel; 
                            objectName: "subtitleLabel"; 
                            anchors { left: titleLabel.left; 
                            leftMargin: titleLabel.leftMargin; 
                            rightMargin: units.gu(1); 
                            right: titleLabel.right; 
                            top: titleLabel.bottom; 
                            } 
                            anchors.topMargin: units.dp(2); 
                            elide: Text.ElideRight; 
                            maximumLineCount: 1; 
                            fontSize: "x-small"; 
                            font.pixelSize: Math.round(FontUtils.sizeToPixels(fontSize) * fontScale); 
                            color: root.scopeStyle && overlayLoader.item ? root.scopeStyle.getTextColor(overlayLoader.item.luminance) : (overlayLoader.item && overlayLoader.item.luminance > 0.7 ? theme.palette.normal.baseText : "white");
                            visible: titleLabel.visible && titleLabel.text; 
                            text: cardData && cardData["subtitle"] || ""; 
                            font.weight: Font.Light; 
                        }
implicitHeight: artShapeLoader.height;
}
