import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

class SettingsProvider extends ChangeNotifier {
  double _fontSize = AppConstants.defaultFontSize;
  String _fontFamily = AppConstants.defaultFontFamily;
  TextAlign _textAlign = TextAlign.left;
  bool _lareevarMode = false;
  bool _showHindi = false;
  bool _showVishraams = true;
  String _backgroundTheme = AppConstants.themeLight;
  bool _fullScreenMode = false;

  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;
  TextAlign get textAlign => _textAlign;
  bool get lareevarMode => _lareevarMode;
  bool get showHindi => _showHindi;
  bool get showVishraams => _showVishraams;
  String get backgroundTheme => _backgroundTheme;
  bool get fullScreenMode => _fullScreenMode;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize =
        prefs.getDouble(AppConstants.keyFontSize) ?? AppConstants.defaultFontSize;
    _fontFamily =
        prefs.getString(AppConstants.keyFontFamily) ?? AppConstants.defaultFontFamily;
    final alignValue = prefs.getString(AppConstants.keyTextAlign) ?? 'left';
    _textAlign = _textAlignFromString(alignValue);
    _lareevarMode = prefs.getBool(AppConstants.keyLareevarMode) ?? false;
    _showHindi = prefs.getBool(AppConstants.keyShowHindi) ?? false;
    _showVishraams = prefs.getBool(AppConstants.keyShowVishraams) ?? true;
    _backgroundTheme =
        prefs.getString(AppConstants.keyBackgroundTheme) ?? AppConstants.themeLight;
    _fullScreenMode = prefs.getBool(AppConstants.keyFullScreenMode) ?? false;
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size.clamp(AppConstants.minFontSize, AppConstants.maxFontSize);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(AppConstants.keyFontSize, _fontSize);
  }

  Future<void> setFontFamily(String family) async {
    _fontFamily = family;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyFontFamily, _fontFamily);
  }

  Future<void> setTextAlign(TextAlign align) async {
    _textAlign = align;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyTextAlign, _textAlignToString(align));
  }

  Future<void> setLareevarMode(bool value) async {
    _lareevarMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyLareevarMode, _lareevarMode);
  }

  Future<void> setShowHindi(bool value) async {
    _showHindi = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyShowHindi, _showHindi);
  }

  Future<void> setShowVishraams(bool value) async {
    _showVishraams = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyShowVishraams, _showVishraams);
  }

  Future<void> setBackgroundTheme(String theme) async {
    _backgroundTheme = theme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyBackgroundTheme, _backgroundTheme);
  }

  Future<void> setFullScreenMode(bool value) async {
    _fullScreenMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyFullScreenMode, _fullScreenMode);
  }

  TextAlign _textAlignFromString(String value) {
    switch (value) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }

  String _textAlignToString(TextAlign align) {
    switch (align) {
      case TextAlign.center:
        return 'center';
      case TextAlign.right:
        return 'right';
      default:
        return 'left';
    }
  }
}
