import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/bobot_penilaian_entity.dart';

class BobotPenilaianModel extends BobotPenilaianEntity {
  const BobotPenilaianModel({
    required super.id,
    required super.tahunAjaran,
    required super.semester,
    required super.bobotTahfidz,
    required super.bobotFiqh,
    required super.bobotBahasaArab,
    required super.bobotAkhlak,
    required super.bobotKehadiran,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BobotPenilaianModel.fromJson(Map<String, dynamic> json) {
    return BobotPenilaianModel(
      id: json['id'] ?? '',
      tahunAjaran: json['tahunAjaran'] ?? '',
      semester: json['semester'] ?? '',
      bobotTahfidz: json['bobot']?['tahfidz'] ?? 30,
      bobotFiqh: json['bobot']?['fiqh'] ?? 20,
      bobotBahasaArab: json['bobot']?['bahasaArab'] ?? 20,
      bobotAkhlak: json['bobot']?['akhlak'] ?? 20,
      bobotKehadiran: json['bobot']?['kehadiran'] ?? 10,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  factory BobotPenilaianModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final bobot = data['bobot'] as Map<String, dynamic>?;

    return BobotPenilaianModel(
      id: doc.id,
      tahunAjaran: data['tahunAjaran'] ?? '',
      semester: data['semester'] ?? '',
      bobotTahfidz: bobot?['tahfidz'] ?? 30,
      bobotFiqh: bobot?['fiqh'] ?? 20,
      bobotBahasaArab: bobot?['bahasaArab'] ?? 20,
      bobotAkhlak: bobot?['akhlak'] ?? 20,
      bobotKehadiran: bobot?['kehadiran'] ?? 10,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tahunAjaran': tahunAjaran,
      'semester': semester,
      'bobot': {
        'tahfidz': bobotTahfidz,
        'fiqh': bobotFiqh,
        'bahasaArab': bobotBahasaArab,
        'akhlak': bobotAkhlak,
        'kehadiran': bobotKehadiran,
      },
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tahunAjaran': tahunAjaran,
      'semester': semester,
      'bobot': {
        'tahfidz': bobotTahfidz,
        'fiqh': bobotFiqh,
        'bahasaArab': bobotBahasaArab,
        'akhlak': bobotAkhlak,
        'kehadiran': bobotKehadiran,
      },
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory BobotPenilaianModel.fromEntity(BobotPenilaianEntity entity) {
    return BobotPenilaianModel(
      id: entity.id,
      tahunAjaran: entity.tahunAjaran,
      semester: entity.semester,
      bobotTahfidz: entity.bobotTahfidz,
      bobotFiqh: entity.bobotFiqh,
      bobotBahasaArab: entity.bobotBahasaArab,
      bobotAkhlak: entity.bobotAkhlak,
      bobotKehadiran: entity.bobotKehadiran,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
