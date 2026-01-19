// sample_adapters/riverpod/browse_controller_riverpod.dart
// NOTE: This file lives outside /lib so it won't compile unless you move it into lib and add flutter_riverpod to pubspec.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lib/features/browse/browse_query.dart';
import '../../lib/features/browse/data/items_repository.dart';

final browseQueryProvider = StateProvider<BrowseQuery>((_) => const BrowseQuery());

final itemsRepositoryProvider = Provider<ItemsRepository>((ref) {
  throw UnimplementedError('Provide ItemsRepository with ProviderScope overrides');
});

final browseItemsProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.watch(itemsRepositoryProvider);
  final q = ref.watch(browseQueryProvider);
  return repo.fetch(q);
});
