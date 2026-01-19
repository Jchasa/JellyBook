# JellyBook Browse Pack (Views, Sorting, Filters, CI)

This pack adds:
- Grid/List/Compact views with adjustable grid density
- Filters: Favorites, In-progress, Unplayed, and Types (Book/Comic/AudioBook)
- Server-side sorting: Title, Date Added, Date Played, Release Date, Year, Ratings, Play Count, Runtime, Random
- Optional grouping toggles (Series/Author placeholder)
- GitHub Actions CI: builds Android APK+AAB and iOS archive on tag push and attaches to GitHub Release

## Install (drop-in)

1. **Unzip into your JellyBook repo root.**
   - It will create/merge:
     - `lib/features/browse/**`
     - `.github/workflows/build-mobile.yml`
     - `sample_adapters/**` (safe to ignore; not compiled)
     - `example/**` (optional demo; not compiled)

2. **Wire up the UI in your Library/Browse screen.**
   - Add a *tune* icon to open the bottom sheet:
     ```dart
     import 'package:flutter/material.dart';
     import 'package:your_app/features/browse/browse_query.dart';
     import 'package:your_app/features/browse/sort_and_view_sheet.dart';
     import 'package:your_app/features/browse/build_browse_body.dart';
     import 'package:your_app/features/browse/data/items_repository.dart';
     import 'package:your_app/features/browse/data/jellyfin_items_repository.dart';
     ```

     ```dart
     // Example (pseudo) in your State class:
     BrowseQuery _q = const BrowseQuery();
     List<LibraryItem> _items = const [];
     late final ItemsRepository _repo;

     @override
     void initState() {
       super.initState();
       // TODO: replace with your actual Jellyfin client instance and auth
       final itemsApi = /* your generated Jellyfin Items API client */;
       _repo = JellyfinItemsRepository(
         itemsApi: itemsApi,
         userId: /* current user id */,
         serverUrl: /* https://your-jellyfin */,
         token: /* access token if needed for images */,
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
         builder: (_) => SortAndViewSheet(
           initial: _q,
           onChanged: Navigator.of(context).pop,
         ),
       );
       if (updated != null) {
         setState(() => _q = updated);
         _refresh();
       }
     }
     ```

     In your `AppBar`:
     ```dart
     IconButton(icon: const Icon(Icons.tune), onPressed: _openSheet)
     ```

     In your body:
     ```dart
     buildBrowseBody(_items, _q)
     ```

3. **Adjust the repository mapping if needed.**
   - `lib/features/browse/data/jellyfin_items_repository.dart` maps generic Jellyfin fields (`Id`, `Name`, `Type`, etc.).
     If your generated client uses different property names, tweak that mapping only.

4. **CI builds** (optional but recommended).
   - Commit the new workflow: `.github/workflows/build-mobile.yml`
   - Push a tag like `v1.4.0`:
     ```bash
     git tag v1.4.0
     git push origin v1.4.0
     ```
   - GitHub Actions will attach:
     - `app-release.apk`
     - `app-release.aab`
     - `ios-release-no-codesign.zip`
     to the Release created for that tag.

## Notes
- No extra pubspec dependencies are required by files inside `lib/`.
- Sample adapters for Riverpod/Provider/BLoC are under `sample_adapters/` (not compiled).
  If you want one, move it into `lib/` and add the corresponding dependency to `pubspec.yaml`.
- Grouping UI is provided as a toggle; server requests remain flat for now—client-side grouping by `seriesName`/`author` is trivial to add in your screen if desired.
