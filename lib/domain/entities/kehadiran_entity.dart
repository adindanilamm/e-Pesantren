import 'package:equatable/equatable.dart';

/// Entity for daily attendance
class KehadiranEntity extends Equatable {
  final String id;
  final String santriId;
  final DateTime tanggal; // Attendance date
  final String status; // "H" (Hadir), "S" (Sakit), "I" (Izin), "A" (Alpa)
  final String? keterangan; // Optional notes
  final DateTime createdAt;
  final String createdBy;

  const KehadiranEntity({
    required this.id,
    required this.santriId,
    required this.tanggal,
    required this.status,
    this.keterangan,
    required this.createdAt,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
    id,
    santriId,
    tanggal,
    status,
    keterangan,
    createdAt,
    createdBy,
  ];

  /// Check if status is valid
  bool get isValidStatus => ['H', 'S', 'I', 'A'].contains(status);

  KehadiranEntity copyWith({
    String? id,
    String? santriId,
    DateTime? tanggal,
    String? status,
    String? keterangan,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return KehadiranEntity(
      id: id ?? this.id,
      santriId: santriId ?? this.santriId,
      tanggal: tanggal ?? this.tanggal,
      status: status ?? this.status,
      keterangan: keterangan ?? this.keterangan,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
