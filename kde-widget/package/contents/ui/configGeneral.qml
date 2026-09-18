// SPDX-FileCopyrightText: 2026 Orlin Chotev <meteoclock@obla.us>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_city: cityField.text
    property alias cfg_metric: metricBox.checked
    property alias cfg_use24h: format24Box.checked
    property alias cfg_showSeconds: secondsBox.checked
    property alias cfg_showDate: dateBox.checked
    property alias cfg_dimAtNight: dimBox.checked
    property alias cfg_tintOpacity: tintSlider.value
    property string cfg_background
    // Plasma pushes a <name>Default for every key; without it the
    // dialog's Defaults button cannot restore a plain string property.
    property string cfg_backgroundDefault
    property string cfg_layoutDefault
    property alias cfg_refreshMinutes: refreshSpin.value
    property string cfg_layout

    Kirigami.FormLayout {
        QQC2.TextField {
            id: cityField
            Kirigami.FormData.label: i18n("City:")
            placeholderText: i18n("Sofia")
        }

        QQC2.Label {
            text: i18n("Looked up by name, never by GPS.")
            opacity: 0.7
            font: Kirigami.Theme.smallFont
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QQC2.ComboBox {
            id: layoutCombo
            Kirigami.FormData.label: i18n("Layout:")
            textRole: "label"
            valueRole: "key"
            model: [
                { key: "modern", label: i18n("Modern (stacked)") },
                { key: "row", label: i18n("Side by side") },
                { key: "card", label: i18n("Card") }
            ]
            onActivated: cfg_layout = currentValue
            Component.onCompleted: currentIndex = Math.max(0, indexOfValue(cfg_layout))
        }

        QQC2.ComboBox {
            id: backgroundCombo
            Kirigami.FormData.label: i18n("Background:")
            textRole: "label"
            valueRole: "key"
            model: [
                { key: "theme", label: i18n("Plasma theme") },
                { key: "translucent", label: i18n("Translucent") },
                { key: "tint", label: i18n("Tinted panel") },
                { key: "none", label: i18n("None (text shadow)") }
            ]
            onActivated: cfg_background = currentValue
            Component.onCompleted: currentIndex = Math.max(0, indexOfValue(cfg_background))
        }

        QQC2.Slider {
            id: tintSlider
            Kirigami.FormData.label: i18n("Tint strength:")
            enabled: cfg_background === "tint"
            from: 20
            to: 100
            stepSize: 5
            snapMode: QQC2.Slider.SnapAlways
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QQC2.CheckBox {
            id: metricBox
            Kirigami.FormData.label: i18n("Units:")
            text: i18n("Celsius (off means Fahrenheit)")
        }

        QQC2.CheckBox {
            id: format24Box
            Kirigami.FormData.label: i18n("Clock:")
            text: i18n("24 hour format")
        }

        QQC2.CheckBox {
            id: secondsBox
            text: i18n("Show seconds")
        }

        QQC2.CheckBox {
            id: dateBox
            text: i18n("Show the date")
        }

        QQC2.CheckBox {
            id: dimBox
            Kirigami.FormData.label: i18n("At night:")
            text: i18n("Dim the face after sunset")
        }

        QQC2.SpinBox {
            id: refreshSpin
            Kirigami.FormData.label: i18n("Refresh weather every:")
            from: 5
            to: 180
            stepSize: 5
            textFromValue: function (value) { return i18n("%1 minutes", value) }
            valueFromText: function (text) { return parseInt(text, 10) }
        }
    }
}
