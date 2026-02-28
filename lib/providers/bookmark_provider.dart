import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/bookmark.dart';

class BookmarkProvider extends ChangeNotifier {
  List<Bookmark> _bookmarks = [];

  /// Maximum number of bookmarks a user can store.
  static const int maxBookmarks = 500;

  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);

  bool isBookmarked(String baniId, int verseIndex) =>
      _bookmarks.any((b) => b.baniId == baniId && b.verseIndex == verseIndex);

  Future<void> loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(AppConstants.keyBookmarks);
      if (jsonStr != null) {
        final decoded = json.decode(jsonStr);
        if (decoded is List) {
          final loaded = <Bookmark>[];
          for (final e in decoded) {
            if (e is Map<String, dynamic>) {
              try {
                loaded.add(Bookmark.fromJson(e));
              } on FormatException {
                // Skip individual corrupt bookmark entries
                continue;
              }
            }
          }
          _bookmarks = loaded;
        }
      }
    } on FormatException {
      _bookmarks = [];
    } catch (_) {
      _bookmarks = [];
    }
    notifyListeners();
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    if (_bookmarks.length >= maxBookmarks) return;
    if (!_bookmarks.contains(bookmark)) {
      _bookmarks.insert(0, bookmark);
      notifyListeners();
      await _save();
    }
  }

  Future<void> removeBookmark(String id) async {
    _bookmarks.removeWhere((b) => b.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> removeBookmarkByVerse(String baniId, int verseIndex) async {
    _bookmarks.removeWhere(
        (b) => b.baniId == baniId && b.verseIndex == verseIndex);
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = json.encode(_bookmarks.map((b) => b.toJson()).toList());
      await prefs.setString(AppConstants.keyBookmarks, jsonStr);
    } on FormatException {
      // JSON encoding failure — data stays in memory but not persisted
    } catch (_) {
      // Storage write failure — non-fatal
    }
  }
}
