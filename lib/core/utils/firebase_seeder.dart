import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_constants.dart';

class FirebaseSeeder {
  static Future<void> seedDemoUsers() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    // Data Demo
    final users = [
      {
        'email': 'admin@pesantren.com',
        'password': 'password123',
        'role': AppConstants.roleAdmin,
        'name': 'Admin Utama',
      },
      {
        'email': 'ustadz@pesantren.com',
        'password': 'password123',
        'role': AppConstants.roleUstadz,
        'name': 'Ustadz Abdullah',
        'kelasWali': '7A',
        'mataPelajaran': ['THF', 'FQH'], // Tahfidz dan Fiqh
      },
      {
        'email': 'wali@pesantren.com',
        'password': 'password123',
        'role': AppConstants.roleWali,
        'name': 'Bapak Fulan',
        'santriIds': <String>[], // Will be populated when santri is created
      },
    ];

    for (var user in users) {
      try {
        // 1. Create Auth User
        UserCredential cred;
        try {
          cred = await auth.createUserWithEmailAndPassword(
            email: user['email'] as String,
            password: user['password'] as String,
          );
        } catch (e) {
          // If user exists, try to sign in to get uid
          print(
            'User ${user['email']} might already exist. Trying to login...',
          );
          cred = await auth.signInWithEmailAndPassword(
            email: user['email'] as String,
            password: user['password'] as String,
          );
        }

        // 2. Create Firestore Document with all required fields
        if (cred.user != null) {
          final userData = <String, dynamic>{
            'uid': cred.user!.uid,
            'email': user['email'],
            'name': user['name'],
            'role': user['role'],
            'photoUrl': null,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          };

          // Add role-specific fields
          if (user['role'] == AppConstants.roleUstadz) {
            userData['kelasWali'] = user['kelasWali'];
            userData['mataPelajaran'] = user['mataPelajaran'];
          } else if (user['role'] == AppConstants.roleWali) {
            userData['santriIds'] = user['santriIds'];
          }

          await firestore
              .collection(AppConstants.usersCollection)
              .doc(cred.user!.uid)
              .set(userData);

          print('Success seeding: ${user['email']} as ${user['role']}');
        }
      } catch (e) {
        print('Error seeding ${user['email']}: $e');
      }
    }

    // Logout after seeding so user can login manually
    await auth.signOut();
    print('Demo users seeded successfully! You can now login.');
  }
}
