import 'dart:convert';
import 'package:flutter/services.dart';
import '../config/constants.dart';
import '../models/bani.dart';
import '../models/verse.dart';

class BaniDataService {
  /// Validates that [fileName] is a safe, expected asset file name.
  /// Prevents path traversal attacks (e.g. ../../AndroidManifest.xml).
  /// Only allows lowercase letters, digits, underscores, and a single
  /// ".json" suffix — nothing else.
  static bool _isSafeFileName(String fileName) {
    // Must match exactly: word chars + ".json", no path separators
    final safePattern = RegExp(r'^[a-zA-Z0-9_]+\.json$');
    return safePattern.hasMatch(fileName) &&
        !fileName.contains('/') &&
        !fileName.contains('\\') &&
        !fileName.contains('..');
  }

  Future<List<Bani>> loadCatalogue() async {
    try {
      final jsonStr =
          await rootBundle.loadString(AppConstants.baniCataloguePath);
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final baniList = data['banis'] as List<dynamic>;
      return baniList
          .map((b) => Bani.fromJson(b as Map<String, dynamic>))
          .toList();
    } on FormatException {
      throw Exception('Bani catalogue is malformed.');
    } catch (e) {
      throw Exception('Failed to load catalogue.');
    }
  }

  Future<List<Verse>> loadVerses(String fileName) async {
    if (!_isSafeFileName(fileName)) {
      throw ArgumentError('Invalid bani file name.');
    }
    try {
      final path = '${AppConstants.baniFolderPath}$fileName';
      final jsonStr = await rootBundle.loadString(path);
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final verseList = data['verses'] as List<dynamic>;
      return verseList
          .map((v) => Verse.fromJson(v as Map<String, dynamic>))
          .toList();
    } on FormatException {
      throw Exception('Bani data is malformed.');
    } catch (e) {
      throw Exception('Failed to load bani.');
    }
  }
}
