// lib/features/browse/sort_and_view_sheet.dart
import 'package:flutter/material.dart';
import 'browse_query.dart';

class SortAndViewSheet extends StatefulWidget {
  final BrowseQuery initial;
  final void Function(BrowseQuery) onChanged;
  const SortAndViewSheet({super.key, required this.initial, required this.onChanged});

  @override
  State<SortAndViewSheet> createState() => _SortAndViewSheetState();
}

class _SortAndViewSheetState extends State<SortAndViewSheet> {
  late BrowseQuery q;

  @override
  void initState() {
    super.initState();
    q = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<SortField>(
                  value: q.sortField,
                  decoration: const InputDecoration(labelText: 'Sort by'),
                  items: SortField.values
                      .map((f) => DropdownMenuItem(value: f, child: Text(f.label)))
                      .toList(),
                  onChanged: (f) => setState(() => q = q.copyWith(sortField: f)),
                ),
              ),
              const SizedBox(width: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Descending'),
                value: q.descending,
                onChanged: (v) => setState(() => q = q.copyWith(descending: v)),
              ),
            ],
          ),
          const Divider(),
          const Text('View', style: TextStyle(fontWeight: FontWeight.bold)),
          SegmentedButton<ViewMode>(
            segments: const [
              ButtonSegment(value: ViewMode.grid, label: Text('Grid'), icon: Icon(Icons.grid_view)),
              ButtonSegment(value: ViewMode.list, label: Text('List'), icon: Icon(Icons.view_list)),
              ButtonSegment(value: ViewMode.compact, label: Text('Compact'), icon: Icon(Icons.density_small)),
            ],
            selected: {q.viewMode},
            onSelectionChanged: (s) => setState(() => q = q.copyWith(viewMode: s.first)),
          ),
          if (q.viewMode == ViewMode.grid) ...[
            const SizedBox(height: 8),
            Row(children: [
              const Text('Columns'),
              Expanded(
                child: Slider(
                  min: 2, max: 5, divisions: 3,
                  value: q.columns.toDouble(),
                  label: '${q.columns}',
                  onChanged: (v) => setState(() => q = q.copyWith(columns: v.round())),
                ),
              ),
            ]),
          ],
          const Divider(),
          const Text('Filter', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(spacing: 8, children: [
            FilterChip(
              label: const Text('Favorites'),
              selected: q.favoritesOnly,
              onSelected: (v) => setState(() => q = q.copyWith(favoritesOnly: v)),
            ),
            FilterChip(
              label: const Text('In progress'),
              selected: q.inProgressOnly,
              onSelected: (v) => setState(() => q = q.copyWith(inProgressOnly: v)),
            ),
            FilterChip(
              label: const Text('Unplayed'),
              selected: q.unplayedOnly,
              onSelected: (v) => setState(() => q = q.copyWith(unplayedOnly: v)),
            ),
          ]),
          const SizedBox(height: 8),
          const Text('Types'),
          Wrap(spacing: 8, children: [
            _type('Book'),
            _type('Comic'),
            _type('AudioBook'),
          ]),
          const SizedBox(height: 8),
          const Text('Group by'),
          Wrap(spacing: 8, children: [
            ChoiceChip(
              label: const Text('None'),
              selected: q.groupBy == null,
              onSelected: (_) => setState(() => q = q.copyWith(groupBy: null)),
            ),
            ChoiceChip(
              label: const Text('Series'),
              selected: q.groupBy == 'Series',
              onSelected: (_) => setState(() => q = q.copyWith(groupBy: 'Series')),
            ),
            ChoiceChip(
              label: const Text('Author'),
              selected: q.groupBy == 'Author',
              onSelected: (_) => setState(() => q = q.copyWith(groupBy: 'Author')),
            ),
          ]),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => widget.onChanged(q), child: const Text('Apply')),
        ],
      ),
    );
  }

  Widget _type(String t) => FilterChip(
    label: Text(t),
    selected: q.includeItemTypes.contains(t),
    onSelected: (v) {
      final s = {...q.includeItemTypes};
      v ? s.add(t) : s.remove(t);
      setState(() => q = q.copyWith(includeItemTypes: s));
    },
  );
}
