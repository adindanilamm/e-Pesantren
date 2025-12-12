import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/mata_pelajaran_entity.dart';

class MataPelajaranModel extends MataPelajaranEntity {
  const MataPelajaranModel({
    required super.id,
    required super.kode,
    required super.nama,
    required super.jenis,
    required super.aktif,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MataPelajaranModel.fromJson(Map<String, dynamic> json) {
    return MataPelajaranModel(
      id: json['id'] ?? '',
      kode: json['kode'] ?? '',
      nama: json['nama'] ?? '',
      jenis: json['jenis'] ?? 'akademik',
      aktif: json['aktif'] ?? true,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  factory MataPelajaranModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MataPelajaranModel(
      id: doc.id,
      kode: data['kode'] ?? '',
      nama: data['nama'] ?? '',
      jenis: data['jenis'] ?? 'akademik',
      aktif: data['aktif'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode': kode,
      'nama': nama,
      'jenis': jenis,
      'aktif': aktif,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'kode': kode,
      'nama': nama,
      'jenis': jenis,
      'aktif': aktif,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory MataPelajaranModel.fromEntity(MataPelajaranEntity entity) {
    return MataPelajaranModel(
      id: entity.id,
      kode: entity.kode,
      nama: entity.nama,
      jenis: entity.jenis,
      aktif: entity.aktif,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
