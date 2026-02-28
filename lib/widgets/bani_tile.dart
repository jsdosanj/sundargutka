import 'package:flutter/material.dart';
import '../models/bani.dart';

class BaniTile extends StatelessWidget {
  final Bani bani;
  final VoidCallback onTap;

  const BaniTile({super.key, required this.bani, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: bani.isNitnem
          ? const Icon(Icons.star, color: Color(0xFFFF8C00), size: 20)
          : const Icon(Icons.menu_book_outlined, size: 20),
      title: Text(
        bani.nameGurmukhi,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        bani.nameEnglish,
        style: const TextStyle(fontSize: 13),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${bani.totalVerses}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const Text(
            'verses',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
