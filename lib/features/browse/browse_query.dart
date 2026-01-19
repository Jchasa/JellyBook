// lib/features/browse/browse_query.dart
import 'package:flutter/foundation.dart';

/// Server-side sort fields mapped to Jellyfin ItemSortBy
enum SortField {
  sortName,
  dateCreated,
  datePlayed,
  premiereDate,
  productionYear,
  communityRating,
  criticRating,
  playCount,
  runtime,
  random,
}

extension SortFieldApi on SortField {
  String get api {
    switch (this) {
      case SortField.sortName: return 'SortName';
      case SortField.dateCreated: return 'DateCreated';
      case SortField.datePlayed: return 'DatePlayed';
      case SortField.premiereDate: return 'PremiereDate';
      case SortField.productionYear: return 'ProductionYear';
      case SortField.communityRating: return 'CommunityRating';
      case SortField.criticRating: return 'CriticRating';
      case SortField.playCount: return 'PlayCount';
      case SortField.runtime: return 'Runtime';
      case SortField.random: return 'Random';
    }
  }

  String get label {
    switch (this) {
      case SortField.sortName: return 'Title';
      case SortField.dateCreated: return 'Date added';
      case SortField.datePlayed: return 'Last played';
      case SortField.premiereDate: return 'Release date';
      case SortField.productionYear: return 'Year';
      case SortField.communityRating: return 'User rating';
      case SortField.criticRating: return 'Critic rating';
      case SortField.playCount: return 'Play count';
      case SortField.runtime: return 'Runtime';
      case SortField.random: return 'Random';
    }
  }
}

enum ViewMode { grid, list, compact }

@immutable
class BrowseQuery {
  final SortField sortField;
  final bool descending;
  final ViewMode viewMode;
  final Set<String> includeItemTypes; // Book, Comic, AudioBook, etc.
  final bool favoritesOnly;
  final bool inProgressOnly;
  final bool unplayedOnly;
  final String? groupBy; // 'Series' | 'Author' | null
  final int columns; // 2–5

  const BrowseQuery({
    this.sortField = SortField.dateCreated,
    this.descending = true,
    this.viewMode = ViewMode.grid,
    this.includeItemTypes = const {'Book', 'Comic', 'AudioBook'},
    this.favoritesOnly = false,
    this.inProgressOnly = false,
    this.unplayedOnly = false,
    this.groupBy,
    this.columns = 3,
  });

  Map<String, dynamic> toJellyfinParams(String userId) {
    final params = <String, dynamic>{
      'userId': userId,
      'sortBy': apiSortBy,
      'sortOrder': descending ? 'Descending' : 'Ascending',
      'includeItemTypes': includeItemTypes.join(','),
      'recursive': true,
    };
    final filters = <String>[
      if (favoritesOnly) 'IsFavorite',
      if (inProgressOnly) 'IsResumable',
      if (unplayedOnly) 'IsUnplayed',
    ];
    if (filters.isNotEmpty) params['filters'] = filters.join(',');
    return params;
  }

  String get apiSortBy => sortField.api;

  BrowseQuery copyWith({
    SortField? sortField,
    bool? descending,
    ViewMode? viewMode,
    Set<String>? includeItemTypes,
    bool? favoritesOnly,
    bool? inProgressOnly,
    bool? unplayedOnly,
    String? groupBy,
    int? columns,
  }) => BrowseQuery(
      sortField: sortField ?? this.sortField,
      descending: descending ?? this.descending,
      viewMode: viewMode ?? this.viewMode,
      includeItemTypes: includeItemTypes ?? this.includeItemTypes,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      inProgressOnly: inProgressOnly ?? this.inProgressOnly,
      unplayedOnly: unplayedOnly ?? this.unplayedOnly,
      groupBy: groupBy ?? this.groupBy,
      columns: columns ?? this.columns,
    );
}
