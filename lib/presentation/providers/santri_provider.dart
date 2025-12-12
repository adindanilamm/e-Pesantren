import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/santri_entity.dart';
import 'dependency_injection.dart';

// Santri List Provider (Stream)
final santriListProvider = StreamProvider<List<SantriEntity>>((ref) {
  return ref.read(santriRepositoryProvider).getSantriListStream();
});

// Santri Search Provider
final santriSearchProvider = FutureProvider.family<List<SantriEntity>, String>((
  ref,
  query,
) async {
  // Watch the stream provider
  final santriListAsync = ref.watch(santriListProvider);

  // If loading or error, rethrow or return empty
  return santriListAsync.when(
    data: (list) {
      if (query.isEmpty) return list;
      return list.where((santri) {
        final q = query.toLowerCase();
        return santri.nama.toLowerCase().contains(q) ||
            santri.nis.toLowerCase().contains(q);
      }).toList();
    },
    loading: () => [], // Return empty while loading
    error: (err, stack) => throw err,
  );
});

// Santri Controller for CRUD
class SantriController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  SantriController(this._ref) : super(const AsyncValue.data(null));

  Future<void> addSantri(SantriEntity santri) async {
    state = const AsyncValue.loading();
    final result = await _ref.read(santriRepositoryProvider).addSantri(santri);

    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (_) {
        _ref.refresh(santriListProvider);
        return const AsyncValue.data(null);
      },
    );
  }

  Future<void> updateSantri(SantriEntity santri) async {
    state = const AsyncValue.loading();
    final result = await _ref
        .read(santriRepositoryProvider)
        .updateSantri(santri);

    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (_) {
        _ref.refresh(santriListProvider);
        return const AsyncValue.data(null);
      },
    );
  }

  Future<void> deleteSantri(String id) async {
    state = const AsyncValue.loading();
    final result = await _ref.read(santriRepositoryProvider).deleteSantri(id);

    state = result.fold(
      (error) => AsyncValue.error(error, StackTrace.current),
      (_) {
        _ref.refresh(santriListProvider);
        return const AsyncValue.data(null);
      },
    );
  }
}

final santriControllerProvider =
    StateNotifierProvider<SantriController, AsyncValue<void>>((ref) {
      return SantriController(ref);
    });
