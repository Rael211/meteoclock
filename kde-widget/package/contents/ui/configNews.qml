// SPDX-FileCopyrightText: 2026 Orlin Chotev <meteoclock@obla.us>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_showNews: newsBox.checked
    property alias cfg_tickerSeconds: tickerSpin.value
    property string cfg_newsLang
    property string cfg_newsLangDefault

    Kirigami.FormLayout {
        QQC2.CheckBox {
            id: newsBox
            Kirigami.FormData.label: i18n("News ticker:")
            text: i18n("Show headlines from Fact Refinery")
        }

        QQC2.ComboBox {
            id: langCombo
            Kirigami.FormData.label: i18n("Language:")
            enabled: newsBox.checked
            textRole: "label"
            valueRole: "key"
            // The feed serves exactly these six; an unknown code falls back to
            // the mixed feed, which puts foreign headlines in the ticker.
            model: [
                { key: "bg", label: i18n("Bulgarian") },
                { key: "en", label: i18n("English") },
                { key: "de", label: i18n("German") },
                { key: "es", label: i18n("Spanish") },
                { key: "hi", label: i18n("Hindi") },
                { key: "zh", label: i18n("Chinese") }
            ]
            onActivated: cfg_newsLang = currentValue
            Component.onCompleted: currentIndex = Math.max(0, indexOfValue(cfg_newsLang))
        }

        QQC2.SpinBox {
            id: tickerSpin
            Kirigami.FormData.label: i18n("Headline stays for:")
            enabled: newsBox.checked
            from: 3
            to: 60
            textFromValue: function (value) { return i18n("%1 seconds", value) }
            valueFromText: function (text) { return parseInt(text, 10) }
        }

        QQC2.Label {
            text: i18n("Clicking a headline opens the article in your browser.")
            opacity: 0.7
            font: Kirigami.Theme.smallFont
        }
    }
}
