// lib/features/browse/data/items_repository.dart

import '../browse_query.dart';

/// Replace with your actual item model from JellyBook or map onto it.
class LibraryItem {
  final String id;
  final String name;
  final String? seriesName;
  final String? author;
  final String? primaryImageTag;
  final String type; // Book, Comic, AudioBook
  LibraryItem({
    required this.id,
    required this.name,
    required this.type,
    this.seriesName,
    this.author,
    this.primaryImageTag,
  });
}

abstract class ItemsRepository {
  Future<List<LibraryItem>> fetch(BrowseQuery query);
  String get currentUserId;
  String get baseUrl; // for building image URLs
  String get accessToken; // if needed for images
}
