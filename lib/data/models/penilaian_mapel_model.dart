import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/penilaian_mapel_entity.dart';

class PenilaianMapelModel extends PenilaianMapelEntity {
  const PenilaianMapelModel({
    required super.id,
    required super.santriId,
    required super.mapel,
    required super.formatif,
    required super.sumatif,
    required super.semester,
    required super.tahunAjaran,
    required super.createdAt,
    required super.updatedAt,
    required super.createdBy,
  });

  factory PenilaianMapelModel.fromJson(Map<String, dynamic> json) {
    return PenilaianMapelModel(
      id: json['id'] as String,
      santriId: json['santriId'] as String,
      mapel: json['mapel'] as String,
      formatif: json['formatif'] as int,
      sumatif: json['sumatif'] as int,
      semester: json['semester'] as String,
      tahunAjaran: json['tahunAjaran'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      createdBy: json['createdBy'] as String,
    );
  }

  factory PenilaianMapelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PenilaianMapelModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'santriId': santriId,
      'mapel': mapel,
      'formatif': formatif,
      'sumatif': sumatif,
      'semester': semester,
      'tahunAjaran': tahunAjaran,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'santriId': santriId,
      'mapel': mapel,
      'formatif': formatif,
      'sumatif': sumatif,
      'semester': semester,
      'tahunAjaran': tahunAjaran,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
    };
  }

  factory PenilaianMapelModel.fromEntity(PenilaianMapelEntity entity) {
    return PenilaianMapelModel(
      id: entity.id,
      santriId: entity.santriId,
      mapel: entity.mapel,
      formatif: entity.formatif,
      sumatif: entity.sumatif,
      semester: entity.semester,
      tahunAjaran: entity.tahunAjaran,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
    );
  }
}
