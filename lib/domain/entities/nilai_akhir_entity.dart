import 'package:equatable/equatable.dart';

/// Nested class for assessment weights
class BobotNilai extends Equatable {
  final int tahfidz;
  final int fiqh;
  final int bahasaArab;
  final int akhlak;
  final int kehadiran;

  const BobotNilai({
    required this.tahfidz,
    required this.fiqh,
    required this.bahasaArab,
    required this.akhlak,
    required this.kehadiran,
  });

  @override
  List<Object?> get props => [tahfidz, fiqh, bahasaArab, akhlak, kehadiran];

  BobotNilai copyWith({
    int? tahfidz,
    int? fiqh,
    int? bahasaArab,
    int? akhlak,
    int? kehadiran,
  }) {
    return BobotNilai(
      tahfidz: tahfidz ?? this.tahfidz,
      fiqh: fiqh ?? this.fiqh,
      bahasaArab: bahasaArab ?? this.bahasaArab,
      akhlak: akhlak ?? this.akhlak,
      kehadiran: kehadiran ?? this.kehadiran,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tahfidz': tahfidz,
      'fiqh': fiqh,
      'bahasaArab': bahasaArab,
      'akhlak': akhlak,
      'kehadiran': kehadiran,
    };
  }

  factory BobotNilai.fromJson(Map<String, dynamic> json) {
    return BobotNilai(
      tahfidz: json['tahfidz'] as int,
      fiqh: json['fiqh'] as int,
      bahasaArab: json['bahasaArab'] as int,
      akhlak: json['akhlak'] as int,
      kehadiran: json['kehadiran'] as int,
    );
  }
}

/// Entity for final calculated grades with predicates
class NilaiAkhirEntity extends Equatable {
  final String id;
  final String santriId;
  final String tahunAjaran;
  final String semester;
  final double nilaiTahfidz;
  final double nilaiFiqh;
  final double nilaiBahasaArab;
  final double nilaiAkhlak;
  final double nilaiKehadiran;
  final BobotNilai bobot;
  final double nilaiAkhir;
  final String predikat; // "A" | "B" | "C" | "D"
  final DateTime calculatedAt;
  final String calculatedBy;

  const NilaiAkhirEntity({
    required this.id,
    required this.santriId,
    required this.tahunAjaran,
    required this.semester,
    required this.nilaiTahfidz,
    required this.nilaiFiqh,
    required this.nilaiBahasaArab,
    required this.nilaiAkhlak,
    required this.nilaiKehadiran,
    required this.bobot,
    required this.nilaiAkhir,
    required this.predikat,
    required this.calculatedAt,
    required this.calculatedBy,
  });

  @override
  List<Object?> get props => [
    id,
    santriId,
    tahunAjaran,
    semester,
    nilaiTahfidz,
    nilaiFiqh,
    nilaiBahasaArab,
    nilaiAkhlak,
    nilaiKehadiran,
    bobot,
    nilaiAkhir,
    predikat,
    calculatedAt,
    calculatedBy,
  ];

  /// Calculate predicate based on final score
  static String calculatePredikat(double nilaiAkhir) {
    if (nilaiAkhir >= 85) return 'A';
    if (nilaiAkhir >= 75) return 'B';
    if (nilaiAkhir >= 65) return 'C';
    return 'D';
  }

  NilaiAkhirEntity copyWith({
    String? id,
    String? santriId,
    String? tahunAjaran,
    String? semester,
    double? nilaiTahfidz,
    double? nilaiFiqh,
    double? nilaiBahasaArab,
    double? nilaiAkhlak,
    double? nilaiKehadiran,
    BobotNilai? bobot,
    double? nilaiAkhir,
    String? predikat,
    DateTime? calculatedAt,
    String? calculatedBy,
  }) {
    return NilaiAkhirEntity(
      id: id ?? this.id,
      santriId: santriId ?? this.santriId,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      semester: semester ?? this.semester,
      nilaiTahfidz: nilaiTahfidz ?? this.nilaiTahfidz,
      nilaiFiqh: nilaiFiqh ?? this.nilaiFiqh,
      nilaiBahasaArab: nilaiBahasaArab ?? this.nilaiBahasaArab,
      nilaiAkhlak: nilaiAkhlak ?? this.nilaiAkhlak,
      nilaiKehadiran: nilaiKehadiran ?? this.nilaiKehadiran,
      bobot: bobot ?? this.bobot,
      nilaiAkhir: nilaiAkhir ?? this.nilaiAkhir,
      predikat: predikat ?? this.predikat,
      calculatedAt: calculatedAt ?? this.calculatedAt,
      calculatedBy: calculatedBy ?? this.calculatedBy,
    );
  }
}
