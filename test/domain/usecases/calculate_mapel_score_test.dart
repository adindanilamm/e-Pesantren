import 'package:flutter_test/flutter_test.dart';
import 'package:e_penilaian_santri/domain/usecases/calculate_mapel_score.dart';

void main() {
  late CalculateMapelScore useCase;

  setUp(() {
    useCase = CalculateMapelScore();
  });

  group('CalculateMapelScore', () {
    test('should calculate correct score with normal values', () {
      // Arrange
      const nilaiFormatif = 80.0;
      const nilaiSumatif = 90.0;

      // Act
      final result = useCase.execute(
        nilaiFormatif: nilaiFormatif,
        nilaiSumatif: nilaiSumatif,
      );

      // Assert
      // nilai_akhir = round(0.4 * 80 + 0.6 * 90)
      //             = round(32 + 54) = 86
      expect(result, 86.0);
    });

    test('should calculate score with perfect scores', () {
      // Arrange
      const nilaiFormatif = 100.0;
      const nilaiSumatif = 100.0;

      // Act
      final result = useCase.execute(
        nilaiFormatif: nilaiFormatif,
        nilaiSumatif: nilaiSumatif,
      );

      // Assert
      expect(result, 100.0);
    });

    test('should calculate score with zero formatif', () {
      // Arrange
      const nilaiFormatif = 0.0;
      const nilaiSumatif = 100.0;

      // Act
      final result = useCase.execute(
        nilaiFormatif: nilaiFormatif,
        nilaiSumatif: nilaiSumatif,
      );

      // Assert
      // nilai_akhir = round(0.4 * 0 + 0.6 * 100) = 60
      expect(result, 60.0);
    });

    test('should round to nearest integer', () {
      // Arrange
      const nilaiFormatif = 75.0;
      const nilaiSumatif = 76.0;

      // Act
      final result = useCase.execute(
        nilaiFormatif: nilaiFormatif,
        nilaiSumatif: nilaiSumatif,
      );

      // Assert
      // nilai_akhir = 0.4 * 75 + 0.6 * 76 = 30 + 45.6 = 75.6, rounds to 76
      expect(result, 76.0);
    });

    test('should throw error when formatif is out of range', () {
      // Arrange
      const nilaiFormatif = 150.0; // Invalid
      const nilaiSumatif = 80.0;

      // Act & Assert
      expect(
        () => useCase.execute(
          nilaiFormatif: nilaiFormatif,
          nilaiSumatif: nilaiSumatif,
        ),
        throwsArgumentError,
      );
    });

    test('should throw error when sumatif is negative', () {
      // Arrange
      const nilaiFormatif = 80.0;
      const nilaiSumatif = -10.0; // Invalid

      // Act & Assert
      expect(
        () => useCase.execute(
          nilaiFormatif: nilaiFormatif,
          nilaiSumatif: nilaiSumatif,
        ),
        throwsArgumentError,
      );
    });
  });
}
