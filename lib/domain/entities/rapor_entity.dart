import 'package:equatable/equatable.dart';

class RaporEntity extends Equatable {
  final String id;
  final String santriId;
  final String semester;
  final String tahunAjaran;

  // Calculated scores (0-100)
  final double nilaiTahfidz;
  final double nilaiFiqh;
  final double nilaiArabic;
  final double nilaiAkhlak;
  final double nilaiKehadiran;

  // Final weighted score
  final double nilaiAkhir;

  // Predikat: A, B, C, D
  final String predikat;

  final DateTime createdAt;

  const RaporEntity({
    required this.id,
    required this.santriId,
    required this.semester,
    required this.tahunAjaran,
    required this.nilaiTahfidz,
    required this.nilaiFiqh,
    required this.nilaiArabic,
    required this.nilaiAkhlak,
    required this.nilaiKehadiran,
    required this.nilaiAkhir,
    required this.predikat,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    santriId,
    semester,
    tahunAjaran,
    nilaiTahfidz,
    nilaiFiqh,
    nilaiArabic,
    nilaiAkhlak,
    nilaiKehadiran,
    nilaiAkhir,
    predikat,
    createdAt,
  ];

  RaporEntity copyWith({
    String? id,
    String? santriId,
    String? semester,
    String? tahunAjaran,
    double? nilaiTahfidz,
    double? nilaiFiqh,
    double? nilaiArabic,
    double? nilaiAkhlak,
    double? nilaiKehadiran,
    double? nilaiAkhir,
    String? predikat,
    DateTime? createdAt,
  }) {
    return RaporEntity(
      id: id ?? this.id,
      santriId: santriId ?? this.santriId,
      semester: semester ?? this.semester,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      nilaiTahfidz: nilaiTahfidz ?? this.nilaiTahfidz,
      nilaiFiqh: nilaiFiqh ?? this.nilaiFiqh,
      nilaiArabic: nilaiArabic ?? this.nilaiArabic,
      nilaiAkhlak: nilaiAkhlak ?? this.nilaiAkhlak,
      nilaiKehadiran: nilaiKehadiran ?? this.nilaiKehadiran,
      nilaiAkhir: nilaiAkhir ?? this.nilaiAkhir,
      predikat: predikat ?? this.predikat,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
