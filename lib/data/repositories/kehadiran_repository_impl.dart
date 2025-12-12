import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/kehadiran_entity.dart';
import '../../domain/repositories/kehadiran_repository.dart';
import '../models/kehadiran_model.dart';

class KehadiranRepositoryImpl implements KehadiranRepository {
  final FirebaseFirestore _firestore;

  KehadiranRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createKehadiran(KehadiranEntity kehadiran) async {
    try {
      final model = KehadiranModel.fromEntity(kehadiran);
      await _firestore
          .collection('kehadiran')
          .doc(kehadiran.id)
          .set(model.toFirestore());
    } catch (e) {
      throw Exception('Failed to create kehadiran: $e');
    }
  }

  @override
  Future<List<KehadiranEntity>> getKehadiranBySantri(String santriId) async {
    try {
      final snapshot = await _firestore
          .collection('kehadiran')
          .where('santriId', isEqualTo: santriId)
          .orderBy('tanggal', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => KehadiranModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get kehadiran: $e');
    }
  }

  @override
  Future<KehadiranEntity?> getKehadiranByDate(
    String santriId,
    DateTime tanggal,
  ) async {
    try {
      final startOfDay = DateTime(tanggal.year, tanggal.month, tanggal.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection('kehadiran')
          .where('santriId', isEqualTo: santriId)
          .where(
            'tanggal',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where('tanggal', isLessThan: Timestamp.fromDate(endOfDay))
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return KehadiranModel.fromFirestore(snapshot.docs.first);
    } catch (e) {
      throw Exception('Failed to get kehadiran by date: $e');
    }
  }

  @override
  Future<List<KehadiranEntity>> getKehadiranByDateRange(
    String santriId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('kehadiran')
          .where('santriId', isEqualTo: santriId)
          .where(
            'tanggal',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
          )
          .where('tanggal', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('tanggal', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => KehadiranModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get kehadiran by date range: $e');
    }
  }

  @override
  Future<void> updateKehadiran(KehadiranEntity kehadiran) async {
    try {
      final model = KehadiranModel.fromEntity(kehadiran);
      await _firestore
          .collection('kehadiran')
          .doc(kehadiran.id)
          .update(model.toFirestore());
    } catch (e) {
      throw Exception('Failed to update kehadiran: $e');
    }
  }

  @override
  Future<void> deleteKehadiran(String id) async {
    try {
      await _firestore.collection('kehadiran').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete kehadiran: $e');
    }
  }

  @override
  Future<Map<String, int>> getKehadiranSummary(
    String santriId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final kehadiranList = await getKehadiranByDateRange(
        santriId,
        startDate,
        endDate,
      );

      final summary = <String, int>{'H': 0, 'S': 0, 'I': 0, 'A': 0};

      for (var kehadiran in kehadiranList) {
        summary[kehadiran.status] = (summary[kehadiran.status] ?? 0) + 1;
      }

      return summary;
    } catch (e) {
      throw Exception('Failed to get kehadiran summary: $e');
    }
  }
}
