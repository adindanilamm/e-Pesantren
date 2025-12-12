import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/penilaian_entity.dart';
import '../../domain/repositories/penilaian_repository.dart';
import '../models/penilaian_model.dart';
import '../datasources/local_database.dart';
import '../../core/constants/app_constants.dart';

class PenilaianRepositoryImpl implements PenilaianRepository {
  final FirebaseFirestore _firestore;
  final LocalDatabase _localDatabase;

  PenilaianRepositoryImpl(this._firestore, this._localDatabase);

  @override
  Future<void> deletePenilaian(String id) async {
    try {
      await _firestore
          .collection(AppConstants.penilaianCollection)
          .doc(id)
          .delete();

      final db = await _localDatabase.database;
      await db.delete(
        AppConstants.penilaianCollection,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete penilaian: $e');
    }
  }

  @override
  Future<List<PenilaianEntity>> getPenilaianBySantri(String santriId) async {
    try {
      // Try Firestore
      final snapshot = await _firestore
          .collection(AppConstants.penilaianCollection)
          .where('santriId', isEqualTo: santriId)
          .orderBy('createdAt', descending: true)
          .get();

      final List<PenilaianModel> list = snapshot.docs
          .map((doc) => PenilaianModel.fromFirestore(doc))
          .toList();

      // Update Local
      final db = await _localDatabase.database;
      final batch = db.batch();

      for (var item in list) {
        batch.insert(
          AppConstants.penilaianCollection,
          item.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);

      return list;
    } catch (e) {
      // Fallback Local
      try {
        final db = await _localDatabase.database;
        final maps = await db.query(
          AppConstants.penilaianCollection,
          where: 'santriId = ?',
          whereArgs: [santriId],
          orderBy: 'createdAt DESC',
        );

        return maps.map((e) => PenilaianModel.fromJson(e)).toList();
      } catch (localError) {
        throw Exception('Failed to fetch penilaian: $e');
      }
    }
  }

  @override
  Future<PenilaianEntity?> getPenilaianBySemester(
    String santriId,
    String tahunAjaran,
    String semester,
  ) async {
    try {
      // Use composite document ID for direct lookup
      final docId = '${santriId}_${tahunAjaran}_$semester';
      final doc = await _firestore
          .collection(AppConstants.penilaianCollection)
          .doc(docId)
          .get();

      if (doc.exists) {
        final penilaian = PenilaianModel.fromFirestore(doc);

        // Cache
        final db = await _localDatabase.database;
        await db.insert(
          AppConstants.penilaianCollection,
          penilaian.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        return penilaian;
      }

      return null; // Not found
    } catch (e) {
      // Fallback Local
      try {
        final db = await _localDatabase.database;
        final maps = await db.query(
          AppConstants.penilaianCollection,
          where: 'santriId = ? AND tahunAjaran = ? AND semester = ?',
          whereArgs: [santriId, tahunAjaran, semester],
        );

        if (maps.isNotEmpty) {
          return PenilaianModel.fromJson(maps.first);
        }
        return null;
      } catch (localError) {
        throw Exception('Failed to fetch penilaian: $e');
      }
    }
  }

  @override
  Future<void> savePenilaian(PenilaianEntity penilaian) async {
    try {
      final model = PenilaianModel.fromEntity(penilaian);

      // Save Firestore with composite document ID
      await _firestore
          .collection(AppConstants.penilaianCollection)
          .doc(penilaian.id)
          .set(model.toFirestore());

      // Save Local
      final db = await _localDatabase.database;
      await db.insert(
        AppConstants.penilaianCollection,
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to save penilaian: $e');
    }
  }
}
