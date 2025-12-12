import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/kehadiran_entity.dart';

class KehadiranModel extends KehadiranEntity {
  const KehadiranModel({
    required super.id,
    required super.santriId,
    required super.tanggal,
    required super.status,
    super.keterangan,
    required super.createdAt,
    required super.createdBy,
  });

  factory KehadiranModel.fromJson(Map<String, dynamic> json) {
    return KehadiranModel(
      id: json['id'] as String,
      santriId: json['santriId'] as String,
      tanggal: (json['tanggal'] as Timestamp).toDate(),
      status: json['status'] as String,
      keterangan: json['keterangan'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      createdBy: json['createdBy'] as String,
    );
  }

  factory KehadiranModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return KehadiranModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'santriId': santriId,
      'tanggal': Timestamp.fromDate(tanggal),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };

    if (keterangan != null) json['keterangan'] = keterangan!;

    return json;
  }

  Map<String, dynamic> toFirestore() {
    final data = <String, dynamic>{
      'santriId': santriId,
      'tanggal': Timestamp.fromDate(tanggal),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };

    if (keterangan != null) data['keterangan'] = keterangan!;

    return data;
  }

  factory KehadiranModel.fromEntity(KehadiranEntity entity) {
    return KehadiranModel(
      id: entity.id,
      santriId: entity.santriId,
      tanggal: entity.tanggal,
      status: entity.status,
      keterangan: entity.keterangan,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
    );
  }
}
