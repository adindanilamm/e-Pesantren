import 'package:equatable/equatable.dart';

/// Entity for subject assessment (Fiqh & Bahasa Arab)
class PenilaianMapelEntity extends Equatable {
  final String id;
  final String santriId;
  final String mapel; // "Fiqh" or "Bahasa Arab"
  final int formatif; // Formative score 0-100
  final int sumatif; // Summative score 0-100
  final String semester; // "Ganjil" or "Genap"
  final String tahunAjaran; // e.g., "2024/2025"
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const PenilaianMapelEntity({
    required this.id,
    required this.santriId,
    required this.mapel,
    required this.formatif,
    required this.sumatif,
    required this.semester,
    required this.tahunAjaran,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
    id,
    santriId,
    mapel,
    formatif,
    sumatif,
    semester,
    tahunAjaran,
    createdAt,
    updatedAt,
    createdBy,
  ];

  /// Calculate final score (formatif 40% + sumatif 60%)
  double get nilaiAkhir => (formatif * 0.4) + (sumatif * 0.6);

  PenilaianMapelEntity copyWith({
    String? id,
    String? santriId,
    String? mapel,
    int? formatif,
    int? sumatif,
    String? semester,
    String? tahunAjaran,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return PenilaianMapelEntity(
      id: id ?? this.id,
      santriId: santriId ?? this.santriId,
      mapel: mapel ?? this.mapel,
      formatif: formatif ?? this.formatif,
      sumatif: sumatif ?? this.sumatif,
      semester: semester ?? this.semester,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
