import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/rekap_kehadiran_entity.dart';

class RekapKehadiranModel extends RekapKehadiranEntity {
  const RekapKehadiranModel({
    required super.id,
    required super.santriId,
    required super.tahunAjaran,
    required super.semester,
    required super.totalPertemuan,
    required super.hadir,
    required super.sakit,
    required super.izin,
    required super.alpa,
    required super.persentaseKehadiran,
    required super.nilaiAkhir,
    required super.updatedAt,
  });

  factory RekapKehadiranModel.fromJson(Map<String, dynamic> json) {
    return RekapKehadiranModel(
      id: json['id'] ?? '',
      santriId: json['santriId'] ?? '',
      tahunAjaran: json['tahunAjaran'] ?? '',
      semester: json['semester'] ?? '',
      totalPertemuan: json['totalPertemuan'] ?? 0,
      hadir: json['hadir'] ?? 0,
      sakit: json['sakit'] ?? 0,
      izin: json['izin'] ?? 0,
      alpa: json['alpa'] ?? 0,
      persentaseKehadiran: (json['persentaseKehadiran'] ?? 0).toDouble(),
      nilaiAkhir: (json['nilaiAkhir'] ?? 0).toDouble(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  factory RekapKehadiranModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RekapKehadiranModel(
      id: doc.id,
      santriId: data['santriId'] ?? '',
      tahunAjaran: data['tahunAjaran'] ?? '',
      semester: data['semester'] ?? '',
      totalPertemuan: data['totalPertemuan'] ?? 0,
      hadir: data['hadir'] ?? 0,
      sakit: data['sakit'] ?? 0,
      izin: data['izin'] ?? 0,
      alpa: data['alpa'] ?? 0,
      persentaseKehadiran: (data['persentaseKehadiran'] ?? 0).toDouble(),
      nilaiAkhir: (data['nilaiAkhir'] ?? 0).toDouble(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'santriId': santriId,
      'tahunAjaran': tahunAjaran,
      'semester': semester,
      'totalPertemuan': totalPertemuan,
      'hadir': hadir,
      'sakit': sakit,
      'izin': izin,
      'alpa': alpa,
      'persentaseKehadiran': persentaseKehadiran,
      'nilaiAkhir': nilaiAkhir,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'santriId': santriId,
      'tahunAjaran': tahunAjaran,
      'semester': semester,
      'totalPertemuan': totalPertemuan,
      'hadir': hadir,
      'sakit': sakit,
      'izin': izin,
      'alpa': alpa,
      'persentaseKehadiran': persentaseKehadiran,
      'nilaiAkhir': nilaiAkhir,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory RekapKehadiranModel.fromEntity(RekapKehadiranEntity entity) {
    return RekapKehadiranModel(
      id: entity.id,
      santriId: entity.santriId,
      tahunAjaran: entity.tahunAjaran,
      semester: entity.semester,
      totalPertemuan: entity.totalPertemuan,
      hadir: entity.hadir,
      sakit: entity.sakit,
      izin: entity.izin,
      alpa: entity.alpa,
      persentaseKehadiran: entity.persentaseKehadiran,
      nilaiAkhir: entity.nilaiAkhir,
      updatedAt: entity.updatedAt,
    );
  }
}
