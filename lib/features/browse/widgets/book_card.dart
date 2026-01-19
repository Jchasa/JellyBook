// lib/features/browse/widgets/book_card.dart
import 'package:flutter/material.dart';
import '../data/items_repository.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.item, this.onTap});
  final LibraryItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2/3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black12,
              ),
              child: const Icon(Icons.menu_book_outlined),
            ),
          ),
          const SizedBox(height: 6),
          Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
