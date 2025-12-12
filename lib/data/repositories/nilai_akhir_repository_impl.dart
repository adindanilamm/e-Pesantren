import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/nilai_akhir_entity.dart';
import '../../domain/repositories/nilai_akhir_repository.dart';
import '../../domain/repositories/penilaian_repository.dart';
import '../models/nilai_akhir_model.dart';
import '../models/bobot_penilaian_model.dart';
import '../models/rekap_kehadiran_model.dart';

class NilaiAkhirRepositoryImpl implements NilaiAkhirRepository {
  final FirebaseFirestore _firestore;
  final PenilaianRepository _penilaianRepository;

  NilaiAkhirRepositoryImpl({
    FirebaseFirestore? firestore,
    required PenilaianRepository penilaianRepository,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _penilaianRepository = penilaianRepository;

  @override
  Future<void> calculateAndSaveNilaiAkhir(
    String santriId,
    String tahunAjaran,
    String semester,
    String calculatedBy,
  ) async {
    try {
      // Get penilaian data for this specific semester
      final penilaian = await _penilaianRepository.getPenilaianBySemester(
        santriId,
        tahunAjaran,
        semester,
      );

      if (penilaian == null) {
        throw Exception('Penilaian not found for santri');
      }

      // Get rekap kehadiran
      final rekapDoc = await _firestore
          .collection('rekap_kehadiran')
          .doc('${santriId}_${tahunAjaran}_$semester')
          .get();

      final rekapKehadiran = rekapDoc.exists
          ? RekapKehadiranModel.fromFirestore(rekapDoc)
          : null;

      // Get bobot penilaian
      final bobotDoc = await _firestore
          .collection('bobot_penilaian')
          .doc('${tahunAjaran}_$semester')
          .get();

      final bobotPenilaian = bobotDoc.exists
          ? BobotPenilaianModel.fromFirestore(bobotDoc)
          : null;

      // Use default weights if not found
      final bobot = BobotNilai(
        tahfidz: bobotPenilaian?.bobotTahfidz ?? 30,
        fiqh: bobotPenilaian?.bobotFiqh ?? 20,
        bahasaArab: bobotPenilaian?.bobotBahasaArab ?? 20,
        akhlak: bobotPenilaian?.bobotAkhlak ?? 20,
        kehadiran: bobotPenilaian?.bobotKehadiran ?? 10,
      );

      // Calculate final score
      final nilaiTahfidz = penilaian.tahfidz.nilaiAkhir;
      final nilaiFiqh = penilaian.fiqh.nilaiAkhir;
      final nilaiBahasaArab = penilaian.bahasaArab.nilaiAkhir;
      final nilaiAkhlak = penilaian.akhlak.nilaiAkhir;
      final nilaiKehadiran = rekapKehadiran?.nilaiAkhir ?? 0.0;

      final nilaiAkhir =
          (nilaiTahfidz * bobot.tahfidz / 100) +
          (nilaiFiqh * bobot.fiqh / 100) +
          (nilaiBahasaArab * bobot.bahasaArab / 100) +
          (nilaiAkhlak * bobot.akhlak / 100) +
          (nilaiKehadiran * bobot.kehadiran / 100);

      final predikat = NilaiAkhirEntity.calculatePredikat(nilaiAkhir);

      // Create nilai akhir entity
      final nilaiAkhirEntity = NilaiAkhirEntity(
        id: '${santriId}_${tahunAjaran}_$semester',
        santriId: santriId,
        tahunAjaran: tahunAjaran,
        semester: semester,
        nilaiTahfidz: nilaiTahfidz,
        nilaiFiqh: nilaiFiqh,
        nilaiBahasaArab: nilaiBahasaArab,
        nilaiAkhlak: nilaiAkhlak,
        nilaiKehadiran: nilaiKehadiran,
        bobot: bobot,
        nilaiAkhir: nilaiAkhir,
        predikat: predikat,
        calculatedAt: DateTime.now(),
        calculatedBy: calculatedBy,
      );

      // Save to Firestore
      final model = NilaiAkhirModel.fromEntity(nilaiAkhirEntity);
      await _firestore
          .collection('nilai_akhir')
          .doc(nilaiAkhirEntity.id)
          .set(model.toFirestore());
    } catch (e) {
      throw Exception('Failed to calculate nilai akhir: $e');
    }
  }

  @override
  Future<NilaiAkhirEntity?> getNilaiAkhir(
    String santriId,
    String tahunAjaran,
    String semester,
  ) async {
    try {
      final docId = '${santriId}_${tahunAjaran}_$semester';
      final doc = await _firestore.collection('nilai_akhir').doc(docId).get();

      if (!doc.exists) return null;

      return NilaiAkhirModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to get nilai akhir: $e');
    }
  }

  @override
  Future<List<NilaiAkhirEntity>> getNilaiAkhirBySemester(
    String tahunAjaran,
    String semester,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('nilai_akhir')
          .where('tahunAjaran', isEqualTo: tahunAjaran)
          .where('semester', isEqualTo: semester)
          .orderBy('nilaiAkhir', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NilaiAkhirModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get nilai akhir by semester: $e');
    }
  }

  @override
  Future<List<NilaiAkhirEntity>> getNilaiAkhirByPredikat(
    String tahunAjaran,
    String semester,
    String predikat,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('nilai_akhir')
          .where('tahunAjaran', isEqualTo: tahunAjaran)
          .where('semester', isEqualTo: semester)
          .where('predikat', isEqualTo: predikat)
          .get();

      return snapshot.docs
          .map((doc) => NilaiAkhirModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get nilai akhir by predikat: $e');
    }
  }

  @override
  Future<void> deleteNilaiAkhir(String id) async {
    try {
      await _firestore.collection('nilai_akhir').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete nilai akhir: $e');
    }
  }
}
