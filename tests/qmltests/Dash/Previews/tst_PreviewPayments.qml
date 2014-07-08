/*
 * Copyright 2014 Canonical Ltd.
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
import "../../../../qml/Dash/Previews"
import Unity.Test 0.1 as UT
import Ubuntu.Components 0.1

Rectangle {
    id: root
    width: units.gu(60)
    height: units.gu(80)

    property var jsonPurchase: {
        "source": { "price" : 0.99, "currency": "USD", "store_item_id": "com.example.package" }
    }

    property var jsonPurchaseError: {
        "source": { "price" : 0.99, "currency": "USD", "store_item_id": "com.example.invalid" }
    }

    SignalSpy {
        id: spy
        target: previewPayments
        signalName: "triggered"
    }

    PreviewPayments {
        id: previewPayments
        widgetId: "previewPayments"
        width: units.gu(30)
    }

    UT.UnityTestCase {
        name: "PreviewPaymentsTest"
        when: windowShown

        function cleanup()
        {
            spy.clear();
        }

        function test_purchase_text_display() {
            previewPayments.widgetData = jsonPurchase;

            var button = findChild(root, "paymentButton");
            verify(button != null, "Button not found.");
            compare(button.text, "0.99USD");
        }

        function test_purchase_completed() {
            // Exercise the purchaseCompleted signal here.
            previewPayments.widgetData = jsonPurchase;

            var button = findChild(root, "paymentButton");
            verify(button != null, "Button not found.");

            mouseClick(button, button.width / 2, button.height / 2);

            spy.wait();

            var args = spy.signalArguments[0];
            compare(args[0], "previewPayments");
            compare(args[1], "purchaseCompleted");
            compare(args[2], jsonPurchase["source"]);
        }

        function test_purchase_error() {
            // The mock Payments triggers an error when com.example.invalid is
            // passed to it as store_item_id. Exercise it here
            previewPayments.widgetData = jsonPurchaseError;

            var button = findChild(root, "paymentButton");
            verify(button != null, "Button not found.");

            mouseClick(button, button.width / 2, button.height / 2);

            spy.wait();

            var args = spy.signalArguments[0];
            compare(args[0], "previewPayments");
            compare(args[1], "purchaseError");
            compare(args[2], jsonPurchaseError["source"]);
        }
    }
}
