import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/bookmark.dart';

class BookmarkService {
  Future<List<Bookmark>> loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(AppConstants.keyBookmarks);
      if (jsonStr == null) return [];
      final decoded = json.decode(jsonStr);
      if (decoded is! List) return [];
      final result = <Bookmark>[];
      for (final e in decoded) {
        if (e is Map<String, dynamic>) {
          try {
            result.add(Bookmark.fromJson(e));
          } on FormatException {
            continue;
          }
        }
      }
      return result;
    } on FormatException {
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> saveBookmarks(List<Bookmark> bookmarks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = json.encode(bookmarks.map((b) => b.toJson()).toList());
      await prefs.setString(AppConstants.keyBookmarks, jsonStr);
    } on FormatException {
      // Encoding failure — non-fatal
    } catch (_) {
      // Storage write failure — non-fatal
    }
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    final bookmarks = await loadBookmarks();
    if (!bookmarks.any((b) => b.id == bookmark.id)) {
      bookmarks.insert(0, bookmark);
      await saveBookmarks(bookmarks);
    }
  }

  Future<void> removeBookmark(String id) async {
    final bookmarks = await loadBookmarks();
    bookmarks.removeWhere((b) => b.id == id);
    await saveBookmarks(bookmarks);
  }
}
