import 'package:equatable/equatable.dart';

class SantriEntity extends Equatable {
  final String id;
  final String nis; // Nomor Induk Santri
  final String nama;
  final String kamar;
  final int angkatan; // Year as integer
  final String? waliId; // ID of parent (wali santri)
  final DateTime createdAt;

  const SantriEntity({
    required this.id,
    required this.nis,
    required this.nama,
    required this.kamar,
    required this.angkatan,
    this.waliId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    nis,
    nama,
    kamar,
    angkatan,
    waliId,
    createdAt,
  ];

  SantriEntity copyWith({
    String? id,
    String? nis,
    String? nama,
    String? kamar,
    int? angkatan,
    String? waliId,
    DateTime? createdAt,
  }) {
    return SantriEntity(
      id: id ?? this.id,
      nis: nis ?? this.nis,
      nama: nama ?? this.nama,
      kamar: kamar ?? this.kamar,
      angkatan: angkatan ?? this.angkatan,
      waliId: waliId ?? this.waliId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
