import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/santri_entity.dart';
import '../../domain/repositories/santri_repository.dart';
import '../models/santri_model.dart';
import '../datasources/local_database.dart';
import '../../core/constants/app_constants.dart';

class SantriRepositoryImpl implements SantriRepository {
  final FirebaseFirestore _firestore;
  final LocalDatabase _localDatabase;

  SantriRepositoryImpl(this._firestore, this._localDatabase);

  @override
  Future<Either<String, void>> addSantri(SantriEntity santri) async {
    try {
      final model = SantriModel.fromEntity(santri);

      // Generate new ID if empty or use timestamp
      final docId = santri.id.isEmpty
          ? _firestore.collection(AppConstants.santriCollection).doc().id
          : santri.id;

      // Save to Firestore with auto-generated ID
      await _firestore
          .collection(AppConstants.santriCollection)
          .doc(docId)
          .set(model.toFirestore());

      // Save to Local DB with the same ID
      final db = await _localDatabase.database;
      await db.insert(
        AppConstants.santriCollection,
        {...model.toJson(), 'id': docId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('✅ Santri saved to Firebase: ${model.nama} (ID: $docId)');
      return const Right(null);
    } catch (e) {
      print('❌ Error saving santri: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> deleteSantri(String id) async {
    try {
      // Delete from Firestore
      await _firestore
          .collection(AppConstants.santriCollection)
          .doc(id)
          .delete();

      // Delete from Local DB
      final db = await _localDatabase.database;
      await db.delete(
        AppConstants.santriCollection,
        where: 'id = ?',
        whereArgs: [id],
      );

      print('✅ Santri deleted: $id');
      return const Right(null);
    } catch (e) {
      print('❌ Error deleting santri: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, SantriEntity>> getSantriById(String id) async {
    try {
      // Try Firestore first
      final doc = await _firestore
          .collection(AppConstants.santriCollection)
          .doc(id)
          .get();

      if (doc.exists) {
        final santri = SantriModel.fromFirestore(doc);

        // Cache to local
        final db = await _localDatabase.database;
        await db.insert(
          AppConstants.santriCollection,
          santri.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        return Right(santri);
      }

      // If not in Firestore, try Local DB
      final db = await _localDatabase.database;
      final maps = await db.query(
        AppConstants.santriCollection,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Right(SantriModel.fromJson(maps.first));
      }

      return const Left('Santri not found');
    } catch (e) {
      print('❌ Error getting santri: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<SantriEntity>>> getSantriList() async {
    try {
      // Try Firestore first to get latest data
      final snapshot = await _firestore
          .collection(AppConstants.santriCollection)
          .orderBy('nama')
          .get();

      final List<SantriModel> santris = snapshot.docs
          .map((doc) => SantriModel.fromFirestore(doc))
          .toList();

      // Update Local DB
      final db = await _localDatabase.database;
      final batch = db.batch();

      for (var santri in santris) {
        batch.insert(
          AppConstants.santriCollection,
          santri.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);

      print('✅ Loaded ${santris.length} santri from Firebase');
      return Right(santris);
    } catch (e) {
      print('⚠️ Firestore error, using local DB: $e');
      // If Firestore fails (offline), use Local DB
      try {
        final db = await _localDatabase.database;
        final maps = await db.query(
          AppConstants.santriCollection,
          orderBy: 'nama',
        );

        return Right(maps.map((e) => SantriModel.fromJson(e)).toList());
      } catch (localError) {
        return Left('Failed to fetch data: $e');
      }
    }
  }

  @override
  Future<Either<String, List<SantriEntity>>> searchSantri(String query) async {
    try {
      if (query.isEmpty) {
        return getSantriList();
      }

      final db = await _localDatabase.database;
      final maps = await db.query(
        AppConstants.santriCollection,
        where: 'nama LIKE ? OR nis LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
      );

      return Right(maps.map((e) => SantriModel.fromJson(e)).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> updateSantri(SantriEntity santri) async {
    try {
      final model = SantriModel.fromEntity(santri);

      // Update Firestore
      await _firestore
          .collection(AppConstants.santriCollection)
          .doc(santri.id)
          .update(model.toFirestore());

      // Update Local DB
      final db = await _localDatabase.database;
      await db.update(
        AppConstants.santriCollection,
        model.toJson(),
        where: 'id = ?',
        whereArgs: [santri.id],
      );

      print('✅ Santri updated: ${model.nama}');
      return const Right(null);
    } catch (e) {
      print('❌ Error updating santri: $e');
      return Left(e.toString());
    }
  }

  @override
  Stream<List<SantriEntity>> getSantriListStream() {
    return _firestore
        .collection(AppConstants.santriCollection)
        .orderBy('nama')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SantriModel.fromFirestore(doc))
              .toList();
        });
  }
}
