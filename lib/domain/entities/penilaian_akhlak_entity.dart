import 'package:equatable/equatable.dart';

/// Entity for character assessment (1-4 scale)
class PenilaianAkhlakEntity extends Equatable {
  final String id;
  final String santriId;
  final int disiplin; // 1-4 scale
  final int adab; // 1-4 scale
  final int kebersihan; // 1-4 scale
  final int kerjasama; // 1-4 scale
  final String? catatan; // Optional notes
  final String semester; // "Ganjil" or "Genap"
  final String tahunAjaran; // e.g., "2024/2025"
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const PenilaianAkhlakEntity({
    required this.id,
    required this.santriId,
    required this.disiplin,
    required this.adab,
    required this.kebersihan,
    required this.kerjasama,
    this.catatan,
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
    disiplin,
    adab,
    kebersihan,
    kerjasama,
    catatan,
    semester,
    tahunAjaran,
    createdAt,
    updatedAt,
    createdBy,
  ];

  /// Calculate average score (1-4 scale)
  double get rataRata => (disiplin + adab + kebersihan + kerjasama) / 4;

  /// Convert to 0-100 scale
  double get nilaiAkhir => (rataRata / 4) * 100;

  PenilaianAkhlakEntity copyWith({
    String? id,
    String? santriId,
    int? disiplin,
    int? adab,
    int? kebersihan,
    int? kerjasama,
    String? catatan,
    String? semester,
    String? tahunAjaran,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return PenilaianAkhlakEntity(
      id: id ?? this.id,
      santriId: santriId ?? this.santriId,
      disiplin: disiplin ?? this.disiplin,
      adab: adab ?? this.adab,
      kebersihan: kebersihan ?? this.kebersihan,
      kerjasama: kerjasama ?? this.kerjasama,
      catatan: catatan ?? this.catatan,
      semester: semester ?? this.semester,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
