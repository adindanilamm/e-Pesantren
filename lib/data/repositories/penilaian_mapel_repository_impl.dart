import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/penilaian_mapel_entity.dart';
import '../../domain/repositories/penilaian_mapel_repository.dart';
import '../models/penilaian_mapel_model.dart';

class PenilaianMapelRepositoryImpl implements PenilaianMapelRepository {
  final FirebaseFirestore _firestore;

  PenilaianMapelRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createPenilaian(PenilaianMapelEntity penilaian) async {
    try {
      final model = PenilaianMapelModel.fromEntity(penilaian);
      await _firestore
          .collection('penilaian_mapel')
          .doc(penilaian.id)
          .set(model.toFirestore());
    } catch (e) {
      throw Exception('Failed to create penilaian mapel: $e');
    }
  }

  @override
  Future<List<PenilaianMapelEntity>> getPenilaianBySantri(
    String santriId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('penilaian_mapel')
          .where('santriId', isEqualTo: santriId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PenilaianMapelModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get penilaian mapel: $e');
    }
  }

  @override
  Future<PenilaianMapelEntity?> getPenilaianByMapelAndSemester(
    String santriId,
    String mapel,
    String tahunAjaran,
    String semester,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('penilaian_mapel')
          .where('santriId', isEqualTo: santriId)
          .where('mapel', isEqualTo: mapel)
          .where('tahunAjaran', isEqualTo: tahunAjaran)
          .where('semester', isEqualTo: semester)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return PenilaianMapelModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get penilaian mapel by semester: $e');
    }
  }

  @override
  Future<void> updatePenilaian(PenilaianMapelEntity penilaian) async {
    try {
      final model = PenilaianMapelModel.fromEntity(penilaian);
      await _firestore
          .collection('penilaian_mapel')
          .doc(penilaian.id)
          .update(model.toFirestore());
    } catch (e) {
      throw Exception('Failed to update penilaian mapel: $e');
    }
  }

  @override
  Future<void> deletePenilaian(String id) async {
    try {
      await _firestore.collection('penilaian_mapel').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete penilaian mapel: $e');
    }
  }
}
