import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../config/theme.dart';
import '../models/bani.dart';
import '../models/bookmark.dart';
import '../providers/bani_provider.dart';
import '../providers/bookmark_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/gurmukhi_utils.dart';
import '../widgets/reader_toolbar.dart';
import '../widgets/verse_widget.dart';

class BaniReaderScreen extends StatefulWidget {
  final Bani bani;
  final int initialVerseIndex;

  const BaniReaderScreen({
    super.key,
    required this.bani,
    this.initialVerseIndex = 0,
  });

  @override
  State<BaniReaderScreen> createState() => _BaniReaderScreenState();
}

class _BaniReaderScreenState extends State<BaniReaderScreen> {
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _positionsListener =
      ItemPositionsListener.create();
  int _currentVisibleIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BaniProvider>().loadBani(widget.bani);
    });
    _positionsListener.itemPositions.addListener(() {
      final positions = _positionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        setState(() {
          _currentVisibleIndex = positions
              .where((p) => p.itemTrailingEdge > 0)
              .reduce((a, b) => a.itemTrailingEdge < b.itemTrailingEdge ? a : b)
              .index;
        });
      }
    });
  }

  void _toggleBookmark() {
    final provider = context.read<BaniProvider>();
    final bookmarkProvider = context.read<BookmarkProvider>();
    final verses = provider.currentVerses;
    if (verses.isEmpty) return;

    final idx = _currentVisibleIndex.clamp(0, verses.length - 1);
    final verse = verses[idx];
    final isBookmarked =
        bookmarkProvider.isBookmarked(widget.bani.id, idx);

    if (isBookmarked) {
      bookmarkProvider.removeBookmarkByVerse(widget.bani.id, idx);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Bookmark removed')));
    } else {
      final bookmark = Bookmark(
        id: '${widget.bani.id}_${idx}_${DateTime.now().millisecondsSinceEpoch}',
        baniId: widget.bani.id,
        baniName: widget.bani.nameEnglish,
        verseIndex: idx,
        versePreview: GurmukhiUtils.safePreview(verse.gurmukhi),
        createdAt: DateTime.now(),
      );
      bookmarkProvider.addBookmark(bookmark);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Bookmark added')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: settings.fullScreenMode
          ? null
          : AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.bani.nameGurmukhi,
                      style: const TextStyle(fontSize: 18)),
                  Text(widget.bani.nameEnglish,
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
              actions: [
                Consumer<BookmarkProvider>(
                  builder: (_, bookmarks, __) {
                    final isBookmarked = bookmarks.isBookmarked(
                        widget.bani.id, _currentVisibleIndex);
                    return IconButton(
                      icon: Icon(isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_outline),
                      color: isBookmarked ? AppTheme.accentOrange : null,
                      onPressed: _toggleBookmark,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () => settings.setFullScreenMode(true),
                ),
              ],
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
                ],
              ),
            );
          }
          if (provider.currentVerses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final verses = provider.currentVerses;

          return GestureDetector(
            onTap: settings.fullScreenMode
                ? () => settings.setFullScreenMode(false)
                : null,
            child: ScrollablePositionedList.builder(
              itemCount: verses.length,
              itemScrollController: _scrollController,
              itemPositionsListener: _positionsListener,
              initialScrollIndex: widget.initialVerseIndex,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemBuilder: (context, index) => VerseWidget(
                verse: verses[index],
                index: index,
                baniId: widget.bani.id,
              ),
            ),
          );
        },
      ),
      floatingActionButton: ReaderToolbar(
        onScrollToTop: () {
          _scrollController.scrollTo(
            index: 0,
            duration: const Duration(milliseconds: 400),
          );
        },
      ),
    );
  }
}
