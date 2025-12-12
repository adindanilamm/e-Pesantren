import '../entities/kehadiran_entity.dart';

abstract class KehadiranRepository {
  /// Create new attendance record
  Future<void> createKehadiran(KehadiranEntity kehadiran);

  /// Get all attendance records for a santri
  Future<List<KehadiranEntity>> getKehadiranBySantri(String santriId);

  /// Get attendance for a specific date
  Future<KehadiranEntity?> getKehadiranByDate(
    String santriId,
    DateTime tanggal,
  );

  /// Get attendance records for a date range
  Future<List<KehadiranEntity>> getKehadiranByDateRange(
    String santriId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Update attendance record
  Future<void> updateKehadiran(KehadiranEntity kehadiran);

  /// Delete attendance record
  Future<void> deleteKehadiran(String id);

  /// Get attendance summary (count by status)
  Future<Map<String, int>> getKehadiranSummary(
    String santriId,
    DateTime startDate,
    DateTime endDate,
  );
}
