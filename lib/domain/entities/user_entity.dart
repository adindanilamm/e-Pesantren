import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String role; // admin, ustadz, wali_santri
  final String name;
  final String? photoUrl;

  // Additional fields for Ustadz
  final String? kelasWali; // Class they are wali kelas for
  final List<String>? mataPelajaran; // Array of subject IDs they teach

  // Additional fields for Wali Santri
  final List<String>? santriIds; // Array of santri IDs they are guardian for

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.role,
    required this.name,
    this.photoUrl,
    this.kelasWali,
    this.mataPelajaran,
    this.santriIds,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    role,
    name,
    photoUrl,
    kelasWali,
    mataPelajaran,
    santriIds,
    createdAt,
    updatedAt,
  ];

  UserEntity copyWith({
    String? uid,
    String? email,
    String? role,
    String? name,
    String? photoUrl,
    String? kelasWali,
    List<String>? mataPelajaran,
    List<String>? santriIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      kelasWali: kelasWali ?? this.kelasWali,
      mataPelajaran: mataPelajaran ?? this.mataPelajaran,
      santriIds: santriIds ?? this.santriIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
