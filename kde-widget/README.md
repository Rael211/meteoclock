# MeteoClock — KDE Plasma 6 widget

Desktop port of the MeteoClock face: clock, date, weather and the Fact Refinery
news ticker. Built 2026-09-17, installed on ProArt (`com.obla.meteoclock`).

## Install / update
```bash
kpackagetool6 -t Plasma/Applet --install package     # first time
kpackagetool6 -t Plasma/Applet --upgrade package     # after edits
```
Then right click the desktop → Add Widgets → MeteoClock. Panel placement works
too: it collapses to icon + temperature + time.

## What it does
- **Weather** from Open-Meteo (no API key, no GPS) — city is resolved by name
  through Open-Meteo geocoding, `°C`/`°F` switchable.
- **Clock** in 12/24 h, optional seconds, localized date.
- **Night dimming** driven by the API's `is_day` for the chosen city, not by the
  machine's clock, so a remote city dims at its own sunset.
- **News ticker** from `https://www.factrefinery.com/rss.xml?lang=XX`
  (bg, en, de, es, hi, zh). Headlines fade in turn; a headline too long for the
  widget slides, as the phone app has done since 1.14. Clicking one opens the
  article.
- Three layouts: Modern (stacked), Side by side, Card.
- **Background**: Plasma theme (default), Translucent, Tinted panel with an
  opacity slider, or None with a text shadow.

## Traps worth keeping
- The feed needs `www.` — the bare domain 301s, and Cloudflare drops bare
  library user agents. QML's default `Mozilla/5.0` passes (verified).
- An unknown `lang` falls back silently to the mixed feed, which puts foreign
  headlines in the ticker; that is why the language is a fixed list, not a field.
- The red NEWS label is hidden below ~24 grid units of width. On the phone it
  once ate a third of the ticker (fixed in app 1.13); the same happens here in a
  narrow panel popup.
- Weather text ships in English and Bulgarian and follows the desktop locale.
- With no background Plasma gives the widget the complementary colour set, i.e.
  white text, which disappears on a light wallpaper. That is why the theme
  background is the default and "None" carries a shadow.
- The geocoder matches the town name only, so "Corinth, TX" returned Mississippi.
  Ten candidates are fetched and the suffix is matched against region and
  country, with US state abbreviations expanded. A ZIP code goes straight
  through.

## Not ported
- The 20 phone themes. Plasma themes the widget itself; three layouts cover the
  same ground without fighting the desktop's colours.
- Background images (Bing/Unsplash). A desktop widget sits on the wallpaper.
- The clock shows machine time, not the selected city's time. Open-Meteo returns
  `utc_offset_seconds`, so a "clock follows the city" option is a small change if
  it is wanted.
