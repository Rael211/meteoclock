import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "weather-few-clouds"
        source: "configGeneral.qml"
    }
    ConfigCategory {
        name: i18n("News")
        icon: "news-subscribe"
        source: "configNews.qml"
    }
}
