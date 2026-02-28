# Gurbani Data Sources

## Overview

This app uses Gurbani text data. The sample verses included in this repository 
are for demonstration purposes. To get complete, accurate Bani data, please use 
the following open-source databases:

## Data Sources

### 1. BaniDB (Recommended)
- **URL**: https://banidb.com
- **GitHub**: https://github.com/KhalisFoundation/banidb-api
- **API**: RESTful API available at `https://api.banidb.com/v2/`
- **License**: Creative Commons Attribution-NonCommercial-ShareAlike 4.0

To fetch complete Japji Sahib:
```
GET https://api.banidb.com/v2/banis/1/complete
```

### 2. ShabadOS Database
- **GitHub**: https://github.com/shabados/database
- **Contains**: Complete SGGS, Dasam Granth, Bhai Gurdas Vaaran, Bhai Nand Lal
- **Includes**: Vishraam (pause) data from the Damdami Taksal tradition
- **License**: Creative Commons Attribution-NonCommercial-ShareAlike 4.0

### 3. GurbaniNow API
- **URL**: https://gurbaninow.com/

## Vishraam Data Credit

The vishraam (pause) markings used in this app are based on the sewa performed 
by **Baba Darshan Singh (Mallehwal)**, student of **Sant Giani Gurbachan Singh Ji 
(Bhindranwale)** of Damdami Taksal.

Orange (॥) marks indicate long vishraams (full pause).
Green marks indicate short vishraams / jamki (brief pause).

## How to Replace Sample Data

1. Download the complete JSON from BaniDB or ShabadOS
2. Transform into the format used by this app (see `assets/bani/japji_sahib.json` for format)
3. Place the files in `assets/bani/`
4. Update `assets/bani/catalogue.json` as needed

## Bani File Format

```json
{
  "id": "bani_id",
  "nameGurmukhi": "ਜਪੁ",
  "nameEnglish": "Japji Sahib",
  "author": "Guru Nanak Dev Ji",
  "verses": [
    {
      "id": 1,
      "verseNumber": 1,
      "section": "Section Name",
      "gurmukhi": "Gurmukhi text",
      "hindi": "Hindi transliteration",
      "english": "English transliteration",
      "translation": "English translation",
      "vishraams": [
        {"position": 2, "type": "long"},
        {"position": 5, "type": "short"}
      ]
    }
  ]
}
```

Position in vishraams is 0-indexed word position in the gurmukhi string split by spaces.
