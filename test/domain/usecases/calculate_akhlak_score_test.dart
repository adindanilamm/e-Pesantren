import 'package:flutter_test/flutter_test.dart';
import 'package:e_penilaian_santri/domain/usecases/calculate_akhlak_score.dart';

void main() {
  late CalculateAkhlakScore useCase;

  setUp(() {
    useCase = CalculateAkhlakScore();
  });

  group('CalculateAkhlakScore', () {
    test('should calculate correct score with perfect scores', () {
      // Arrange
      const skorDisiplin = 4;
      const skorAdab = 4;
      const skorKebersihan = 4;
      const skorKerjasama = 4;

      // Act
      final result = useCase.execute(
        skorDisiplin: skorDisiplin,
        skorAdab: skorAdab,
        skorKebersihan: skorKebersihan,
        skorKerjasama: skorKerjasama,
      );

      // Assert
      // avg = (4+4+4+4)/4 = 4
      // nilai = (4/4)*100 = 100
      expect(result, 100.0);
    });

    test('should calculate correct score with minimum scores', () {
      // Arrange
      const skorDisiplin = 1;
      const skorAdab = 1;
      const skorKebersihan = 1;
      const skorKerjasama = 1;

      // Act
      final result = useCase.execute(
        skorDisiplin: skorDisiplin,
        skorAdab: skorAdab,
        skorKebersihan: skorKebersihan,
        skorKerjasama: skorKerjasama,
      );

      // Assert
      // avg = (1+1+1+1)/4 = 1
      // nilai = (1/4)*100 = 25
      expect(result, 25.0);
    });

    test('should calculate correct score with mixed values', () {
      // Arrange
      const skorDisiplin = 3;
      const skorAdab = 4;
      const skorKebersihan = 2;
      const skorKerjasama = 3;

      // Act
      final result = useCase.execute(
        skorDisiplin: skorDisiplin,
        skorAdab: skorAdab,
        skorKebersihan: skorKebersihan,
        skorKerjasama: skorKerjasama,
      );

      // Assert
      // avg = (3+4+2+3)/4 = 3
      // nilai = (3/4)*100 = 75
      expect(result, 75.0);
    });

    test('should round to nearest integer', () {
      // Arrange
      const skorDisiplin = 2;
      const skorAdab = 3;
      const skorKebersihan = 3;
      const skorKerjasama = 2;

      // Act
      final result = useCase.execute(
        skorDisiplin: skorDisiplin,
        skorAdab: skorAdab,
        skorKebersihan: skorKebersihan,
        skorKerjasama: skorKerjasama,
      );

      // Assert
      // avg = (2+3+3+2)/4 = 2.5
      // nilai = (2.5/4)*100 = 62.5, rounds to 63
      expect(result, 63.0);
    });

    test('should throw error when score is below minimum', () {
      // Arrange
      const skorDisiplin = 0; // Invalid
      const skorAdab = 2;
      const skorKebersihan = 3;
      const skorKerjasama = 4;

      // Act & Assert
      expect(
        () => useCase.execute(
          skorDisiplin: skorDisiplin,
          skorAdab: skorAdab,
          skorKebersihan: skorKebersihan,
          skorKerjasama: skorKerjasama,
        ),
        throwsArgumentError,
      );
    });

    test('should throw error when score is above maximum', () {
      // Arrange
      const skorDisiplin = 3;
      const skorAdab = 5; // Invalid
      const skorKebersihan = 3;
      const skorKerjasama = 4;

      // Act & Assert
      expect(
        () => useCase.execute(
          skorDisiplin: skorDisiplin,
          skorAdab: skorAdab,
          skorKebersihan: skorKebersihan,
          skorKerjasama: skorKerjasama,
        ),
        throwsArgumentError,
      );
    });
  });
}
