# ਸੁੰਦਰ ਗੁਟਕਾ — Sundar Gutka

> **Complete Gurbani Prayer Book App** for iOS and Android  
> Damdami Taksal Edition

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey)]()

---

## Features

- 📖 **Complete Bani collection** — 40+ Banis across three traditions
  - Damdami Taksal (Nitnem + extended)
  - Budda Dal
  - Hazuri Das Granthi
- 🌅 **Vishraam (pause) highlighting** — Orange for long, green for short (jamki) pauses
- 🔤 **Adjustable typography** — Font size slider (14–36px), AnmolUnicode/Roboto
- 🎨 **Three themes** — Light, Sepia, Dark/Night mode
- 📝 **Lareevar mode** — Continuous Gurmukhi text without spaces
- 🇮🇳 **Hindi transliteration** — Toggle on/off
- 🔖 **Bookmarks** — Save and jump to any verse
- 📋 **Custom lists** — Create reorderable personal reading lists
- 🔍 **Search** — Find Banis by Gurmukhi or English name
- 📵 **Full-screen reading** mode

---

## Screenshots

| Home | Reader | Settings |
|------|--------|----------|
| *(coming soon)* | *(coming soon)* | *(coming soon)* |

---

## Setup & Build

### Prerequisites
- Flutter SDK ≥ 3.0.0 (install from https://flutter.dev)
- Android Studio or Xcode
- AnmolUnicode font file placed at `assets/fonts/AnmolUnicode.ttf`

### Getting Started

```bash
git clone https://github.com/sundargutka/sundargutka.git
cd sundargutka

# Install dependencies
flutter pub get

# Run on device/simulator
flutter run

# Build for Android
flutter build apk --release

# Build for iOS
flutter build ios --release
```

### Data Setup

The repo ships with sample verses. For complete Gurbani data, see [`assets/bani/data_sources.md`](assets/bani/data_sources.md).

```bash
# Using BaniDB API to fetch complete Japji Sahib:
curl https://api.banidb.com/v2/banis/1/complete > assets/bani/japji_sahib_full.json
```

---

## Project Structure

```
lib/
├── config/          # Theme, constants, routes
├── models/          # Bani, Verse, Bookmark, CustomList
├── providers/       # State management (Provider/ChangeNotifier)
├── screens/         # Home, Reader, Settings, Bookmarks, CustomList, About
├── services/        # BaniDataService, StorageService, BookmarkService
├── utils/           # GurmukhiUtils, TransliterationUtils
└── widgets/         # BaniTile, VerseWidget, VishraamText, CategoryHeader, ...

assets/
├── bani/            # catalogue.json + individual bani JSON files
├── fonts/           # AnmolUnicode.ttf
└── images/          # App assets

test/
├── models/          # Unit tests for models
├── utils/           # Unit tests for utilities
└── widget_test.dart # Widget tests
```

---

## Vishraam Credit

> Sewa of adding Vishraams and proofreading Bani was performed by  
> **Baba Darshan Singh (Mallehwal)**, student of  
> **Sant Giani Gurbachan Singh Ji (Bhindranwale)**

Vishraam data sourced from the [ShabadOS Database](https://github.com/shabados/database).

---

## Data Sources

| Source | URL | License |
|--------|-----|---------|
| **ShabadOS Database** | https://github.com/shabados/database | CC BY-NC-SA 4.0 |
| **BaniDB** | https://banidb.com | CC BY-NC-SA 4.0 |
| **GurbaniNow** | https://gurbaninow.com | — |

---

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a Pull Request

### Adding Bani Data
Please see [`assets/bani/data_sources.md`](assets/bani/data_sources.md) for the JSON format and how to contribute complete bani text.

---

## License

This project is licensed under the [MIT License](LICENSE).  
Gurbani text is the eternal Word of the Guru and belongs to the Sikh Panth.

---

## ਵਾਹਿਗੁਰੂ ਜੀ ਕਾ ਖ਼ਾਲਸਾ, ਵਾਹਿਗੁਰੂ ਜੀ ਕੀ ਫ਼ਤਹਿ
Complete Sundar Gutka App written using Flutter for iOS &amp; Android
