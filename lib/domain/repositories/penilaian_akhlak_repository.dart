import '../entities/penilaian_akhlak_entity.dart';

abstract class PenilaianAkhlakRepository {
  /// Create new character assessment
  Future<void> createPenilaian(PenilaianAkhlakEntity penilaian);

  /// Get all character assessments for a santri
  Future<List<PenilaianAkhlakEntity>> getPenilaianBySantri(String santriId);

  /// Get character assessment for specific semester
  Future<PenilaianAkhlakEntity?> getPenilaianBySemester(
    String santriId,
    String tahunAjaran,
    String semester,
  );

  /// Update character assessment
  Future<void> updatePenilaian(PenilaianAkhlakEntity penilaian);

  /// Delete character assessment
  Future<void> deletePenilaian(String id);
}
