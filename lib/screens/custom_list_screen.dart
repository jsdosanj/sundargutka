import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bani.dart';
import '../models/custom_list.dart';
import '../providers/bani_provider.dart';
import '../providers/custom_list_provider.dart';
import '../screens/bani_reader_screen.dart';

class CustomListScreen extends StatelessWidget {
  const CustomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Lists')),
      body: Consumer<CustomListProvider>(
        builder: (context, provider, _) {
          final lists = provider.lists;
          if (lists.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.list_alt, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('No custom lists yet',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create List'),
                    onPressed: () => _showCreateDialog(context, provider),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final list = lists[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.playlist_play),
                  title: Text(list.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${list.baniIds.length} Bani(s)'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () =>
                            _showRenameDialog(context, provider, list),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            _confirmDelete(context, provider, list),
                      ),
                    ],
                  ),
                  onTap: () => _showListDetail(context, list),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showCreateDialog(context, context.read<CustomListProvider>()),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCreateDialog(
      BuildContext context, CustomListProvider provider) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New List'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'List name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.createList(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRenameDialog(BuildContext context,
      CustomListProvider provider, CustomList list) async {
    final controller = TextEditingController(text: list.name);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rename List'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'New name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.renameList(list.id, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, CustomListProvider provider,
      CustomList list) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete List'),
        content: Text('Delete "${list.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) provider.deleteList(list.id);
  }

  void _showListDetail(BuildContext context, CustomList list) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => _ListDetailScreen(customList: list)),
    );
  }
}

class _ListDetailScreen extends StatelessWidget {
  final CustomList customList;
  const _ListDetailScreen({required this.customList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customList.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddBaniDialog(context),
          ),
        ],
      ),
      body: Consumer2<CustomListProvider, BaniProvider>(
        builder: (context, listProvider, baniProvider, _) {
          final list = listProvider.lists.firstWhere(
            (l) => l.id == customList.id,
            orElse: () => customList,
          );

          if (list.baniIds.isEmpty) {
            return const Center(
              child: Text('No Banis in this list yet.\nTap + to add.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey)),
            );
          }

          final banis = list.baniIds
              .map((id) {
                try {
                  return baniProvider.allBanis.firstWhere((b) => b.id == id);
                } catch (_) {
                  return null;
                }
              })
              .whereType<Bani>()
              .toList();

          return ReorderableListView.builder(
            itemCount: banis.length,
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              listProvider.reorderBanis(list.id, oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final bani = banis[index];
              return ListTile(
                key: Key(bani.id),
                leading: const Icon(Icons.drag_handle),
                title: Text(bani.nameGurmukhi),
                subtitle: Text(bani.nameEnglish),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () =>
                      listProvider.removeBaniFromList(list.id, bani.id),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BaniReaderScreen(bani: bani)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddBaniDialog(BuildContext context) {
    final baniProvider = context.read<BaniProvider>();
    final listProvider = context.read<CustomListProvider>();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Consumer<CustomListProvider>(builder: (ctx, lp, _) {
          final list = lp.lists.firstWhere(
            (l) => l.id == customList.id,
            orElse: () => customList,
          );
          return ListView(
            children: baniProvider.allBanis.map((bani) {
              final added = list.baniIds.contains(bani.id);
              return ListTile(
                title: Text(bani.nameGurmukhi),
                subtitle: Text(bani.nameEnglish),
                trailing: added
                    ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                    : null,
                onTap: () {
                  if (!added) {
                    listProvider.addBaniToList(list.id, bani.id);
                  } else {
                    listProvider.removeBaniFromList(list.id, bani.id);
                  }
                },
              );
            }).toList(),
          );
        });
      },
    );
  }
}
