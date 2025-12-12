import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_database.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/penilaian_repository_impl.dart';
import '../../data/repositories/santri_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/penilaian_repository.dart';
import '../../domain/repositories/santri_repository.dart';

// Firebase Providers
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

// Local Database Provider
final localDatabaseProvider = Provider<LocalDatabase>(
  (ref) => LocalDatabase.instance,
);

// Repository Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(firebaseAuthProvider),
    ref.read(firestoreProvider),
  );
});

final santriRepositoryProvider = Provider<SantriRepository>((ref) {
  return SantriRepositoryImpl(
    ref.read(firestoreProvider),
    ref.read(localDatabaseProvider),
  );
});

final penilaianRepositoryProvider = Provider<PenilaianRepository>((ref) {
  return PenilaianRepositoryImpl(
    ref.read(firestoreProvider),
    ref.read(localDatabaseProvider),
  );
});
