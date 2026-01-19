// sample_adapters/bloc/browse_cubit.dart
// NOTE: This file lives outside /lib so it won't compile unless you move it into lib and add bloc to pubspec.
import 'package:bloc/bloc.dart';
import '../../lib/features/browse/browse_query.dart';
import '../../lib/features/browse/data/items_repository.dart';

sealed class BrowseState {}
class BrowseLoading extends BrowseState {}
class BrowseReady extends BrowseState { final BrowseQuery query; final List<LibraryItem> items; BrowseReady(this.query, this.items); }
class BrowseError extends BrowseState { final Object error; BrowseError(this.error); }

class BrowseCubit extends Cubit<BrowseState> {
  BrowseCubit(this._repo): super(BrowseLoading());
  final ItemsRepository _repo;
  BrowseQuery _q = const BrowseQuery();

  Future<void> refresh() async {
    emit(BrowseLoading());
    try {
      final items = await _repo.fetch(_q);
      emit(BrowseReady(_q, items));
    } catch (e) { emit(BrowseError(e)); }
  }

  Future<void> apply(BrowseQuery q) async { _q = q; await refresh(); }
}
