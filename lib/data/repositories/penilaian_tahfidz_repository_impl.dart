import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/penilaian_tahfidz_entity.dart';
import '../../domain/repositories/penilaian_tahfidz_repository.dart';
import '../models/penilaian_tahfidz_model.dart';

class PenilaianTahfidzRepositoryImpl implements PenilaianTahfidzRepository {
  final FirebaseFirestore _firestore;

  PenilaianTahfidzRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createPenilaian(PenilaianTahfidzEntity penilaian) async {
    try {
      final model = PenilaianTahfidzModel.fromEntity(penilaian);
      await _firestore
          .collection('penilaian_tahfidz')
          .doc(penilaian.id)
          .set(model.toFirestore());
    } catch (e) {
      throw Exception('Failed to create penilaian tahfidz: $e');
    }
  }

  @override
  Future<List<PenilaianTahfidzEntity>> getPenilaianBySantri(
    String santriId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('penilaian_tahfidz')
          .where('santriId', isEqualTo: santriId)
          .orderBy('minggu', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PenilaianTahfidzModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get penilaian tahfidz: $e');
    }
  }

  @override
  Future<PenilaianTahfidzEntity?> getPenilaianByWeek(
    String santriId,
    DateTime minggu,
  ) async {
    try {
      // Get start and end of week
      final startOfWeek = DateTime(minggu.year, minggu.month, minggu.day);
      final endOfWeek = startOfWeek.add(const Duration(days: 7));

      final snapshot = await _firestore
          .collection('penilaian_tahfidz')
          .where('santriId', isEqualTo: santriId)
          .where(
            'minggu',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek),
          )
          .where('minggu', isLessThan: Timestamp.fromDate(endOfWeek))
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return PenilaianTahfidzModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get penilaian tahfidz by week: $e');
    }
  }

  @override
  Future<void> updatePenilaian(PenilaianTahfidzEntity penilaian) async {
    try {
      final model = PenilaianTahfidzModel.fromEntity(penilaian);
      await _firestore
          .collection('penilaian_tahfidz')
          .doc(penilaian.id)
          .update(model.toFirestore());
    } catch (e) {
      throw Exception('Failed to update penilaian tahfidz: $e');
    }
  }

  @override
  Future<void> deletePenilaian(String id) async {
    try {
      await _firestore.collection('penilaian_tahfidz').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete penilaian tahfidz: $e');
    }
  }
}
