import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        final doc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(user.uid)
            .get();

        if (doc.exists) {
          return UserModel.fromFirestore(doc);
        }
        return null;
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Future<Either<String, UserEntity>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return const Left('No user logged in');

      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return Right(UserModel.fromFirestore(doc));
      } else {
        return const Left('User data not found');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) return const Left('Login failed');

      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(result.user!.uid)
          .get();

      if (doc.exists) {
        return Right(UserModel.fromFirestore(doc));
      } else {
        return const Left('User data not found in database');
      }
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Authentication failed');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
