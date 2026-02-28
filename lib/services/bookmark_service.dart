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
      final List<dynamic> decoded = json.decode(jsonStr) as List;
      return decoded
          .map((e) => Bookmark.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveBookmarks(List<Bookmark> bookmarks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = json.encode(bookmarks.map((b) => b.toJson()).toList());
      await prefs.setString(AppConstants.keyBookmarks, jsonStr);
    } catch (_) {}
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
