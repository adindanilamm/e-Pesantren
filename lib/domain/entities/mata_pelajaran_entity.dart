import 'package:equatable/equatable.dart';

/// Entity for subject/aspect master data
class MataPelajaranEntity extends Equatable {
  final String id;
  final String kode;
  final String nama;
  final String jenis; // "akademik" | "akhlak" | "kehadiran"
  final bool aktif;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MataPelajaranEntity({
    required this.id,
    required this.kode,
    required this.nama,
    required this.jenis,
    required this.aktif,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    kode,
    nama,
    jenis,
    aktif,
    createdAt,
    updatedAt,
  ];

  MataPelajaranEntity copyWith({
    String? id,
    String? kode,
    String? nama,
    String? jenis,
    bool? aktif,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MataPelajaranEntity(
      id: id ?? this.id,
      kode: kode ?? this.kode,
      nama: nama ?? this.nama,
      jenis: jenis ?? this.jenis,
      aktif: aktif ?? this.aktif,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
