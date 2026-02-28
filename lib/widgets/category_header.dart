import 'package:flutter/material.dart';

class CategoryHeader extends StatelessWidget {
  final String title;
  final String titleGurmukhi;
  final bool isNitnem;

  const CategoryHeader({
    super.key,
    required this.title,
    required this.titleGurmukhi,
    this.isNitnem = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: isNitnem
            ? const Color(0xFFFF8C00).withOpacity(0.12)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          left: BorderSide(
            color: isNitnem
                ? const Color(0xFFFF8C00)
                : Theme.of(context).colorScheme.primary,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleGurmukhi,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isNitnem
                  ? const Color(0xFFFF8C00)
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isNitnem
                  ? const Color(0xFFFF8C00)
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
