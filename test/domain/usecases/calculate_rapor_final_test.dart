import 'package:flutter_test/flutter_test.dart';
import 'package:e_penilaian_santri/domain/usecases/calculate_rapor_final.dart';

void main() {
  late CalculateRaporFinal useCase;

  setUp(() {
    useCase = CalculateRaporFinal();
  });

  group('CalculateRaporFinal', () {
    test('should calculate final score with weighted average', () {
      // Arrange
      const nilaiTahfidz = 90.0;
      const nilaiFiqh = 85.0;
      const nilaiArabic = 80.0;
      const nilaiAkhlak = 88.0;
      const nilaiKehadiran = 95.0;

      // Act
      final result = useCase.execute(
        nilaiTahfidz: nilaiTahfidz,
        nilaiFiqh: nilaiFiqh,
        nilaiArabic: nilaiArabic,
        nilaiAkhlak: nilaiAkhlak,
        nilaiKehadiran: nilaiKehadiran,
      );

      //Assert
      // Final = 0.3*90 + 0.2*85 + 0.2*80 + 0.2*88 + 0.1*95
      //       = 27 + 17 + 16 + 17.6 + 9.5 = 87.1, rounds to 87
      expect(result['nilaiAkhir'], 87.0);
      expect(result['predikat'], 'A');
    });

    test('should assign predikat A for score >= 85', () {
      // Arrange
      const nilaiTahfidz = 85.0;
      const nilaiFiqh = 85.0;
      const nilaiArabic = 85.0;
      const nilaiAkhlak = 85.0;
      const nilaiKehadiran = 85.0;

      // Act
      final result = useCase.execute(
        nilaiTahfidz: nilaiTahfidz,
        nilaiFiqh: nilaiFiqh,
        nilaiArabic: nilaiArabic,
        nilaiAkhlak: nilaiAkhlak,
        nilaiKehadiran: nilaiKehadiran,
      );

      // Assert
      expect(result['nilaiAkhir'], 85.0);
      expect(result['predikat'], 'A');
    });

    test('should assign predikat B for score 75-84', () {
      // Arrange
      const nilaiTahfidz = 80.0;
      const nilaiFiqh = 75.0;
      const nilaiArabic = 75.0;
      const nilaiAkhlak = 80.0;
      const nilaiKehadiran = 85.0;

      // Act
      final result = useCase.execute(
        nilaiTahfidz: nilaiTahfidz,
        nilaiFiqh: nilaiFiqh,
        nilaiArabic: nilaiArabic,
        nilaiAkhlak: nilaiAkhlak,
        nilaiKehadiran: nilaiKehadiran,
      );

      // Assert
      // Final = 0.3*80 + 0.2*75 + 0.2*75 + 0.2*80 + 0.1*85
      //       = 24 + 15 + 15 + 16 + 8.5 = 78.5, rounds to 79
      expect(result['nilaiAkhir'], 79.0);
      expect(result['predikat'], 'B');
    });

    test('should assign predikat C for score 65-74', () {
      // Arrange
      const nilaiTahfidz = 70.0;
      const nilaiFiqh = 65.0;
      const nilaiArabic = 70.0;
      const nilaiAkhlak = 68.0;
      const nilaiKehadiran = 75.0;

      // Act
      final result = useCase.execute(
        nilaiTahfidz: nilaiTahfidz,
        nilaiFiqh: nilaiFiqh,
        nilaiArabic: nilaiArabic,
        nilaiAkhlak: nilaiAkhlak,
        nilaiKehadiran: nilaiKehadiran,
      );

      // Assert
      // Final = 0.3*70 + 0.2*65 + 0.2*70 + 0.2*68 + 0.1*75
      //       = 21 + 13 + 14 + 13.6 + 7.5 = 69.1, rounds to 69
      expect(result['nilaiAkhir'], 69.0);
      expect(result['predikat'], 'C');
    });

    test('should assign predikat D for score < 65', () {
      // Arrange
      const nilaiTahfidz = 60.0;
      const nilaiFiqh = 55.0;
      const nilaiArabic = 60.0;
      const nilaiAkhlak = 58.0;
      const nilaiKehadiran = 65.0;

      // Act
      final result = useCase.execute(
        nilaiTahfidz: nilaiTahfidz,
        nilaiFiqh: nilaiFiqh,
        nilaiArabic: nilaiArabic,
        nilaiAkhlak: nilaiAkhlak,
        nilaiKehadiran: nilaiKehadiran,
      );

      // Assert
      // Final = 0.3*60 + 0.2*55 + 0.2*60 + 0.2*58 + 0.1*65
      //       = 18 + 11 + 12 + 11.6 + 6.5 = 59.1, rounds to 59
      expect(result['nilaiAkhir'], 59.0);
      expect(result['predikat'], 'D');
    });

    test('should calculate with perfect scores', () {
      // Arrange
      const nilaiTahfidz = 100.0;
      const nilaiFiqh = 100.0;
      const nilaiArabic = 100.0;
      const nilaiAkhlak = 100.0;
      const nilaiKehadiran = 100.0;

      // Act
      final result = useCase.execute(
        nilaiTahfidz: nilaiTahfidz,
        nilaiFiqh: nilaiFiqh,
        nilaiArabic: nilaiArabic,
        nilaiAkhlak: nilaiAkhlak,
        nilaiKehadiran: nilaiKehadiran,
      );

      // Assert
      expect(result['nilaiAkhir'], 100.0);
      expect(result['predikat'], 'A');
    });

    test('should throw error when any score is out of range', () {
      // Arrange
      const nilaiTahfidz = 150.0; // Invalid
      const nilaiFiqh = 85.0;
      const nilaiArabic = 80.0;
      const nilaiAkhlak = 88.0;
      const nilaiKehadiran = 95.0;

      // Act & Assert
      expect(
        () => useCase.execute(
          nilaiTahfidz: nilaiTahfidz,
          nilaiFiqh: nilaiFiqh,
          nilaiArabic: nilaiArabic,
          nilaiAkhlak: nilaiAkhlak,
          nilaiKehadiran: nilaiKehadiran,
        ),
        throwsArgumentError,
      );
    });

    test('should verify correct weights are applied', () {
      // Arrange - Using distinct values to verify weights
      const nilaiTahfidz = 100.0; // Weight: 30%
      const nilaiFiqh = 0.0; // Weight: 20%
      const nilaiArabic = 0.0; // Weight: 20%
      const nilaiAkhlak = 0.0; // Weight: 20%
      const nilaiKehadiran = 0.0; // Weight: 10%

      // Act
      final result = useCase.execute(
        nilaiTahfidz: nilaiTahfidz,
        nilaiFiqh: nilaiFiqh,
        nilaiArabic: nilaiArabic,
        nilaiAkhlak: nilaiAkhlak,
        nilaiKehadiran: nilaiKehadiran,
      );

      // Assert
      // Should be exactly 30 (30% of 100)
      expect(result['nilaiAkhir'], 30.0);
    });
  });
}
