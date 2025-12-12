import 'package:flutter_test/flutter_test.dart';
import 'package:e_penilaian_santri/domain/usecases/calculate_kehadiran_score.dart';

void main() {
  late CalculateKehadiranScore useCase;

  setUp(() {
    useCase = CalculateKehadiranScore();
  });

  group('CalculateKehadiranScore', () {
    test('should calculate correct percentage with normal values', () {
      // Arrange
      const hadir = 80;
      const sakit = 5;
      const izin = 3;
      const alpa = 2;

      // Act
      final result = useCase.execute(
        hadir: hadir,
        sakit: sakit,
        izin: izin,
        alpa: alpa,
      );

      // Assert
      // total = 80+5+3+2 = 90
      // persentase = (80/90)*100 = 88.89, rounds to 89
      expect(result, 89.0);
    });

    test('should return 100 when perfect attendance', () {
      // Arrange
      const hadir = 100;
      const sakit = 0;
      const izin = 0;
      const alpa = 0;

      // Act
      final result = useCase.execute(
        hadir: hadir,
        sakit: sakit,
        izin: izin,
        alpa: alpa,
      );

      // Assert
      expect(result, 100.0);
    });

    test('should return 0 when never attended', () {
      // Arrange
      const hadir = 0;
      const sakit = 10;
      const izin = 5;
      const alpa = 15;

      // Act
      final result = useCase.execute(
        hadir: hadir,
        sakit: sakit,
        izin: izin,
        alpa: alpa,
      );

      // Assert
      expect(result, 0.0);
    });

    test('should return 0 when no data available', () {
      // Arrange
      const hadir = 0;
      const sakit = 0;
      const izin = 0;
      const alpa = 0;

      // Act
      final result = useCase.execute(
        hadir: hadir,
        sakit: sakit,
        izin: izin,
        alpa: alpa,
      );

      // Assert
      expect(result, 0.0);
    });

    test('should round to nearest integer', () {
      // Arrange
      const hadir = 85;
      const sakit = 10;
      const izin = 3;
      const alpa = 2;

      // Act
      final result = useCase.execute(
        hadir: hadir,
        sakit: sakit,
        izin: izin,
        alpa: alpa,
      );

      // Assert
      // total = 100
      // persentase = 85%
      expect(result, 85.0);
    });

    test('should throw error when values are negative', () {
      // Arrange
      const hadir = -5; // Invalid
      const sakit = 10;
      const izin = 3;
      const alpa = 2;

      // Act & Assert
      expect(
        () =>
            useCase.execute(hadir: hadir, sakit: sakit, izin: izin, alpa: alpa),
        throwsArgumentError,
      );
    });
  });
}
