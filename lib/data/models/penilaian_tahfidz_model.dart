import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/penilaian_tahfidz_entity.dart';

class PenilaianTahfidzModel extends PenilaianTahfidzEntity {
  const PenilaianTahfidzModel({
    required super.id,
    required super.santriId,
    required super.minggu,
    required super.surah,
    required super.ayatSetor,
    required super.tajwid,
    required super.createdAt,
    required super.createdBy,
  });

  factory PenilaianTahfidzModel.fromJson(Map<String, dynamic> json) {
    return PenilaianTahfidzModel(
      id: json['id'] as String,
      santriId: json['santriId'] as String,
      minggu: (json['minggu'] as Timestamp).toDate(),
      surah: json['surah'] as String,
      ayatSetor: json['ayatSetor'] as int,
      tajwid: json['tajwid'] as int,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      createdBy: json['createdBy'] as String,
    );
  }

  factory PenilaianTahfidzModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PenilaianTahfidzModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'santriId': santriId,
      'minggu': Timestamp.fromDate(minggu),
      'surah': surah,
      'ayatSetor': ayatSetor,
      'tajwid': tajwid,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'santriId': santriId,
      'minggu': Timestamp.fromDate(minggu),
      'surah': surah,
      'ayatSetor': ayatSetor,
      'tajwid': tajwid,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }

  factory PenilaianTahfidzModel.fromEntity(PenilaianTahfidzEntity entity) {
    return PenilaianTahfidzModel(
      id: entity.id,
      santriId: entity.santriId,
      minggu: entity.minggu,
      surah: entity.surah,
      ayatSetor: entity.ayatSetor,
      tajwid: entity.tajwid,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
    );
  }
}
