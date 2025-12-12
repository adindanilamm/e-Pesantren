import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/penilaian_entity.dart';

class PenilaianModel extends PenilaianEntity {
  const PenilaianModel({
    required super.id,
    required super.santriId,
    required super.tahunAjaran,
    required super.semester,
    required super.tahfidz,
    required super.fiqh,
    required super.bahasaArab,
    required super.akhlak,
    required super.createdAt,
    required super.updatedAt,
    required super.createdBy,
    required super.updatedBy,
  });

  factory PenilaianModel.fromJson(Map<String, dynamic> json) {
    return PenilaianModel(
      id: json['id'] ?? '',
      santriId: json['santriId'] ?? '',
      tahunAjaran: json['tahunAjaran'] ?? '',
      semester: json['semester'] ?? '',
      tahfidz: TahfidzScore.fromJson(json['tahfidz'] ?? {}),
      fiqh: AcademicScore.fromJson(json['fiqh'] ?? {}),
      bahasaArab: AcademicScore.fromJson(json['bahasaArab'] ?? {}),
      akhlak: AkhlakScore.fromJson(json['akhlak'] ?? {}),
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
    );
  }

  factory PenilaianModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PenilaianModel(
      id: doc.id,
      santriId: data['santriId'] ?? '',
      tahunAjaran: data['tahunAjaran'] ?? '',
      semester: data['semester'] ?? '',
      tahfidz: TahfidzScore.fromJson(data['tahfidz'] ?? {}),
      fiqh: AcademicScore.fromJson(data['fiqh'] ?? {}),
      bahasaArab: AcademicScore.fromJson(data['bahasaArab'] ?? {}),
      akhlak: AkhlakScore.fromJson(data['akhlak'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] ?? '',
      updatedBy: data['updatedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'santriId': santriId,
      'tahunAjaran': tahunAjaran,
      'semester': semester,
      'tahfidz': tahfidz.toJson(),
      'fiqh': fiqh.toJson(),
      'bahasaArab': bahasaArab.toJson(),
      'akhlak': akhlak.toJson(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'santriId': santriId,
      'tahunAjaran': tahunAjaran,
      'semester': semester,
      'tahfidz': tahfidz.toJson(),
      'fiqh': fiqh.toJson(),
      'bahasaArab': bahasaArab.toJson(),
      'akhlak': akhlak.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }

  factory PenilaianModel.fromEntity(PenilaianEntity entity) {
    return PenilaianModel(
      id: entity.id,
      santriId: entity.santriId,
      tahunAjaran: entity.tahunAjaran,
      semester: entity.semester,
      tahfidz: entity.tahfidz,
      fiqh: entity.fiqh,
      bahasaArab: entity.bahasaArab,
      akhlak: entity.akhlak,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
    );
  }
}
