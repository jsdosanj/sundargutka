import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/custom_list.dart';

class CustomListProvider extends ChangeNotifier {
  List<CustomList> _lists = [];

  List<CustomList> get lists => List.unmodifiable(_lists);

  Future<void> loadLists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(AppConstants.keyCustomLists);
      if (jsonStr != null) {
        final List<dynamic> decoded = json.decode(jsonStr) as List;
        _lists = decoded
            .map((e) => CustomList.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      _lists = [];
    }
    notifyListeners();
  }

  Future<void> createList(String name) async {
    final list = CustomList(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
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
    final idx = _lists.indexWhere((l) => l.id == id);
    if (idx >= 0) {
      _lists[idx] = _lists[idx].copyWith(name: newName);
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
    } catch (_) {}
  }
}
