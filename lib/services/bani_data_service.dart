import 'dart:convert';
import 'package:flutter/services.dart';
import '../config/constants.dart';
import '../models/bani.dart';
import '../models/verse.dart';

class BaniDataService {
  /// Validates that [fileName] is a safe, expected asset file name.
  /// Prevents path traversal attacks (e.g. ../../AndroidManifest.xml).
  /// Only allows letters (a-z, A-Z), digits, underscores, and a single
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
      final jsonStr = await rootBundle.loadString(
        AppConstants.baniCataloguePath,
      );
      final decoded = json.decode(jsonStr);
      if (decoded is! Map<String, dynamic>) {
        throw FormatException('Catalogue JSON is not a Map.');
      }
      final baniList = decoded['banis'];
      if (baniList is! List) {
        throw FormatException('Catalogue "banis" is not a List.');
      }
      return baniList.map((b) {
        if (b is! Map<String, dynamic>) {
          throw FormatException('Bani entry is not a Map.');
        }
        return Bani.fromJson(b);
      }).toList();
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
      final decoded = json.decode(jsonStr);
      if (decoded is! Map<String, dynamic>) {
        throw FormatException('Bani JSON is not a Map.');
      }
      final verseList = decoded['verses'];
      if (verseList is! List) {
        throw FormatException('Bani "verses" is not a List.');
      }
      return verseList.map((v) {
        if (v is! Map<String, dynamic>) {
          throw FormatException('Verse entry is not a Map.');
        }
        return Verse.fromJson(v);
      }).toList();
    } on FormatException {
      throw Exception('Bani data is malformed.');
    } catch (e) {
      throw Exception('Failed to load bani.');
    }
  }
}
