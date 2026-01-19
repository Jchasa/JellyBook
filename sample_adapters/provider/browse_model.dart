// sample_adapters/provider/browse_model.dart
// NOTE: This file lives outside /lib so it won't compile unless you move it into lib and add provider to pubspec.
import 'package:flutter/foundation.dart';
import '../../lib/features/browse/browse_query.dart';
import '../../lib/features/browse/data/items_repository.dart';

class BrowseModel extends ChangeNotifier {
  BrowseModel(this._repo);
  final ItemsRepository _repo;

  BrowseQuery _query = const BrowseQuery();
  BrowseQuery get query => _query;
  List<LibraryItem> items = const [];
  bool loading = false;
  Object? error;

  Future<void> refresh() async {
    loading = true; error = null; notifyListeners();
    try {
      items = await _repo.fetch(_query);
    } catch (e) { error = e; }
    loading = false; notifyListeners();
  }

  void apply(BrowseQuery q) {
    _query = q; refresh();
  }
}
