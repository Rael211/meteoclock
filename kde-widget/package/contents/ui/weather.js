.pragma library

// SPDX-FileCopyrightText: 2026 Orlin Chotev <meteoclock@obla.us>
// SPDX-License-Identifier: GPL-3.0-or-later


// WMO weather interpretation codes used by Open-Meteo.
// Each entry: [breeze-icon base, English text, Bulgarian text]
var CODES = {
    0:  ["weather-clear",             "Clear sky",            "Ясно"],
    1:  ["weather-few-clouds",        "Mainly clear",         "Предимно ясно"],
    2:  ["weather-clouds",            "Partly cloudy",        "Променлива облачност"],
    3:  ["weather-many-clouds",       "Overcast",             "Облачно"],
    45: ["weather-fog",               "Fog",                  "Мъгла"],
    48: ["weather-fog",               "Rime fog",             "Скреж и мъгла"],
    51: ["weather-showers-scattered", "Light drizzle",        "Слаб ръмеж"],
    53: ["weather-showers-scattered", "Drizzle",              "Ръмеж"],
    55: ["weather-showers-scattered", "Dense drizzle",        "Силен ръмеж"],
    56: ["weather-freezing-rain",     "Freezing drizzle",     "Заледяващ ръмеж"],
    57: ["weather-freezing-rain",     "Freezing drizzle",     "Заледяващ ръмеж"],
    61: ["weather-showers",           "Light rain",           "Слаб дъжд"],
    63: ["weather-showers",           "Rain",                 "Дъжд"],
    65: ["weather-showers",           "Heavy rain",           "Силен дъжд"],
    66: ["weather-freezing-rain",     "Freezing rain",        "Заледяващ дъжд"],
    67: ["weather-freezing-rain",     "Freezing rain",        "Заледяващ дъжд"],
    71: ["weather-snow",              "Light snow",           "Слаб сняг"],
    73: ["weather-snow",              "Snow",                 "Сняг"],
    75: ["weather-snow",              "Heavy snow",           "Силен снеговалеж"],
    77: ["weather-snow",              "Snow grains",          "Снежни зърна"],
    80: ["weather-showers-scattered", "Light showers",        "Слаб дъжд на места"],
    81: ["weather-showers",           "Showers",              "Дъжд на места"],
    82: ["weather-showers",           "Violent showers",      "Проливен дъжд"],
    85: ["weather-snow",              "Snow showers",         "Снеговалеж на места"],
    86: ["weather-snow",              "Heavy snow showers",   "Силен снеговалеж"],
    95: ["weather-storm",             "Thunderstorm",         "Гръмотевична буря"],
    96: ["weather-hail",              "Thunderstorm, hail",   "Буря с град"],
    99: ["weather-hail",              "Thunderstorm, hail",   "Буря с град"]
}

// Icons that have a distinct night variant in the Breeze icon set.
var NIGHT_VARIANTS = {
    "weather-clear": "weather-clear-night",
    "weather-few-clouds": "weather-few-clouds-night",
    "weather-clouds": "weather-clouds-night",
    "weather-showers-scattered": "weather-showers-scattered-night",
    "weather-showers": "weather-showers-night",
    "weather-snow": "weather-snow-scattered-night",
    "weather-storm": "weather-storm-night"
}

function entry(code) {
    return CODES[code] !== undefined ? CODES[code] : ["weather-none-available", "Unknown", "Неизвестно"]
}

function iconFor(code, isDay) {
    var base = entry(code)[0]
    if (!isDay && NIGHT_VARIANTS[base] !== undefined) {
        return NIGHT_VARIANTS[base]
    }
    return base
}

function textFor(code, lang) {
    var e = entry(code)
    return lang === "bg" ? e[2] : e[1]
}

// The feed is entity-encoded plain text; QML gives us no DOM parser here.
function decodeEntities(s) {
    return s.replace(/<!\[CDATA\[/g, "")
            .replace(/\]\]>/g, "")
            .replace(/&lt;/g, "<")
            .replace(/&gt;/g, ">")
            .replace(/&quot;/g, '"')
            .replace(/&apos;/g, "'")
            .replace(/&#(\d+);/g, function (m, d) { return String.fromCharCode(parseInt(d, 10)) })
            .replace(/&amp;/g, "&")
            .trim()
}

function parseRss(xmlText) {
    var out = []
    var itemRe = /<item>([\s\S]*?)<\/item>/g
    var titleRe = /<title>([\s\S]*?)<\/title>/
    var linkRe = /<link>([\s\S]*?)<\/link>/
    var m
    while ((m = itemRe.exec(xmlText)) !== null) {
        var block = m[1]
        var t = titleRe.exec(block)
        if (!t) {
            continue
        }
        var l = linkRe.exec(block)
        out.push({
            title: decodeEntities(t[1]),
            link: l ? decodeEntities(l[1]) : ""
        })
    }
    return out
}

// --- city lookup ----------------------------------------------------------
// Open-Meteo geocoding matches the town name only, so "Corinth, TX" would
// return Corinth, Mississippi. The suffix the user typed is matched against
// the region and country of the candidates instead.
var US_STATES = {
    AL: "Alabama", AK: "Alaska", AZ: "Arizona", AR: "Arkansas", CA: "California",
    CO: "Colorado", CT: "Connecticut", DE: "Delaware", DC: "District of Columbia",
    FL: "Florida", GA: "Georgia", HI: "Hawaii", ID: "Idaho", IL: "Illinois",
    IN: "Indiana", IA: "Iowa", KS: "Kansas", KY: "Kentucky", LA: "Louisiana",
    ME: "Maine", MD: "Maryland", MA: "Massachusetts", MI: "Michigan",
    MN: "Minnesota", MS: "Mississippi", MO: "Missouri", MT: "Montana",
    NE: "Nebraska", NV: "Nevada", NH: "New Hampshire", NJ: "New Jersey",
    NM: "New Mexico", NY: "New York", NC: "North Carolina", ND: "North Dakota",
    OH: "Ohio", OK: "Oklahoma", OR: "Oregon", PA: "Pennsylvania",
    RI: "Rhode Island", SC: "South Carolina", SD: "South Dakota", TN: "Tennessee",
    TX: "Texas", UT: "Utah", VT: "Vermont", VA: "Virginia", WA: "Washington",
    WV: "West Virginia", WI: "Wisconsin", WY: "Wyoming", PR: "Puerto Rico"
}

function cityPart(query) {
    return query.split(",")[0].trim()
}

function regionPart(query) {
    var parts = query.split(",")
    return parts.length > 1 ? parts.slice(1).join(",").trim() : ""
}

function pickResult(results, query) {
    if (!results || results.length === 0) {
        return null
    }
    var region = regionPart(query)
    if (region === "") {
        return results[0]
    }
    var short = region.toUpperCase()
    var wanted = (US_STATES[short] !== undefined ? US_STATES[short] : region).toLowerCase()

    for (var i = 0; i < results.length; i++) {
        var r = results[i]
        if (r.admin1 && r.admin1.toLowerCase() === wanted) {
            return r
        }
        if (r.country && r.country.toLowerCase() === wanted) {
            return r
        }
        if (r.country_code && r.country_code.toLowerCase() === region.toLowerCase()) {
            return r
        }
    }
    // Nothing matched the suffix: a partial region name is better than nothing.
    for (var j = 0; j < results.length; j++) {
        var c = results[j]
        if (c.admin1 && c.admin1.toLowerCase().indexOf(wanted) === 0) {
            return c
        }
    }
    return null
}

function displayName(hit) {
    if (hit.country_code === "US" && hit.admin1) {
        return hit.name + ", " + hit.admin1
    }
    if (hit.country && hit.country !== hit.name) {
        return hit.name + ", " + hit.country
    }
    return hit.name
}
