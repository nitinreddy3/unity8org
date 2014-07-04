/*
 * Copyright 2013 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import QtTest 1.0
import Unity.Test 0.1 as UT
import QMenuModel 0.1
import Utils 0.1 as Utils
import "../../../../qml/Panel/Indicators"


Item {
    id: testView
    width: units.gu(40)
    height: units.gu(70)

    MenuItemFactory {
        id: factory
        menuModel: UnityMenuModel {}
    }

    Loader {
        id: loader
        property int modelIndex: 0
        property var data

        onLoaded: {
            if (item.hasOwnProperty("menuData")) {
                item.menuData = data;
            }
        }
    }

    Utils.GDateTimeFormatter {
        id: timeFormatter
    }

    UT.UnityTestCase {
        name: "MenuItemFactory"
        when: windowShown

        property QtObject menuData: QtObject {
            property string label: "root"
            property bool sensitive: true
            property bool isSeparator: false
            property string icon: ""
            property string type: ""
            property var ext: undefined
            property string action: ""
            property var actionState: undefined
            property bool isCheck: false
            property bool isRadio: false
            property bool isToggled: false
        }

        function init() {
            menuData.label = "";
            menuData.sensitive = true;
            menuData.isSeparator = false;
            menuData.icon = "";
            menuData.type = "";
            menuData.ext = undefined;
            menuData.action = "";
            menuData.actionState = undefined;
            menuData.isCheck = false;
            menuData.isRadio = false;
            menuData.isToggled = false;

            loader.sourceComponent = null;
            loader.data = undefined;

            verify(loader.item == null);
        }

        function test_createTypes_data() {
            return [
                { tag: 'volume', type: "unity.widgets.systemsettings.tablet.volumecontrol", objectName: "sliderMenu" },
                { tag: 'switch1', type: "unity.widgets.systemsettings.tablet.switch", objectName: "switchMenu" },

                { tag: 'button', type: "com.canonical.indicator.button", objectName: "buttonMenu" },
                { tag: 'separator', type: "com.canonical.indicator.div", objectName: "separatorMenu" },
                { tag: 'section', type: "com.canonical.indicator.section", objectName: "sectionMenu" },
                { tag: 'progress', type: "com.canonical.indicator.progress", objectName: "progressMenu" },
                { tag: 'slider1', type: "com.canonical.indicator.slider", objectName: "sliderMenu" },
                { tag: 'switch2', type: "com.canonical.indicator.switch", objectName: "switchMenu" },
                { tag: 'alarm', type: "com.canonical.indicator.alarm", objectName: "alarmMenu" },
                { tag: 'appointment', type: "com.canonical.indicator.appointment", objectName: "appointmentMenu" },
                { tag: 'transfer', type: "com.canonical.indicator.transfer", objectName: "transferMenu" },
                { tag: 'buttonSection', type: "com.canonical.indicator.button-section", objectName: "buttonSectionMenu" },

                { tag: 'messageItem', type: "com.canonical.indicator.messages.messageitem", objectName: "messageItem" },
                { tag: 'sourceItem', type: "com.canonical.indicator.messages.sourceitem", objectName: "groupedMessage" },

                { tag: 'slider2', type: "com.canonical.unity.slider", objectName: "sliderMenu" },
                { tag: 'switch3', type: "com.canonical.unity.switch", objectName: "switchMenu" },

                { tag: 'mediaplayer', type: "com.canonical.unity.media-player", objectName: "mediaPayerMenu" },
                { tag: 'playbackitem', type: "com.canonical.unity.playback-item", objectName: "playbackItemMenu" },

                { tag: 'wifisection', type: "unity.widgets.systemsettings.tablet.wifisection", objectName: "wifiSection" },
                { tag: 'accesspoint', type: "unity.widgets.systemsettings.tablet.accesspoint", objectName: "accessPoint" },

                { tag: 'unknown', type: "", objectName: "standardMenu"}
            ];
        }

        function test_createTypes(data) {
            menuData.type = data.type;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, data.objectName, "Created object name does not match intended object (" + loader.item.objectName + " != " + data.objectName + ")");
        }

        function test_create_checkable() {
            var tmpData = menuData;
            tmpData.isCheck = true;

            loader.data = tmpData;
            loader.sourceComponent = factory.load(tmpData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "checkableMenu", "Should have created a checkable menu");
        }

        function test_create_radio() {
            skip("No radio component");
            menuData.isRadio = true;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "checkableMenu", "Should have created a checkable menu");
        }

        function test_create_separator() {
            menuData.isSeparator = true;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "separatorMenu", "Should have created a separator menu");
        }

        function test_create_sliderMenu_data() {
            return [
                {tag: "disabled", enabled: false, minValue: 0, maxValue: 100, value1: 10.5, value2: 22 },
                {tag: "enabled", enabled: true, minValue: 0, maxValue: 100, value1: 100, value2: 50 },
            ];
        }

        function test_create_sliderMenu(data) {
            menuData.type = "com.canonical.indicator.slider"
            menuData.label = data.tag;
            menuData.sensitive = data.enabled;
            menuData.ext = {
                'minIcon': "file:///testMinIcon",
                'maxIcon': "file:///testMaxIcon",
                'minValue': data.minValue,
                'maxValue': data.maxValue
            };
            menuData.actionState = data.value1;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "sliderMenu", "Should have created a slider menu");

            compare(loader.item.text, data.tag, "Label does not match data");
            compare(loader.item.minIcon, "file:///testMinIcon", "MinIcon does not match data");
            compare(loader.item.maxIcon, "file:///testMaxIcon", "MaxIcon does not match data");
            compare(loader.item.minimumValue, data.minValue, "MinValue does not match data");
            compare(loader.item.maximumValue, data.maxValue, "MaxValue does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
            compare(loader.item.value, data.value1, "Value does not match data");

            menuData.actionState = data.value2;
            compare(loader.item.value, data.value2, "Value does not match new data");
        }

        function test_create_sliderMenu_lp1283191_data() {
            return [
                {tag: "disabled", enabled: false, minValue: 0, maxValue: 100, value1: 10.5, value2: 22, manualValue: 0 },
                {tag: "enabled", enabled: true, minValue: 0, maxValue: 100, value1: 100, value2: 50, manualValue: 30 },
                {tag: "test-zero", enabled: true, minValue: 0, maxValue: 100, value1: 10, value2: 0, manualValue: 20 },
            ];
        }

        function test_create_sliderMenu_lp1283191(data) {
            menuData.type = "com.canonical.indicator.slider"
            menuData.label = data.tag;
            menuData.sensitive = data.enabled;
            menuData.ext = {
                'minIcon': "file:///testMinIcon",
                'maxIcon': "file:///testMaxIcon",
                'minValue': data.minValue,
                'maxValue': data.maxValue
            };
            menuData.actionState = data.value1;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.value, data.value1, "Value does not match data");

            var slider = findChild(loader.item, "slider");
            verify(slider !== null);

            slider.value = data.manualValue;
            compare(loader.item.value, data.manualValue, "Slider value does not match manual set value");

            menuData.actionState = data.value2;
            compare(loader.item.value, data.value2, "Value does not match new data");

            menuData.actionState = undefined;
            compare(loader.item.value, data.value2, "Undefined state should not update slider value");
        }

        function test_create_buttonMenu_data() {
            return [
                {label: "testLabel1", enabled: false },
                {label: "testLabel2", enabled: true },
            ];
        }

        function test_create_buttonMenu(data) {
            menuData.type = "com.canonical.indicator.button"
            menuData.label = data.label;
            menuData.sensitive = data.enabled;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "buttonMenu", "Should have created a button menu");

            compare(loader.item.buttonText, data.label, "Label does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
        }

        function test_create_sectionMenu_data() {
            return [
                {label: "testLabel1" },
                {label: "testLabel2" },
            ];
        }

        function test_create_sectionMenu(data) {
            menuData.type = "com.canonical.indicator.section"
            menuData.label = data.label;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "sectionMenu", "Should have created a section menu");

            compare(loader.item.text, data.label, "Label does not match data");
        }

        function test_create_progressMenu_data() {
            return [
                {label: "testLabel1", enabled: true, value: 10 },
                {label: "testLabel2", enabled: false, value: 55 },
            ];
        }

        function test_create_progressMenu(data) {
            menuData.type = "com.canonical.indicator.progress"
            menuData.label = data.label;
            menuData.sensitive = data.enabled;
            menuData.actionState = data.value;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "progressMenu", "Should have created a progress menu");

            compare(loader.item.text, data.label, "Label does not match data");
            compare(loader.item.value, data.value, "Value does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
        }

        function test_create_standardMenu_data() {
            return [
                {label: "testLabel1", enabled: true, icon: "file:///testIcon1" },
                {label: "testLabel2", enabled: false, icon: "file:///testIcon2"},
            ];
        }

        function test_create_standardMenu(data) {
            menuData.type = ""
            menuData.label = data.label;
            menuData.sensitive = data.enabled;
            menuData.icon = data.icon;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "standardMenu", "Should have created a standard menu");

            compare(loader.item.text, data.label, "Label does not match data");
            compare(loader.item.iconSource, data.icon, "MaxIcon does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
        }

        function test_create_checkableMenu_data() {
            return [
                {label: "testLabel1", enabled: true, checked: false },
                {label: "testLabel2", enabled: false, checked: true },
            ];
        }

        function test_create_checkableMenu(data) {
            menuData.type = "";
            menuData.label = data.label;
            menuData.sensitive = data.enabled;
            menuData.isCheck = true;
            menuData.isToggled = data.checked;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "checkableMenu", "Should have created a checkable menu");

            compare(loader.item.text, data.label, "Label does not match data");
            compare(loader.item.checked, data.checked, "Checked does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
        }

        function test_create_switchMenu_data() {
            return [
                {label: "testLabel1", enabled: true, checked: false, icon: "file:///testIcon1" },
                {label: "testLabel2", enabled: false, checked: true, icon: "file:///testIcon2" },
            ];
        }

        function test_create_switchMenu(data) {
            menuData.type = "com.canonical.indicator.switch";
            menuData.label = data.label;
            menuData.sensitive = data.enabled;
            menuData.icon = data.icon;
            menuData.isToggled = data.checked;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "switchMenu", "Should have created a switch menu");

            compare(loader.item.text, data.label, "Label does not match data");
            compare(loader.item.iconSource, data.icon, "Icon does not match data");
            compare(loader.item.checked, data.checked, "Checked does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
        }

        function test_create_alarmMenu_data() {
            return [
                {label: "testLabel1", enabled: true, icon: "file:///testIcon1", color: Qt.rgba(0, 0, 0, 0),
                            time: new Date(2014, 04, 14).getTime()*1000, timeFormat: "%a %d %b %l:%M %p"},
                {label: "testLabel2", enabled: false, icon: "file:///testIcon2", color: Qt.rgba(1, 0, 0, 0),
                            time: new Date(2015, 12, 31).getTime()*1000, timeFormat: "%A" },
            ];
        }

        function test_create_alarmMenu(data) {
            menuData.type = "com.canonical.indicator.alarm";
            menuData.label = data.label;
            menuData.sensitive = data.enabled;
            menuData.icon = data.icon;
            menuData.ext = {
                'xCanonicalTime': data.time,
                'xCanonicalTimeFormat': data.timeFormat
            };
            timeFormatter.format = data.timeFormat;
            timeFormatter.time = data.time;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "alarmMenu", "Should have created a alarm menu");

            compare(loader.item.text, data.label, "Label does not match data");
            compare(loader.item.iconSource, data.icon, "Icon does not match data");
            compare(loader.item.time, timeFormatter.timeString, "Time does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
        }

        function test_create_appointmentMenu_data() {
            return [
                {label: "testLabel1", enabled: true, icon: "file:///testIcon1", color: Qt.rgba(0, 0, 0, 0),
                            time: new Date(2014, 04, 14).getTime()*1000, timeFormat: "%a %d %b %l:%M %p"},
                {label: "testLabel2", enabled: false, icon: "file:///testIcon2", color: Qt.rgba(1, 0, 0, 0),
                            time: new Date(2015, 12, 31).getTime()*1000, timeFormat: "%A" },
            ];
        }

        function test_create_appointmentMenu(data) {
            menuData.type = "com.canonical.indicator.appointment";
            menuData.label = data.label;
            menuData.sensitive = data.enabled;
            menuData.icon = data.icon;
            menuData.ext = {
                'xCanonicalColor': data.colour,
                'xCanonicalTime': data.time,
                'xCanonicalTimeFormat': data.timeFormat
            };
            timeFormatter.format = data.timeFormat;
            timeFormatter.time = data.time;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "appointmentMenu", "Should have created a appointment menu");

            compare(loader.item.text, data.label, "Label does not match data");
            compare(loader.item.iconSource, data.icon, "Icon does not match data");
            compare(loader.item.time, timeFormatter.timeString, "Time does not match data");
            compare(loader.item.eventColor, data.color, "Colour does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
        }

        function test_create_transferMenu_data() {
            return [
                {tag: "queued", label: "testLabel1", enabled: true, active: true, icon: "file:///testIcon1", progress: 0, stateText: i18n.tr("In queue…") },
                {tag: "running", label: "testLabel2", enabled: true, active: true, icon: "file:///testIcon2", progress: 0.1, stateText: "1 minute, 40 seconds remaining" },
                {tag: "paused", label: "testLabel3", enabled: true, active: true, icon: "file:///testIcon3", progress: 0.5, stateText: i18n.tr("Paused, tap to resume") },
                {tag: "cancelled", label: "testLabel4", enabled: true, active: true, icon: "file:///testIcon4", progress: 0.4, stateText: i18n.tr("Canceled") },
                {tag: "finished", label: "testLabel5", enabled: false, active: false, icon: "file:///testIcon5", progress: 1.0, stateText: i18n.tr("Finished") },
                {tag: "error", label: "testLabel6", enabled: false, active: true, icon: "file:///testIcon6", progress: 0, stateText: i18n.tr("Failed, tap to retry") },
            ];
        }

        function test_create_transferMenu(data) {
            menuData.type = "com.canonical.indicator.transfer";
            menuData.label = data.label;
            menuData.sensitive = data.enabled;
            menuData.icon = data.icon;
            menuData.ext = {
                'xCanonicalUid': data.tag
            };

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "transferMenu", "Should have created a transfer menu");

            compare(loader.item.text, data.label, "Label does not match data");
            compare(loader.item.iconSource, data.icon, "Icon does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
            compare(loader.item.progress, data.progress, "Icon does not match data");
            compare(loader.item.active, data.active, "Active does not match data");
            compare(loader.item.stateText, data.stateText, "State text does not match data");
        }

        function test_create_buttonSectionMenu_data() {
            return [
                {label: "testLabel1", enabled: true, buttonText: "buttonLabel1", icon: "file:///testIcon1" },
                {label: "testLabel2", enabled: false, buttonText: "buttonLabel1", icon: "file:///testIcon2" },
            ];
        }

        function test_create_buttonSectionMenu(data) {
            menuData.type = "com.canonical.indicator.button-section";
            menuData.label = data.label;
            menuData.sensitive = data.enabled;
            menuData.icon = data.icon;
            menuData.ext = {
                'xCanonicalExtraLabel': data.buttonText
            };

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "buttonSectionMenu", "Should have created a transfer menu");

            compare(loader.item.text, data.label, "Label does not match data");
            compare(loader.item.iconSource, data.icon, "Icon does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
            compare(loader.item.control.text, data.buttonText, "Button text does not match data");
        }

        function test_create_wifiSection_data() {
            return [
                {label: "testLabel1", busy: false },
                {label: "testLabel2", busy: true },
            ];
        }

        function test_create_wifiSection(data) {
            menuData.type = "unity.widgets.systemsettings.tablet.wifisection";
            menuData.label = data.label;
            menuData.ext = { 'xCanonicalBusyAction': data.busy }

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "wifiSection", "Should have created a wifi section menu");

            compare(loader.item.text, data.label, "Label does not match data");
            compare(loader.item.busy, data.busy, "Busy does not match data");
        }

        function test_create_accessPoint_data() {
            return [
                {label: "testLabel1", enabled: true, checked: false, secure: true, adHoc: false },
                {label: "testLabel2", enabled: false, checked: true, secure: false, adHoc: true },
            ];
        }

        function test_create_accessPoint(data) {
            menuData.type = "unity.widgets.systemsettings.tablet.accesspoint";
            menuData.label = data.label;
            menuData.sensitive = data.enabled;
            menuData.isToggled = data.checked;
            menuData.ext = {
                'xCanonicalWifiApStrengthAction': "action::strength",
                'xCanonicalWifiApIsSecure': data.secure,
                'xCanonicalWifiApIsAdhoc': data.adHoc,
            };

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "accessPoint", "Should have created a access point menu");

            compare(loader.item.text, data.label, "Label does not match data");
            compare(loader.item.strengthAction.name, "action::strength", "Strength action incorrect");
            compare(loader.item.secure, data.secure, "Secure does not match data");
            compare(loader.item.adHoc, data.adHoc, "AdHoc does not match data");
            compare(loader.item.checked, data.checked, "Checked does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
        }

        function test_create_messageItem() {
            menuData.type = "com.canonical.indicator.messages.messageitem";

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "messageItem", "Should have created a message menu");
        }

        function test_create_groupedMessage_data() {
            return [
                {label: "testLabel1", enabled: true, count: "5", icon: "file:///testIcon" },
                {label: "testLabel2", enabled: false, count: "10", icon: "file:///testIcon2" },
            ];
        }

        function test_create_groupedMessage(data) {
            menuData.type = "com.canonical.indicator.messages.sourceitem";
            menuData.label = data.label;
            menuData.sensitive = data.enabled;
            menuData.icon = data.icon;
            menuData.ext = { 'icon': data.icon };
            menuData.actionState = [data.count];
            menuData.isToggled = true;

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "groupedMessage", "Should have created a group message menu");

            compare(loader.item.text, data.label, "Label does not match data");
            compare(loader.item.count, data.count, "Count does not match data");
            compare(loader.item.iconSource, data.icon, "Icon does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
        }

        function test_create_mediaPayerMenu_data() {
            return [{
                    label: "player1",
                    icon: "file:://icon1",
                    albumArt: "file:://art1",
                    song: "song1",
                    artist: "artist1",
                    album: "album1",
                    running: true,
                    state: "Playing",
                    enabled: true
                },{
                    label: "player2",
                    icon: "file:://icon2",
                    albumArt: "file:://art2",
                    song: "song2",
                    artist: "artist2",
                    album: "album2",
                    running: false,
                    state: "Paused",
                    enabled: false
                }
            ];
        }

        function test_create_mediaPayerMenu(data) {
            menuData.type = "com.canonical.unity.media-player";
            menuData.label = data.label;
            menuData.sensitive = data.enabled;
            menuData.icon = data.icon;
            menuData.actionState = {
                'art-url': data.albumArt,
                'title': data.song,
                'artist': data.artist,
                'album': data.album,
                'running': data.running,
                'state': data.state,
            };

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "mediaPayerMenu", "Should have created a media player menu");

            compare(loader.item.playerIcon, data.icon, "Album art does not match data");
            compare(loader.item.playerName, data.label, "Album art does not match data");
            compare(loader.item.albumArt, data.albumArt, "Album art does not match data");
            compare(loader.item.song, data.song, "Song does not match data");
            compare(loader.item.artist, data.artist, "Artist does not match data");
            compare(loader.item.album, data.album, "Album does not match data");
            compare(loader.item.running, data.running, "Running does not match data");
            compare(loader.item.state, data.state, "State does not match data");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
        }

        function test_create_playbackItemMenu_data() {
            return [{
                    playAction: "action::play",
                    nextAction: "action::next",
                    previousAction: "action::previous",
                    enabled: true
                },{
                    playAction: "action::play2",
                    nextAction: "action::next2",
                    previousAction: "action::previous2",
                    enabled: false
                }
            ];
        }

        function test_create_playbackItemMenu(data) {
            menuData.type = "com.canonical.unity.playback-item";
            menuData.sensitive = data.enabled;
            menuData.ext = {
                'xCanonicalPlayAction': data.playAction,
                'xCanonicalNextAction': data.nextAction,
                'xCanonicalPreviousAction': data.previousAction
            };

            loader.data = menuData;
            loader.sourceComponent = factory.load(menuData);
            tryCompareFunction(function() { return loader.item != undefined; }, true);
            compare(loader.item.objectName, "playbackItemMenu", "Should have created a playback menu");

            compare(loader.item.playing, false, "Playing does not match data");
            compare(loader.item.playAction.name, data.playAction, "Play action incorrect");
            compare(loader.item.nextAction.name, data.nextAction, "Next action incorrect");
            compare(loader.item.previousAction.name, data.previousAction, "Previous action incorrect");
            compare(loader.item.canPlay, false, "CanPlay should be false");
            compare(loader.item.canGoNext, false, "CanGoNext should be false");
            compare(loader.item.canGoPrevious, false, "CanGoPrevious should be false");
            compare(loader.item.enabled, data.enabled, "Enabled does not match data");
        }
    }
}
