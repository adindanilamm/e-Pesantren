import 'package:equatable/equatable.dart';

/// Entity for character assessment rubric
class RubrikAkhlakEntity extends Equatable {
  final String id;
  final String indikator;
  final Map<int, String> deskripsiSkala; // 1-4 scale descriptions
  final int urutan;
  final bool aktif;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RubrikAkhlakEntity({
    required this.id,
    required this.indikator,
    required this.deskripsiSkala,
    required this.urutan,
    required this.aktif,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    indikator,
    deskripsiSkala,
    urutan,
    aktif,
    createdAt,
    updatedAt,
  ];

  RubrikAkhlakEntity copyWith({
    String? id,
    String? indikator,
    Map<int, String>? deskripsiSkala,
    int? urutan,
    bool? aktif,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RubrikAkhlakEntity(
      id: id ?? this.id,
      indikator: indikator ?? this.indikator,
      deskripsiSkala: deskripsiSkala ?? this.deskripsiSkala,
      urutan: urutan ?? this.urutan,
      aktif: aktif ?? this.aktif,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
