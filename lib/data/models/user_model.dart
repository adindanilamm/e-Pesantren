import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.role,
    required super.name,
    super.photoUrl,
    super.kelasWali,
    super.mataPelajaran,
    super.santriIds,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'wali_santri',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'],
      kelasWali: json['kelasWali'],
      mataPelajaran: json['mataPelajaran'] != null
          ? List<String>.from(json['mataPelajaran'])
          : null,
      santriIds: json['santriIds'] != null
          ? List<String>.from(json['santriIds'])
          : null,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      role: data['role'] ?? 'wali_santri',
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'],
      kelasWali: data['kelasWali'],
      mataPelajaran: data['mataPelajaran'] != null
          ? List<String>.from(data['mataPelajaran'])
          : (data['subjects'] != null
                ? List<String>.from(data['subjects'])
                : null),
      santriIds: data['santriIds'] != null
          ? List<String>.from(data['santriIds'])
          : (data['santriId'] != null
                ? [data['santriId']]
                : (data['santriID'] != null ? [data['santriID']] : null)),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
    };

    if (photoUrl != null) json['photoUrl'] = photoUrl!;
    if (kelasWali != null) json['kelasWali'] = kelasWali!;
    if (mataPelajaran != null) json['mataPelajaran'] = mataPelajaran!;
    if (santriIds != null) json['santriIds'] = santriIds!;
    if (createdAt != null) json['createdAt'] = Timestamp.fromDate(createdAt!);
    if (updatedAt != null) json['updatedAt'] = Timestamp.fromDate(updatedAt!);

    return json;
  }

  Map<String, dynamic> toFirestore() {
    final data = <String, dynamic>{
      'email': email,
      'role': role,
      'name': name,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (photoUrl != null) data['photoUrl'] = photoUrl!;
    if (kelasWali != null) data['kelasWali'] = kelasWali!;
    if (mataPelajaran != null) data['mataPelajaran'] = mataPelajaran!;
    if (santriIds != null) data['santriIds'] = santriIds!;

    return data;
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      role: entity.role,
      name: entity.name,
      photoUrl: entity.photoUrl,
      kelasWali: entity.kelasWali,
      mataPelajaran: entity.mataPelajaran,
      santriIds: entity.santriIds,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
