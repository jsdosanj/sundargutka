import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/custom_list.dart';

class CustomListProvider extends ChangeNotifier {
  List<CustomList> _lists = [];

  /// Maximum number of custom lists a user can create.
  static const int maxLists = 100;

  /// Maximum character length for a list name.
  static const int maxNameLength = 100;

  List<CustomList> get lists => List.unmodifiable(_lists);

  Future<void> loadLists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(AppConstants.keyCustomLists);
      if (jsonStr != null) {
        final decoded = json.decode(jsonStr);
        if (decoded is List) {
          final loaded = <CustomList>[];
          for (final e in decoded) {
            if (e is Map<String, dynamic>) {
              try {
                loaded.add(CustomList.fromJson(e));
              } on FormatException {
                // Skip individual corrupt list entries
                continue;
              }
            }
          }
          _lists = loaded;
        }
      }
    } on FormatException {
      _lists = [];
    } catch (_) {
      _lists = [];
    }
    notifyListeners();
  }

  Future<void> createList(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > maxNameLength) return;
    if (_lists.length >= maxLists) return;

    final list = CustomList(
      id: _generateId(),
      name: trimmed,
      baniIds: [],
      createdAt: DateTime.now(),
    );
    _lists.add(list);
    notifyListeners();
    await _save();
  }

  Future<void> deleteList(String id) async {
    _lists.removeWhere((l) => l.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> renameList(String id, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty || trimmed.length > maxNameLength) return;
    final idx = _lists.indexWhere((l) => l.id == id);
    if (idx >= 0) {
      _lists[idx] = _lists[idx].copyWith(name: trimmed);
      notifyListeners();
      await _save();
    }
  }

  Future<void> addBaniToList(String listId, String baniId) async {
    final idx = _lists.indexWhere((l) => l.id == listId);
    if (idx >= 0 && !_lists[idx].baniIds.contains(baniId)) {
      final updated = List<String>.from(_lists[idx].baniIds)..add(baniId);
      _lists[idx] = _lists[idx].copyWith(baniIds: updated);
      notifyListeners();
      await _save();
    }
  }

  Future<void> removeBaniFromList(String listId, String baniId) async {
    final idx = _lists.indexWhere((l) => l.id == listId);
    if (idx >= 0) {
      final updated = List<String>.from(_lists[idx].baniIds)
        ..remove(baniId);
      _lists[idx] = _lists[idx].copyWith(baniIds: updated);
      notifyListeners();
      await _save();
    }
  }

  Future<void> reorderBanis(String listId, int oldIndex, int newIndex) async {
    final idx = _lists.indexWhere((l) => l.id == listId);
    if (idx >= 0) {
      final updated = List<String>.from(_lists[idx].baniIds);
      if (oldIndex < 0 ||
          oldIndex >= updated.length ||
          newIndex < 0 ||
          newIndex >= updated.length) {
        return;
      }
      final item = updated.removeAt(oldIndex);
      updated.insert(newIndex, item);
      _lists[idx] = _lists[idx].copyWith(baniIds: updated);
      notifyListeners();
      await _save();
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = json.encode(_lists.map((l) => l.toJson()).toList());
      await prefs.setString(AppConstants.keyCustomLists, jsonStr);
    } on FormatException {
      // JSON encoding failure — data stays in memory
    } catch (_) {
      // Storage write failure — non-fatal
    }
  }

  /// Generates a random hex ID to avoid timestamp collisions.
  static String _generateId() {
    final rng = Random.secure();
    return List.generate(16, (_) => rng.nextInt(256).toRadixString(16).padLeft(2, '0'))
        .join();
  }
}
