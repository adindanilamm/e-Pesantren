import '../entities/penilaian_tahfidz_entity.dart';

abstract class PenilaianTahfidzRepository {
  /// Create new Tahfidz assessment
  Future<void> createPenilaian(PenilaianTahfidzEntity penilaian);

  /// Get all Tahfidz assessments for a santri
  Future<List<PenilaianTahfidzEntity>> getPenilaianBySantri(String santriId);

  /// Get Tahfidz assessments for a specific week
  Future<PenilaianTahfidzEntity?> getPenilaianByWeek(
    String santriId,
    DateTime minggu,
  );

  /// Update Tahfidz assessment
  Future<void> updatePenilaian(PenilaianTahfidzEntity penilaian);

  /// Delete Tahfidz assessment
  Future<void> deletePenilaian(String id);
}
