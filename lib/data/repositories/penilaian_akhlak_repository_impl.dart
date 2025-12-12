import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/penilaian_akhlak_entity.dart';
import '../../domain/repositories/penilaian_akhlak_repository.dart';
import '../models/penilaian_akhlak_model.dart';

class PenilaianAkhlakRepositoryImpl implements PenilaianAkhlakRepository {
  final FirebaseFirestore _firestore;

  PenilaianAkhlakRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createPenilaian(PenilaianAkhlakEntity penilaian) async {
    try {
      final model = PenilaianAkhlakModel.fromEntity(penilaian);
      await _firestore
          .collection('penilaian_akhlak')
          .doc(penilaian.id)
          .set(model.toFirestore());
    } catch (e) {
      throw Exception('Failed to create penilaian akhlak: $e');
    }
  }

  @override
  Future<List<PenilaianAkhlakEntity>> getPenilaianBySantri(
    String santriId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('penilaian_akhlak')
          .where('santriId', isEqualTo: santriId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PenilaianAkhlakModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get penilaian akhlak: $e');
    }
  }

  @override
  Future<PenilaianAkhlakEntity?> getPenilaianBySemester(
    String santriId,
    String tahunAjaran,
    String semester,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('penilaian_akhlak')
          .where('santriId', isEqualTo: santriId)
          .where('tahunAjaran', isEqualTo: tahunAjaran)
          .where('semester', isEqualTo: semester)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return PenilaianAkhlakModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get penilaian akhlak by semester: $e');
    }
  }

  @override
  Future<void> updatePenilaian(PenilaianAkhlakEntity penilaian) async {
    try {
      final model = PenilaianAkhlakModel.fromEntity(penilaian);
      await _firestore
          .collection('penilaian_akhlak')
          .doc(penilaian.id)
          .update(model.toFirestore());
    } catch (e) {
      throw Exception('Failed to update penilaian akhlak: $e');
    }
  }

  @override
  Future<void> deletePenilaian(String id) async {
    try {
      await _firestore.collection('penilaian_akhlak').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete penilaian akhlak: $e');
    }
  }
}
