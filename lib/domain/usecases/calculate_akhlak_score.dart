import '../../../core/constants/app_constants.dart';

/// Use case untuk menghitung nilai Akhlak
///
/// Formula:
/// 1. Hitung rata-rata dari 4 indikator (skala 1-4)
/// 2. Konversi ke skala 100: round((avg / 4) * 100)
class CalculateAkhlakScore {
  double execute({
    required int skorDisiplin,
    required int skorAdab,
    required int skorKebersihan,
    required int skorKerjasama,
  }) {
    // Validasi input - setiap skor harus 1-4
    final scores = [skorDisiplin, skorAdab, skorKebersihan, skorKerjasama];

    for (var score in scores) {
      if (score < AppConstants.akhlakMinScore ||
          score > AppConstants.akhlakMaxScore) {
        throw ArgumentError(
          'Skor akhlak harus antara ${AppConstants.akhlakMinScore}-${AppConstants.akhlakMaxScore}',
        );
      }
    }

    // Hitung rata-rata
    double average =
        (skorDisiplin + skorAdab + skorKebersihan + skorKerjasama) /
        AppConstants.akhlakIndicatorCount;

    // Konversi ke skala 100
    double nilaiAkhir = (average / AppConstants.akhlakMaxScore) * 100;

    // Round ke bilangan bulat terdekat
    return nilaiAkhir.roundToDouble();
  }
}
