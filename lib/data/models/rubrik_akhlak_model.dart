import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/rubrik_akhlak_entity.dart';

class RubrikAkhlakModel extends RubrikAkhlakEntity {
  const RubrikAkhlakModel({
    required super.id,
    required super.indikator,
    required super.deskripsiSkala,
    required super.urutan,
    required super.aktif,
    required super.createdAt,
    required super.updatedAt,
  });

  factory RubrikAkhlakModel.fromJson(Map<String, dynamic> json) {
    final deskripsiSkalaJson = json['deskripsiSkala'] as Map<String, dynamic>?;
    final deskripsiSkala = <int, String>{};

    if (deskripsiSkalaJson != null) {
      deskripsiSkalaJson.forEach((key, value) {
        deskripsiSkala[int.parse(key)] = value.toString();
      });
    }

    return RubrikAkhlakModel(
      id: json['id'] ?? '',
      indikator: json['indikator'] ?? '',
      deskripsiSkala: deskripsiSkala,
      urutan: json['urutan'] ?? 0,
      aktif: json['aktif'] ?? true,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  factory RubrikAkhlakModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final deskripsiSkalaData = data['deskripsiSkala'] as Map<String, dynamic>?;
    final deskripsiSkala = <int, String>{};

    if (deskripsiSkalaData != null) {
      deskripsiSkalaData.forEach((key, value) {
        deskripsiSkala[int.parse(key)] = value.toString();
      });
    }

    return RubrikAkhlakModel(
      id: doc.id,
      indikator: data['indikator'] ?? '',
      deskripsiSkala: deskripsiSkala,
      urutan: data['urutan'] ?? 0,
      aktif: data['aktif'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final deskripsiSkalaJson = <String, String>{};
    deskripsiSkala.forEach((key, value) {
      deskripsiSkalaJson[key.toString()] = value;
    });

    return {
      'id': id,
      'indikator': indikator,
      'deskripsiSkala': deskripsiSkalaJson,
      'urutan': urutan,
      'aktif': aktif,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toFirestore() {
    final deskripsiSkalaJson = <String, String>{};
    deskripsiSkala.forEach((key, value) {
      deskripsiSkalaJson[key.toString()] = value;
    });

    return {
      'indikator': indikator,
      'deskripsiSkala': deskripsiSkalaJson,
      'urutan': urutan,
      'aktif': aktif,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory RubrikAkhlakModel.fromEntity(RubrikAkhlakEntity entity) {
    return RubrikAkhlakModel(
      id: entity.id,
      indikator: entity.indikator,
      deskripsiSkala: entity.deskripsiSkala,
      urutan: entity.urutan,
      aktif: entity.aktif,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
