import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../models/bani.dart';
import '../providers/bani_provider.dart';
import '../screens/bani_reader_screen.dart';
import '../screens/bookmarks_screen.dart';
import '../screens/custom_list_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/bani_tile.dart';
import '../widgets/category_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BaniProvider>().loadCatalogue();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex && index == 0) return;
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/bookmarks');
        break;
      case 2:
        Navigator.pushNamed(context, '/custom-lists');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
    }
    if (index == 0) setState(() => _selectedIndex = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ਸੁੰਦਰ ਗੁਟਕਾ', style: TextStyle(fontSize: 22)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Bani...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<BaniProvider>().clearSearch();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (v) {
                context.read<BaniProvider>().setSearchQuery(v);
                setState(() {});
              },
            ),
          ),
        ),
      ),
      body: Consumer<BaniProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 8),
                  Text(provider.error!),
                  TextButton(
                    onPressed: () => provider.loadCatalogue(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final query = provider.searchQuery;

          if (query.isNotEmpty) {
            final results = provider.searchResults;
            return results.isEmpty
                ? const Center(child: Text('No results found'))
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (_, i) => BaniTile(
                      bani: results[i],
                      onTap: () => _openBani(results[i]),
                    ),
                  );
          }

          return _buildBaniList(provider);
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.bookmark), label: 'Bookmarks'),
          NavigationDestination(icon: Icon(Icons.list), label: 'My Lists'),
          NavigationDestination(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildBaniList(BaniProvider provider) {
    final nitnem = provider.nitnemBanis;
    final taksal = provider.taksalBanis
        .where((b) => !b.isNitnem)
        .toList();
    final buddaDal = provider.buddaDalBanis;
    final hazuri = provider.hazuriDasBanis;

    return ListView(
      children: [
        if (nitnem.isNotEmpty) ...[
          const CategoryHeader(
            title: 'Nitnem',
            titleGurmukhi: 'ਨਿਤਨੇਮ',
            isNitnem: true,
          ),
          ...nitnem.map((b) => BaniTile(bani: b, onTap: () => _openBani(b))),
        ],
        if (taksal.isNotEmpty) ...[
          CategoryHeader(
            title: AppConstants.categoryNames[AppConstants.categoryTaksal]!,
            titleGurmukhi:
                AppConstants.categoryNamesGurmukhi[AppConstants.categoryTaksal]!,
          ),
          ...taksal.map((b) => BaniTile(bani: b, onTap: () => _openBani(b))),
        ],
        if (buddaDal.isNotEmpty) ...[
          CategoryHeader(
            title: AppConstants.categoryNames[AppConstants.categoryBuddaDal]!,
            titleGurmukhi:
                AppConstants.categoryNamesGurmukhi[AppConstants.categoryBuddaDal]!,
          ),
          ...buddaDal
              .map((b) => BaniTile(bani: b, onTap: () => _openBani(b))),
        ],
        if (hazuri.isNotEmpty) ...[
          CategoryHeader(
            title: AppConstants.categoryNames[AppConstants.categoryHazuriDas]!,
            titleGurmukhi:
                AppConstants.categoryNamesGurmukhi[AppConstants.categoryHazuriDas]!,
          ),
          ...hazuri.map((b) => BaniTile(bani: b, onTap: () => _openBani(b))),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  void _openBani(Bani bani) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BaniReaderScreen(bani: bani)),
    );
  }
}
