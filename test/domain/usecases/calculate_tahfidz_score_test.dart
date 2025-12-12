import 'package:flutter_test/flutter_test.dart';
import 'package:e_penilaian_santri/domain/usecases/calculate_tahfidz_score.dart';

void main() {
  late CalculateTahfidzScore useCase;

  setUp(() {
    useCase = CalculateTahfidzScore();
  });

  group('CalculateTahfidzScore', () {
    test('should calculate correct score with normal values', () {
      // Arrange
      const targetAyat = 100;
      const setoranAyat = 80;
      const nilaiTajwid = 90.0;

      // Act
      final result = useCase.execute(
        targetAyat: targetAyat,
        setoranAyat: setoranAyat,
        nilaiTajwid: nilaiTajwid,
      );

      // Assert
      // capaian = (80/100) * 100 = 80
      // nilai_akhir = round(0.5 * 80 + 0.5 * 90) = round(85) = 85
      expect(result, 85.0);
    });

    test('should cap capaian at 100 when setoran exceeds target', () {
      // Arrange
      const targetAyat = 100;
      const setoranAyat = 120; // Melebihi target
      const nilaiTajwid = 80.0;

      // Act
      final result = useCase.execute(
        targetAyat: targetAyat,
        setoranAyat: setoranAyat,
        nilaiTajwid: nilaiTajwid,
      );

      // Assert
      // capaian = min(120, 100) = 100
      // nilai_akhir = round(0.5 * 100 + 0.5 * 80) = 90
      expect(result, 90.0);
    });

    test('should calculate score with zero setoran', () {
      // Arrange
      const targetAyat = 100;
      const setoranAyat = 0;
      const nilaiTajwid = 100.0;

      // Act
      final result = useCase.execute(
        targetAyat: targetAyat,
        setoranAyat: setoranAyat,
        nilaiTajwid: nilaiTajwid,
      );

      // Assert
      // capaian = 0
      // nilai_akhir = round(0.5 * 0 + 0.5 * 100) = 50
      expect(result, 50.0);
    });

    test('should round to nearest integer', () {
      // Arrange
      const targetAyat = 100;
      const setoranAyat = 50;
      const nilaiTajwid = 51.0;

      // Act
      final result = useCase.execute(
        targetAyat: targetAyat,
        setoranAyat: setoranAyat,
        nilaiTajwid: nilaiTajwid,
      );

      // Assert
      // capaian = 50
      // nilai_akhir = 0.5 * 50 + 0.5 * 51 = 50.5, rounds to 51
      expect(result, 51.0);
    });

    test('should throw error when target ayat is zero', () {
      // Arrange
      const targetAyat = 0;
      const setoranAyat = 50;
      const nilaiTajwid = 80.0;

      // Act & Assert
      expect(
        () => useCase.execute(
          targetAyat: targetAyat,
          setoranAyat: setoranAyat,
          nilaiTajwid: nilaiTajwid,
        ),
        throwsArgumentError,
      );
    });

    test('should throw error when setoran ayat is negative', () {
      // Arrange
      const targetAyat = 100;
      const setoranAyat = -10;
      const nilaiTajwid = 80.0;

      // Act & Assert
      expect(
        () => useCase.execute(
          targetAyat: targetAyat,
          setoranAyat: setoranAyat,
          nilaiTajwid: nilaiTajwid,
        ),
        throwsArgumentError,
      );
    });

    test('should throw error when nilai tajwid is out of range', () {
      // Arrange
      const targetAyat = 100;
      const setoranAyat = 50;
      const nilaiTajwid = 150.0; // Invalid

      // Act & Assert
      expect(
        () => useCase.execute(
          targetAyat: targetAyat,
          setoranAyat: setoranAyat,
          nilaiTajwid: nilaiTajwid,
        ),
        throwsArgumentError,
      );
    });
  });
}
