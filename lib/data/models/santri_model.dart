import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/santri_entity.dart';

class SantriModel extends SantriEntity {
  const SantriModel({
    required super.id,
    required super.nis,
    required super.nama,
    required super.kamar,
    required super.angkatan,
    super.waliId,
    required super.createdAt,
  });

  factory SantriModel.fromJson(Map<String, dynamic> json) {
    // Handle angkatan as both String and int
    int angkatan = 2023;
    if (json['angkatan'] != null) {
      if (json['angkatan'] is int) {
        angkatan = json['angkatan'];
      } else if (json['angkatan'] is String) {
        angkatan = int.tryParse(json['angkatan']) ?? 2023;
      }
    }

    return SantriModel(
      id: json['id'] as String,
      nis: json['nis'] as String,
      nama: json['nama'] as String,
      kamar: json['kamar'] as String,
      angkatan: angkatan,
      waliId: json['waliId'] as String?,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    );
  }

  factory SantriModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SantriModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'nis': nis,
      'nama': nama,
      'kamar': kamar,
      'angkatan': angkatan,
      'createdAt': createdAt.millisecondsSinceEpoch, // For SQLite
    };

    if (waliId != null) json['waliId'] = waliId!;

    return json;
  }

  Map<String, dynamic> toFirestore() {
    final data = <String, dynamic>{
      'nis': nis,
      'nama': nama,
      'kamar': kamar,
      'angkatan': angkatan,
      'createdAt': Timestamp.fromDate(createdAt),
    };

    if (waliId != null) data['waliId'] = waliId!;

    return data;
  }

  factory SantriModel.fromEntity(SantriEntity entity) {
    return SantriModel(
      id: entity.id,
      nis: entity.nis,
      nama: entity.nama,
      kamar: entity.kamar,
      angkatan: entity.angkatan,
      waliId: entity.waliId,
      createdAt: entity.createdAt,
    );
  }
}
