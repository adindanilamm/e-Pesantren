import '../entities/nilai_akhir_entity.dart';

abstract class NilaiAkhirRepository {
  /// Calculate and save final grades for a santri
  Future<void> calculateAndSaveNilaiAkhir(
    String santriId,
    String tahunAjaran,
    String semester,
    String calculatedBy,
  );

  /// Get final grades for a santri
  Future<NilaiAkhirEntity?> getNilaiAkhir(
    String santriId,
    String tahunAjaran,
    String semester,
  );

  /// Get all final grades for a semester
  Future<List<NilaiAkhirEntity>> getNilaiAkhirBySemester(
    String tahunAjaran,
    String semester,
  );

  /// Get final grades by predicate
  Future<List<NilaiAkhirEntity>> getNilaiAkhirByPredikat(
    String tahunAjaran,
    String semester,
    String predikat,
  );

  /// Delete final grades
  Future<void> deleteNilaiAkhir(String id);
}
