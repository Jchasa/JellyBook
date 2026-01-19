// example/ExampleBrowseScreen.dart
// Standalone demo showing how to integrate without Provider/BLoC/Riverpod.
import 'package:flutter/material.dart';
import '../lib/features/browse/browse_query.dart';
import '../lib/features/browse/sort_and_view_sheet.dart';
import '../lib/features/browse/build_browse_body.dart';
import '../lib/features/browse/data/items_repository.dart';
import '../lib/features/browse/data/jellyfin_items_repository.dart';

class ExampleBrowseScreen extends StatefulWidget {
  const ExampleBrowseScreen({super.key});

  @override
  State<ExampleBrowseScreen> createState() => _ExampleBrowseScreenState();
}

class _ExampleBrowseScreenState extends State<ExampleBrowseScreen> {
  BrowseQuery _q = const BrowseQuery();
  List<LibraryItem> _items = const [];
  late final ItemsRepository _repo;

  @override
  void initState() {
    super.initState();
    final itemsApi = null; // TODO: inject your Items API
    _repo = JellyfinItemsRepository(
      itemsApi: itemsApi,
      userId: 'USER_ID',
      serverUrl: 'https://jellyfin.example',
      token: 'TOKEN',
    );
    _refresh();
  }

  Future<void> _refresh() async {
    final items = await _repo.fetch(_q);
    setState(() { _items = items; });
  }

  void _openSheet() async {
    final updated = await showModalBottomSheet<BrowseQuery>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SortAndViewSheet(initial: _q, onChanged: Navigator.of(context).pop),
    );
    if (updated != null) { setState(() => _q = updated); _refresh(); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example Browse'), actions: [
        IconButton(icon: const Icon(Icons.tune), onPressed: _openSheet),
      ]),
      body: buildBrowseBody(_items, _q),
    );
  }
}
