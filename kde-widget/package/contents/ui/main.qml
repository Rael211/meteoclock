// SPDX-FileCopyrightText: 2026 Orlin Chotev <meteoclock@obla.us>
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import "weather.js" as Weather

PlasmoidItem {
    id: root

    // --- configuration shortcuts ---
    readonly property string cfgCity: Plasmoid.configuration.city
    readonly property bool cfgMetric: Plasmoid.configuration.metric
    readonly property bool cfg24h: Plasmoid.configuration.use24h
    readonly property bool cfgSeconds: Plasmoid.configuration.showSeconds
    readonly property bool cfgDate: Plasmoid.configuration.showDate
    readonly property string cfgLayout: Plasmoid.configuration.layout
    readonly property bool cfgDim: Plasmoid.configuration.dimAtNight
    readonly property string cfgBackground: Plasmoid.configuration.background
    readonly property bool cfgNews: Plasmoid.configuration.showNews
    readonly property string cfgNewsLang: Plasmoid.configuration.newsLang

    // --- live state ---
    property string timeText: ""
    property string dateText: ""
    property string locationText: cfgCity
    property double latitude: NaN
    property double longitude: NaN
    property string geocodedFor: ""
    property int weatherCode: -1
    property bool isDay: true
    property double temperature: NaN
    property string statusText: ""

    property var newsItems: []
    property int newsIndex: 0
    // The ticker lives inside fullRepresentation, whose ids are out of scope
    // here, so the current headline is root state the ticker binds to.
    readonly property string currentHeadline: newsItems.length > 0 ? newsItems[newsIndex].title : ""
    readonly property string currentLink: newsItems.length > 0 ? newsItems[newsIndex].link : ""

    readonly property string uiLang: Qt.locale().name.substring(0, 2) === "bg" ? "bg" : "en"
    readonly property string unitSuffix: cfgMetric ? "°C" : "°F"
    readonly property bool hasWeather: !isNaN(temperature) && weatherCode >= 0
    readonly property string iconName: hasWeather ? Weather.iconFor(weatherCode, isDay) : "weather-none-available"
    readonly property string conditionText: hasWeather ? Weather.textFor(weatherCode, uiLang) : statusText
    readonly property string tempText: hasWeather ? Math.round(temperature) + unitSuffix : "--"
    readonly property bool dimmed: cfgDim && !isDay

    // No background means Plasma hands the widget the complementary colour set,
    // which is white text: unreadable on a light wallpaper. The theme background
    // is therefore the default, and "none" comes with a text shadow.
    // Deliberately NOT ConfigurableBackground: with that flag Plasma stores a
    // per-widget userBackgroundHints and it silently outranks this setting, so
    // the Background box appeared to do nothing.
    Plasmoid.backgroundHints: {
        if (cfgBackground === "theme") {
            return PlasmaCore.Types.StandardBackground
        }
        if (cfgBackground === "translucent") {
            return PlasmaCore.Types.TranslucentBackground
        }
        return PlasmaCore.Types.NoBackground
    }
    preferredRepresentation: Plasmoid.formFactor === PlasmaCore.Types.Planar
                             ? fullRepresentation : compactRepresentation
    switchWidth: Kirigami.Units.gridUnit * 10
    switchHeight: Kirigami.Units.gridUnit * 6
    toolTipMainText: locationText + "  " + tempText
    toolTipSubText: conditionText

    // ---------------------------------------------------------------- network
    function getJson(url, onOk) {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE) {
                return
            }
            if (xhr.status === 200) {
                try {
                    onOk(JSON.parse(xhr.responseText))
                    return
                } catch (e) {
                    // fall through to the error path below
                }
            }
            root.statusText = root.uiLang === "bg" ? "Няма връзка" : "No connection"
        }
        xhr.open("GET", url)
        xhr.send()
    }

    function refreshWeather() {
        if (cfgCity.trim() === "") {
            return
        }
        if (geocodedFor === cfgCity && !isNaN(latitude)) {
            fetchForecast()
            return
        }
        statusText = uiLang === "bg" ? "Търсене..." : "Locating..."
        // Open-Meteo geocoding: no key, no GPS permission, exactly like the app.
        // Ten candidates, because the name alone is ambiguous: "Corinth" alone
        // lands in Mississippi when Corinth, TX was meant.
        var url = "https://geocoding-api.open-meteo.com/v1/search?name="
                + encodeURIComponent(Weather.cityPart(cfgCity))
                + "&count=10&language=" + uiLang + "&format=json"
        getJson(url, function (data) {
            var hit = Weather.pickResult(data.results, root.cfgCity)
            if (!hit) {
                root.statusText = root.uiLang === "bg" ? "Градът не е намерен" : "City not found"
                return
            }
            root.latitude = hit.latitude
            root.longitude = hit.longitude
            root.geocodedFor = root.cfgCity
            root.locationText = Weather.displayName(hit)
            root.fetchForecast()
        })
    }

    function fetchForecast() {
        var url = "https://api.open-meteo.com/v1/forecast?latitude=" + latitude
                + "&longitude=" + longitude
                + "&current=temperature_2m,weather_code,is_day&timezone=auto"
                + "&temperature_unit=" + (cfgMetric ? "celsius" : "fahrenheit")
        getJson(url, function (data) {
            if (!data.current) {
                return
            }
            root.temperature = data.current.temperature_2m
            root.weatherCode = data.current.weather_code
            root.isDay = data.current.is_day === 1
            root.statusText = ""
        })
    }

    function refreshNews() {
        if (!cfgNews) {
            return
        }
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE || xhr.status !== 200) {
                return
            }
            var items = Weather.parseRss(xhr.responseText)
            if (items.length > 0) {
                root.newsItems = items
                root.newsIndex = 0
            }
        }
        // www. is required: the bare domain 301s and Cloudflare drops bare user agents.
        xhr.open("GET", "https://www.factrefinery.com/rss.xml?lang=" + cfgNewsLang)
        xhr.send()
    }

    function advanceNews() {
        if (newsItems.length > 0) {
            newsIndex = (newsIndex + 1) % newsItems.length
        }
    }

    function updateClock() {
        var now = new Date()
        var fmt = (cfg24h ? "HH:mm" : "h:mm") + (cfgSeconds ? ":ss" : "") + (cfg24h ? "" : " AP")
        timeText = Qt.formatTime(now, fmt)
        dateText = now.toLocaleDateString(Qt.locale(), "dddd, d MMMM")
    }

    Component.onCompleted: {
        updateClock()
        refreshWeather()
        refreshNews()
    }

    onCfgCityChanged: refreshWeather()
    onCfgMetricChanged: if (!isNaN(latitude)) fetchForecast()
    onCfgNewsLangChanged: refreshNews()
    onCfgNewsChanged: refreshNews()
    onCfg24hChanged: updateClock()
    onCfgSecondsChanged: updateClock()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateClock()
    }
    Timer {
        interval: Math.max(5, Plasmoid.configuration.refreshMinutes) * 60000
        running: true
        repeat: true
        onTriggered: root.refreshWeather()
    }
    Timer {
        interval: 30 * 60000
        running: root.cfgNews
        repeat: true
        onTriggered: root.refreshNews()
    }

    // ------------------------------------------------------------ compact view
    compactRepresentation: MouseArea {
        Layout.minimumWidth: compactRow.implicitWidth
        hoverEnabled: true
        onClicked: root.expanded = !root.expanded

        RowLayout {
            id: compactRow
            anchors.fill: parent
            spacing: Kirigami.Units.smallSpacing

            Kirigami.Icon {
                source: root.iconName
                Layout.fillHeight: true
                Layout.preferredWidth: height
            }
            PlasmaComponents.Label {
                text: root.tempText
                font.pixelSize: Math.round(parent.height * 0.42)
            }
            PlasmaComponents.Label {
                text: root.timeText
                font.bold: true
                font.pixelSize: Math.round(parent.height * 0.48)
            }
        }
    }

    // --------------------------------------------------------------- full view
    fullRepresentation: Item {
        id: face
        Layout.minimumWidth: Kirigami.Units.gridUnit * 12
        Layout.minimumHeight: Kirigami.Units.gridUnit * 7
        Layout.preferredWidth: Kirigami.Units.gridUnit * 22
        Layout.preferredHeight: Kirigami.Units.gridUnit * 12

        readonly property real tickerHeight: root.cfgNews && root.newsItems.length > 0
                ? Math.max(Kirigami.Units.gridUnit * 1.6, height * 0.16) : 0
        readonly property real bodyHeight: height - tickerHeight
        readonly property bool wide: root.cfgLayout === "row"

        Rectangle {
            id: card
            anchors.fill: parent
            visible: root.cfgBackground === "tint" || root.cfgLayout === "card"
            radius: Kirigami.Units.cornerRadius
            color: Kirigami.Theme.backgroundColor
            opacity: root.cfgBackground === "tint"
                     ? Plasmoid.configuration.tintOpacity / 100 : 0.35
        }

        Item {
            id: body
            width: parent.width
            height: face.bodyHeight
            // The whole face dims after dark, the ticker keeps its own contrast.
            // Without a background Plasma hands out the complementary set (white
            // text for the wallpaper); with one, normal window colours must be
            // used or the text is white on a light theme panel.
            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: root.cfgBackground === "none"
                    ? Kirigami.Theme.Complementary : Kirigami.Theme.Window

            opacity: root.dimmed ? 0.55 : 1.0
            Behavior on opacity {
                NumberAnimation { duration: 800 }
            }

            // Standing in for the CSS text-shadow of the original face: without
            // it, bare text on a busy wallpaper is unreadable either way round.
            layer.enabled: root.cfgBackground === "none"
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "black"
                shadowOpacity: 0.85
                shadowBlur: 0.7
                shadowVerticalOffset: 2
            }

            // -- stacked layouts: modern and card
            ColumnLayout {
                anchors.centerIn: parent
                width: parent.width - Kirigami.Units.largeSpacing * 2
                visible: !face.wide
                spacing: 0

                PlasmaComponents.Label {
                    Layout.alignment: Qt.AlignHCenter
                    text: root.timeText
                    font.bold: true
                    font.pixelSize: Math.round(body.height * 0.34)
                }
                PlasmaComponents.Label {
                    Layout.alignment: Qt.AlignHCenter
                    visible: root.cfgDate
                    text: root.dateText
                    opacity: 0.8
                    elide: Text.ElideRight
                    Layout.maximumWidth: parent.width
                    font.pixelSize: Math.round(body.height * 0.09)
                }
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: Kirigami.Units.smallSpacing
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Icon {
                        source: root.iconName
                        implicitWidth: Math.round(body.height * 0.18)
                        implicitHeight: implicitWidth
                    }
                    PlasmaComponents.Label {
                        text: root.tempText
                        font.pixelSize: Math.round(body.height * 0.16)
                    }
                    PlasmaComponents.Label {
                        text: root.conditionText
                        opacity: 0.8
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        font.pixelSize: Math.round(body.height * 0.1)
                    }
                }
                PlasmaComponents.Label {
                    Layout.alignment: Qt.AlignHCenter
                    text: root.locationText
                    opacity: 0.6
                    elide: Text.ElideRight
                    Layout.maximumWidth: parent.width
                    font.pixelSize: Math.round(body.height * 0.09)
                }
            }

            // -- side by side layout: weather left, clock right
            RowLayout {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.largeSpacing
                visible: face.wide
                spacing: Kirigami.Units.largeSpacing

                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 0

                    Kirigami.Icon {
                        Layout.alignment: Qt.AlignHCenter
                        source: root.iconName
                        implicitWidth: Math.round(body.height * 0.34)
                        implicitHeight: implicitWidth
                    }
                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignHCenter
                        text: root.tempText
                        font.pixelSize: Math.round(body.height * 0.2)
                    }
                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignHCenter
                        text: root.conditionText
                        opacity: 0.8
                        font.pixelSize: Math.round(body.height * 0.1)
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 0

                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignRight
                        text: root.timeText
                        font.bold: true
                        font.pixelSize: Math.round(body.height * 0.38)
                    }
                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignRight
                        visible: root.cfgDate
                        text: root.dateText
                        opacity: 0.8
                        font.pixelSize: Math.round(body.height * 0.1)
                    }
                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignRight
                        text: root.locationText
                        opacity: 0.6
                        font.pixelSize: Math.round(body.height * 0.1)
                    }
                }
            }
        }

        // ------------------------------------------------------------- ticker
        Item {
            id: ticker
            anchors.bottom: parent.bottom
            width: parent.width
            height: face.tickerHeight
            visible: height > 0

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.8)
                radius: root.cfgLayout === "card" ? Kirigami.Units.cornerRadius : 0
            }

            RowLayout {
                anchors.fill: parent
                spacing: 0

                // The label is dropped on narrow widgets and kept small everywhere:
                // on the phone it once ate a third of the ticker.
                Rectangle {
                    visible: ticker.width > Kirigami.Units.gridUnit * 24
                    color: "#ff3b30"
                    Layout.fillHeight: true
                    Layout.preferredWidth: labelText.implicitWidth + Kirigami.Units.smallSpacing * 4

                    PlasmaComponents.Label {
                        id: labelText
                        anchors.centerIn: parent
                        text: root.cfgNewsLang === "bg" ? "НОВИНИ" : "NEWS"
                        color: "white"
                        font.bold: true
                        font.pixelSize: Math.round(ticker.height * 0.32)
                    }
                }

                Item {
                    id: headlineClip
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.leftMargin: Kirigami.Units.largeSpacing
                    Layout.rightMargin: Kirigami.Units.largeSpacing
                    clip: true

                    PlasmaComponents.Label {
                        id: headline
                        y: Math.round((headlineClip.height - height) / 2)
                        text: root.currentHeadline
                        onTextChanged: {
                            headline.x = 0
                            headline.opacity = headline.text === "" ? 0 : 1
                        }
                        color: "#eeeeee"
                        font.pixelSize: Math.round(ticker.height * 0.46)
                        opacity: 0

                        // A headline too long for the widget slides instead of
                        // being cut off, as the phone app does since 1.14.
                        readonly property real overflow: Math.max(0, implicitWidth - headlineClip.width)

                        Behavior on opacity {
                            NumberAnimation { duration: 500 }
                        }

                        SequentialAnimation on x {
                            running: headline.overflow > 0 && headline.opacity > 0
                            loops: Animation.Infinite

                            PauseAnimation { duration: 2500 }
                            NumberAnimation {
                                to: -headline.overflow
                                duration: Math.round(headline.overflow * 28)
                            }
                            PauseAnimation { duration: 2500 }
                            NumberAnimation { to: 0; duration: 600 }
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.currentLink !== "") {
                        Qt.openUrlExternally(root.currentLink)
                    }
                }
            }

            SequentialAnimation {
                id: rotation
                running: ticker.visible && root.newsItems.length > 1
                loops: Animation.Infinite

                PauseAnimation {
                    duration: Math.max(3, Plasmoid.configuration.tickerSeconds) * 1000
                }
                ScriptAction {
                    script: headline.opacity = 0
                }
                PauseAnimation { duration: 500 }
                ScriptAction {
                    script: root.advanceNews()
                }
            }
        }

        MouseArea {
            anchors.fill: body
            acceptedButtons: Qt.LeftButton
            onDoubleClicked: root.refreshWeather()
        }
    }

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Refresh now")
            icon.name: "view-refresh"
            onTriggered: {
                root.refreshWeather()
                root.refreshNews()
            }
        }
    ]
}
