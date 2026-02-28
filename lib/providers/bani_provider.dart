import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/bani.dart';
import '../models/verse.dart';
import '../services/bani_data_service.dart';

class BaniProvider extends ChangeNotifier {
  final BaniDataService _service = BaniDataService();

  List<Bani> _allBanis = [];
  List<Verse> _currentVerses = [];
  Bani? _currentBani;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Bani> get allBanis => _allBanis;
  List<Verse> get currentVerses => _currentVerses;
  Bani? get currentBani => _currentBani;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  List<Bani> get nitnemBanis => _allBanis.where((b) => b.isNitnem).toList();

  List<Bani> get taksalBanis => _filterAndSearch(AppConstants.categoryTaksal);

  List<Bani> get buddaDalBanis =>
      _filterAndSearch(AppConstants.categoryBuddaDal);

  List<Bani> get hazuriDasBanis =>
      _filterAndSearch(AppConstants.categoryHazuriDas);

  List<Bani> get searchResults {
    if (_searchQuery.isEmpty) return _allBanis;
    final q = _searchQuery.toLowerCase();
    return _allBanis.where((b) {
      return b.nameEnglish.toLowerCase().contains(q) ||
          b.nameGurmukhi.contains(q);
    }).toList();
  }

  List<Bani> _filterAndSearch(String category) {
    final banis = _allBanis.where((b) => b.category == category).toList();
    if (_searchQuery.isEmpty) return banis;
    final q = _searchQuery.toLowerCase();
    return banis.where((b) {
      return b.nameEnglish.toLowerCase().contains(q) ||
          b.nameGurmukhi.contains(q);
    }).toList();
  }

  Future<void> loadCatalogue() async {
    if (_allBanis.isNotEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allBanis = await _service.loadCatalogue();
    } catch (e) {
      _error = 'Failed to load bani catalogue: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBani(Bani bani) async {
    _isLoading = true;
    _currentBani = bani;
    _currentVerses = [];
    _error = null;
    notifyListeners();

    try {
      _currentVerses = await _service.loadVerses(bani.fileName);
    } catch (e) {
      _error = 'Failed to load bani: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}
