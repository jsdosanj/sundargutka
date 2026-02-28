import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/bookmark.dart';

class BookmarkProvider extends ChangeNotifier {
  List<Bookmark> _bookmarks = [];

  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);

  bool isBookmarked(String baniId, int verseIndex) =>
      _bookmarks.any((b) => b.baniId == baniId && b.verseIndex == verseIndex);

  Future<void> loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(AppConstants.keyBookmarks);
      if (jsonStr != null) {
        final List<dynamic> decoded = json.decode(jsonStr) as List;
        _bookmarks = decoded
            .map((e) => Bookmark.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      _bookmarks = [];
    }
    notifyListeners();
  }

  Future<void> addBookmark(Bookmark bookmark) async {
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
    } catch (_) {}
  }
}
