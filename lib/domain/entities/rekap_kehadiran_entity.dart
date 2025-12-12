import 'package:equatable/equatable.dart';

/// Entity for aggregated attendance summary per student per semester
class RekapKehadiranEntity extends Equatable {
  final String id;
  final String santriId;
  final String tahunAjaran;
  final String semester;
  final int totalPertemuan;
  final int hadir;
  final int sakit;
  final int izin;
  final int alpa;
  final double persentaseKehadiran;
  final double nilaiAkhir;
  final DateTime updatedAt;

  const RekapKehadiranEntity({
    required this.id,
    required this.santriId,
    required this.tahunAjaran,
    required this.semester,
    required this.totalPertemuan,
    required this.hadir,
    required this.sakit,
    required this.izin,
    required this.alpa,
    required this.persentaseKehadiran,
    required this.nilaiAkhir,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    santriId,
    tahunAjaran,
    semester,
    totalPertemuan,
    hadir,
    sakit,
    izin,
    alpa,
    persentaseKehadiran,
    nilaiAkhir,
    updatedAt,
  ];

  RekapKehadiranEntity copyWith({
    String? id,
    String? santriId,
    String? tahunAjaran,
    String? semester,
    int? totalPertemuan,
    int? hadir,
    int? sakit,
    int? izin,
    int? alpa,
    double? persentaseKehadiran,
    double? nilaiAkhir,
    DateTime? updatedAt,
  }) {
    return RekapKehadiranEntity(
      id: id ?? this.id,
      santriId: santriId ?? this.santriId,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      semester: semester ?? this.semester,
      totalPertemuan: totalPertemuan ?? this.totalPertemuan,
      hadir: hadir ?? this.hadir,
      sakit: sakit ?? this.sakit,
      izin: izin ?? this.izin,
      alpa: alpa ?? this.alpa,
      persentaseKehadiran: persentaseKehadiran ?? this.persentaseKehadiran,
      nilaiAkhir: nilaiAkhir ?? this.nilaiAkhir,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
