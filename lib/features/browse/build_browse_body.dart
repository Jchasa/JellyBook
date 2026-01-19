// lib/features/browse/build_browse_body.dart
import 'package:flutter/material.dart';
import 'browse_query.dart';
import 'data/items_repository.dart';
import 'widgets/book_card.dart';
import 'widgets/book_list_tile.dart';

Widget buildBrowseBody(List<LibraryItem> items, BrowseQuery q) {
  switch (q.viewMode) {
    case ViewMode.grid:
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: q.columns,
          childAspectRatio: .66,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) => BookCard(item: items[i]),
      );
    case ViewMode.list:
      return ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) => BookListTile(item: items[i], dense: false),
      );
    case ViewMode.compact:
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) => BookListTile(item: items[i], dense: true),
      );
  }
}
