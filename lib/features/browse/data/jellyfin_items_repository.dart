// lib/features/browse/data/jellyfin_items_repository.dart
import 'items_repository.dart';
import '../browse_query.dart';

/// Example adapter over your existing Jellyfin Items API client.
/// Replace `itemsApi` usage with your actual typed client.
class JellyfinItemsRepository implements ItemsRepository {
  JellyfinItemsRepository({
    required this.itemsApi, // your existing generated Jellyfin client
    required this.userId,
    required this.serverUrl,
    required this.token,
  });

  final dynamic itemsApi;
  final String userId;
  final String serverUrl;
  final String token;

  @override
  String get currentUserId => userId;
  @override
  String get baseUrl => serverUrl;
  @override
  String get accessToken => token;

  @override
  Future<List<LibraryItem>> fetch(BrowseQuery q) async {
    final p = q.toJellyfinParams(userId);
    // Adjust argument names to your client as needed.
    final res = await itemsApi.getItems(
      userId: p['userId'],
      sortBy: [p['sortBy']],
      sortOrder: [p['sortOrder']],
      includeItemTypes: p['includeItemTypes'],
      filters: p['filters'],
      recursive: true,
    );
    final items = (res.items as List?) ?? const [];
    return items.map((it) {
      // The field names below are placeholders; map to your model.
      final map = it is Map ? it : (it.toJson?.call() ?? {});
      return LibraryItem(
        id: map['Id']?.toString() ?? '',
        name: map['Name']?.toString() ?? '',
        type: map['Type']?.toString() ?? 'Book',
        seriesName: map['SeriesName']?.toString(),
        author: map['AlbumArtist']?.toString() ?? map['Author']?.toString(),
        primaryImageTag: map['ImageTags'] != null ? (map['ImageTags']['Primary']?.toString()) : null,
      );
    }).toList();
  }
}
