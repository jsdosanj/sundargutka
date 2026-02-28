class AppConstants {
  // Font size
  static const double minFontSize = 14.0;
  static const double maxFontSize = 36.0;
  static const double defaultFontSize = 20.0;

  // Font families
  static const String defaultFontFamily = 'AnmolUnicode';
  static const List<String> availableFonts = [
    'AnmolUnicode',
    'Roboto',
  ];

  // Background themes
  static const String themeLight = 'light';
  static const String themeSepia = 'sepia';
  static const String themeDark = 'dark';

  // Bani categories
  static const String categoryTaksal = 'taksal';
  static const String categoryBuddaDal = 'buddaDal';
  static const String categoryHazuriDas = 'hazuriDas';

  static const Map<String, String> categoryNames = {
    categoryTaksal: 'Damdami Taksal',
    categoryBuddaDal: 'Budda Dal',
    categoryHazuriDas: 'Hazuri Das Granthi',
  };

  static const Map<String, String> categoryNamesGurmukhi = {
    categoryTaksal: 'ਦਮਦਮੀ ਟਕਸਾਲ',
    categoryBuddaDal: 'ਬੁੱਢਾ ਦਲ',
    categoryHazuriDas: 'ਹਾਜ਼ਰੀ ਦਾਸ ਗ੍ਰੰਥੀ',
  };

  // Nitnem bani IDs
  static const List<String> nitnemBaniIds = [
    'japji_sahib',
    'jaap_sahib',
    'tav_prasad_swayay',
    'chaupai_sahib',
    'anand_sahib',
    'rehras_sahib',
    'kirtan_sohila',
  ];

  // Vishraam types
  static const String vishraamLong = 'long';
  static const String vishraamShort = 'short';

  // SharedPreferences keys
  static const String keyFontSize = 'font_size';
  static const String keyFontFamily = 'font_family';
  static const String keyTextAlign = 'text_align';
  static const String keyLareevarMode = 'lareevar_mode';
  static const String keyShowHindi = 'show_hindi';
  static const String keyShowVishraams = 'show_vishraams';
  static const String keyBackgroundTheme = 'background_theme';
  static const String keyFullScreenMode = 'full_screen_mode';
  static const String keyBookmarks = 'bookmarks';
  static const String keyCustomLists = 'custom_lists';

  // Assets
  static const String baniCataloguePath = 'assets/bani/catalogue.json';
  static const String baniFolderPath = 'assets/bani/';

  // App info
  static const String appName = 'Sundar Gutka';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Sundar Gutka - Complete Gurbani Prayer Book\nDamdami Taksal Edition';
}
