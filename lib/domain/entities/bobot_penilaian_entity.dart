import 'package:equatable/equatable.dart';

/// Entity for configurable assessment weights
class BobotPenilaianEntity extends Equatable {
  final String id;
  final String tahunAjaran;
  final String semester;
  final int bobotTahfidz;
  final int bobotFiqh;
  final int bobotBahasaArab;
  final int bobotAkhlak;
  final int bobotKehadiran;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BobotPenilaianEntity({
    required this.id,
    required this.tahunAjaran,
    required this.semester,
    required this.bobotTahfidz,
    required this.bobotFiqh,
    required this.bobotBahasaArab,
    required this.bobotAkhlak,
    required this.bobotKehadiran,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    tahunAjaran,
    semester,
    bobotTahfidz,
    bobotFiqh,
    bobotBahasaArab,
    bobotAkhlak,
    bobotKehadiran,
    createdAt,
    updatedAt,
  ];

  /// Validate that weights sum to 100
  bool get isValid =>
      bobotTahfidz +
          bobotFiqh +
          bobotBahasaArab +
          bobotAkhlak +
          bobotKehadiran ==
      100;

  BobotPenilaianEntity copyWith({
    String? id,
    String? tahunAjaran,
    String? semester,
    int? bobotTahfidz,
    int? bobotFiqh,
    int? bobotBahasaArab,
    int? bobotAkhlak,
    int? bobotKehadiran,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BobotPenilaianEntity(
      id: id ?? this.id,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      semester: semester ?? this.semester,
      bobotTahfidz: bobotTahfidz ?? this.bobotTahfidz,
      bobotFiqh: bobotFiqh ?? this.bobotFiqh,
      bobotBahasaArab: bobotBahasaArab ?? this.bobotBahasaArab,
      bobotAkhlak: bobotAkhlak ?? this.bobotAkhlak,
      bobotKehadiran: bobotKehadiran ?? this.bobotKehadiran,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
