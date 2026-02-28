import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bani.dart';
import '../providers/bookmark_provider.dart';
import '../providers/bani_provider.dart';
import '../screens/bani_reader_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: Consumer<BookmarkProvider>(
        builder: (context, provider, _) {
          final bookmarks = provider.bookmarks;
          if (bookmarks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No bookmarks yet',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('Add bookmarks while reading a Bani',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              return Dismissible(
                key: Key(bookmark.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => provider.removeBookmark(bookmark.id),
                child: ListTile(
                  leading: const Icon(Icons.bookmark, color: Color(0xFFFF8C00)),
                  title: Text(bookmark.baniName,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bookmark.versePreview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13)),
                      Text(
                        _formatDate(bookmark.createdAt),
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () => _navigateToBani(context, bookmark.baniId,
                      bookmark.baniName, bookmark.verseIndex),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  void _navigateToBani(
      BuildContext context, String baniId, String baniName, int verseIndex) {
    final baniProvider = context.read<BaniProvider>();
    Bani? bani;
    try {
      bani = baniProvider.allBanis.firstWhere((b) => b.id == baniId);
    } catch (_) {
      bani = null;
    }

    if (bani != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BaniReaderScreen(
            bani: bani!,
            initialVerseIndex: verseIndex,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bani not found')),
      );
    }
  }
}
