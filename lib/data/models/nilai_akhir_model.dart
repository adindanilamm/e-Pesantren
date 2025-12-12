import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/nilai_akhir_entity.dart';

class NilaiAkhirModel extends NilaiAkhirEntity {
  const NilaiAkhirModel({
    required super.id,
    required super.santriId,
    required super.tahunAjaran,
    required super.semester,
    required super.nilaiTahfidz,
    required super.nilaiFiqh,
    required super.nilaiBahasaArab,
    required super.nilaiAkhlak,
    required super.nilaiKehadiran,
    required super.bobot,
    required super.nilaiAkhir,
    required super.predikat,
    required super.calculatedAt,
    required super.calculatedBy,
  });

  factory NilaiAkhirModel.fromJson(Map<String, dynamic> json) {
    return NilaiAkhirModel(
      id: json['id'] ?? '',
      santriId: json['santriId'] ?? '',
      tahunAjaran: json['tahunAjaran'] ?? '',
      semester: json['semester'] ?? '',
      nilaiTahfidz: (json['nilaiTahfidz'] ?? 0).toDouble(),
      nilaiFiqh: (json['nilaiFiqh'] ?? 0).toDouble(),
      nilaiBahasaArab: (json['nilaiBahasaArab'] ?? 0).toDouble(),
      nilaiAkhlak: (json['nilaiAkhlak'] ?? 0).toDouble(),
      nilaiKehadiran: (json['nilaiKehadiran'] ?? 0).toDouble(),
      bobot: BobotNilai.fromJson(json['bobot'] ?? {}),
      nilaiAkhir: (json['nilaiAkhir'] ?? 0).toDouble(),
      predikat: json['predikat'] ?? 'D',
      calculatedAt: json['calculatedAt'] is Timestamp
          ? (json['calculatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      calculatedBy: json['calculatedBy'] ?? '',
    );
  }

  factory NilaiAkhirModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NilaiAkhirModel(
      id: doc.id,
      santriId: data['santriId'] ?? '',
      tahunAjaran: data['tahunAjaran'] ?? '',
      semester: data['semester'] ?? '',
      nilaiTahfidz: (data['nilaiTahfidz'] ?? 0).toDouble(),
      nilaiFiqh: (data['nilaiFiqh'] ?? 0).toDouble(),
      nilaiBahasaArab: (data['nilaiBahasaArab'] ?? 0).toDouble(),
      nilaiAkhlak: (data['nilaiAkhlak'] ?? 0).toDouble(),
      nilaiKehadiran: (data['nilaiKehadiran'] ?? 0).toDouble(),
      bobot: BobotNilai.fromJson(data['bobot'] ?? {}),
      nilaiAkhir: (data['nilaiAkhir'] ?? 0).toDouble(),
      predikat: data['predikat'] ?? 'D',
      calculatedAt:
          (data['calculatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      calculatedBy: data['calculatedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'santriId': santriId,
      'tahunAjaran': tahunAjaran,
      'semester': semester,
      'nilaiTahfidz': nilaiTahfidz,
      'nilaiFiqh': nilaiFiqh,
      'nilaiBahasaArab': nilaiBahasaArab,
      'nilaiAkhlak': nilaiAkhlak,
      'nilaiKehadiran': nilaiKehadiran,
      'bobot': bobot.toJson(),
      'nilaiAkhir': nilaiAkhir,
      'predikat': predikat,
      'calculatedAt': calculatedAt.millisecondsSinceEpoch,
      'calculatedBy': calculatedBy,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'santriId': santriId,
      'tahunAjaran': tahunAjaran,
      'semester': semester,
      'nilaiTahfidz': nilaiTahfidz,
      'nilaiFiqh': nilaiFiqh,
      'nilaiBahasaArab': nilaiBahasaArab,
      'nilaiAkhlak': nilaiAkhlak,
      'nilaiKehadiran': nilaiKehadiran,
      'bobot': bobot.toJson(),
      'nilaiAkhir': nilaiAkhir,
      'predikat': predikat,
      'calculatedAt': Timestamp.fromDate(calculatedAt),
      'calculatedBy': calculatedBy,
    };
  }

  factory NilaiAkhirModel.fromEntity(NilaiAkhirEntity entity) {
    return NilaiAkhirModel(
      id: entity.id,
      santriId: entity.santriId,
      tahunAjaran: entity.tahunAjaran,
      semester: entity.semester,
      nilaiTahfidz: entity.nilaiTahfidz,
      nilaiFiqh: entity.nilaiFiqh,
      nilaiBahasaArab: entity.nilaiBahasaArab,
      nilaiAkhlak: entity.nilaiAkhlak,
      nilaiKehadiran: entity.nilaiKehadiran,
      bobot: entity.bobot,
      nilaiAkhir: entity.nilaiAkhir,
      predikat: entity.predikat,
      calculatedAt: entity.calculatedAt,
      calculatedBy: entity.calculatedBy,
    );
  }
}
