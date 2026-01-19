// lib/features/browse/widgets/book_list_tile.dart
import 'package:flutter/material.dart';
import '../data/items_repository.dart';

class BookListTile extends StatelessWidget {
  const BookListTile({super.key, required this.item, this.dense = false, this.onTap});
  final LibraryItem item;
  final bool dense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: dense,
      leading: const Icon(Icons.menu_book_outlined),
      title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(item.seriesName ?? item.author ?? item.type),
      onTap: onTap,
    );
  }
}
