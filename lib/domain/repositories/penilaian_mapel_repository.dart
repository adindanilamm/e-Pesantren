import '../entities/penilaian_mapel_entity.dart';

abstract class PenilaianMapelRepository {
  /// Create new subject assessment
  Future<void> createPenilaian(PenilaianMapelEntity penilaian);

  /// Get all subject assessments for a santri
  Future<List<PenilaianMapelEntity>> getPenilaianBySantri(String santriId);

  /// Get subject assessment for specific mapel and semester
  Future<PenilaianMapelEntity?> getPenilaianByMapelAndSemester(
    String santriId,
    String mapel,
    String tahunAjaran,
    String semester,
  );

  /// Update subject assessment
  Future<void> updatePenilaian(PenilaianMapelEntity penilaian);

  /// Delete subject assessment
  Future<void> deletePenilaian(String id);
}
