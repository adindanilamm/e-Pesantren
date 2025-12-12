import '../entities/penilaian_entity.dart';

abstract class PenilaianRepository {
  /// Get all penilaian for a santri
  Future<List<PenilaianEntity>> getPenilaianBySantri(String santriId);

  /// Get penilaian for a specific semester
  Future<PenilaianEntity?> getPenilaianBySemester(
    String santriId,
    String tahunAjaran,
    String semester,
  );

  /// Save or update penilaian
  Future<void> savePenilaian(PenilaianEntity penilaian);

  /// Delete penilaian
  Future<void> deletePenilaian(String id);
}
