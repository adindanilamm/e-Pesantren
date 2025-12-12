import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/penilaian_entity.dart';
import 'dependency_injection.dart';

// Penilaian List Provider
final penilaianListProvider =
    FutureProvider.family<List<PenilaianEntity>, String>((ref, santriId) async {
      return await ref
          .read(penilaianRepositoryProvider)
          .getPenilaianBySantri(santriId);
    });

// Penilaian Controller
class PenilaianController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  PenilaianController(this._ref) : super(const AsyncValue.data(null));

  Future<void> savePenilaian(PenilaianEntity penilaian) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(penilaianRepositoryProvider).savePenilaian(penilaian);

      _ref.refresh(penilaianListProvider(penilaian.santriId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deletePenilaian(String id, String santriId) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(penilaianRepositoryProvider).deletePenilaian(id);

      _ref.refresh(penilaianListProvider(santriId));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final penilaianControllerProvider =
    StateNotifierProvider<PenilaianController, AsyncValue<void>>((ref) {
      return PenilaianController(ref);
    });
