import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/penilaian_akhlak_entity.dart';

class PenilaianAkhlakModel extends PenilaianAkhlakEntity {
  const PenilaianAkhlakModel({
    required super.id,
    required super.santriId,
    required super.disiplin,
    required super.adab,
    required super.kebersihan,
    required super.kerjasama,
    super.catatan,
    required super.semester,
    required super.tahunAjaran,
    required super.createdAt,
    required super.updatedAt,
    required super.createdBy,
  });

  factory PenilaianAkhlakModel.fromJson(Map<String, dynamic> json) {
    return PenilaianAkhlakModel(
      id: json['id'] as String,
      santriId: json['santriId'] as String,
      disiplin: json['disiplin'] as int,
      adab: json['adab'] as int,
      kebersihan: json['kebersihan'] as int,
      kerjasama: json['kerjasama'] as int,
      catatan: json['catatan'] as String?,
      semester: json['semester'] as String,
      tahunAjaran: json['tahunAjaran'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      createdBy: json['createdBy'] as String,
    );
  }

  factory PenilaianAkhlakModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PenilaianAkhlakModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'santriId': santriId,
      'disiplin': disiplin,
      'adab': adab,
      'kebersihan': kebersihan,
      'kerjasama': kerjasama,
      'semester': semester,
      'tahunAjaran': tahunAjaran,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
    };

    if (catatan != null) json['catatan'] = catatan!;

    return json;
  }

  Map<String, dynamic> toFirestore() {
    final data = <String, dynamic>{
      'santriId': santriId,
      'disiplin': disiplin,
      'adab': adab,
      'kebersihan': kebersihan,
      'kerjasama': kerjasama,
      'semester': semester,
      'tahunAjaran': tahunAjaran,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
    };

    if (catatan != null) data['catatan'] = catatan!;

    return data;
  }

  factory PenilaianAkhlakModel.fromEntity(PenilaianAkhlakEntity entity) {
    return PenilaianAkhlakModel(
      id: entity.id,
      santriId: entity.santriId,
      disiplin: entity.disiplin,
      adab: entity.adab,
      kebersihan: entity.kebersihan,
      kerjasama: entity.kerjasama,
      catatan: entity.catatan,
      semester: entity.semester,
      tahunAjaran: entity.tahunAjaran,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      createdBy: entity.createdBy,
    );
  }
}
