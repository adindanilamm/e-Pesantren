import 'package:equatable/equatable.dart';

/// Entity for weekly Quran memorization assessment
class PenilaianTahfidzEntity extends Equatable {
  final String id;
  final String santriId;
  final DateTime minggu; // Week start date
  final String surah;
  final int ayatSetor; // Number of verses memorized
  final int tajwid; // Tajwid score 0-100
  final DateTime createdAt;
  final String createdBy;

  const PenilaianTahfidzEntity({
    required this.id,
    required this.santriId,
    required this.minggu,
    required this.surah,
    required this.ayatSetor,
    required this.tajwid,
    required this.createdAt,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
    id,
    santriId,
    minggu,
    surah,
    ayatSetor,
    tajwid,
    createdAt,
    createdBy,
  ];

  PenilaianTahfidzEntity copyWith({
    String? id,
    String? santriId,
    DateTime? minggu,
    String? surah,
    int? ayatSetor,
    int? tajwid,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return PenilaianTahfidzEntity(
      id: id ?? this.id,
      santriId: santriId ?? this.santriId,
      minggu: minggu ?? this.minggu,
      surah: surah ?? this.surah,
      ayatSetor: ayatSetor ?? this.ayatSetor,
      tajwid: tajwid ?? this.tajwid,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
