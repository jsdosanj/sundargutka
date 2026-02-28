import 'dart:convert';
import 'package:flutter/services.dart';
import '../config/constants.dart';
import '../models/bani.dart';
import '../models/verse.dart';

class BaniDataService {
  Future<List<Bani>> loadCatalogue() async {
    try {
      final jsonStr =
          await rootBundle.loadString(AppConstants.baniCataloguePath);
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final baniList = data['banis'] as List<dynamic>;
      return baniList
          .map((b) => Bani.fromJson(b as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load catalogue: $e');
    }
  }

  Future<List<Verse>> loadVerses(String fileName) async {
    try {
      final path = '${AppConstants.baniFolderPath}$fileName';
      final jsonStr = await rootBundle.loadString(path);
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final verseList = data['verses'] as List<dynamic>;
      return verseList
          .map((v) => Verse.fromJson(v as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load bani ($fileName): $e');
    }
  }
}
