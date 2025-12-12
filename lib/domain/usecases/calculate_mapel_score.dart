import '../../../core/constants/app_constants.dart';

/// Use case untuk menghitung nilai Mapel (Fiqh & Bahasa Arab)
///
/// Formula:
/// nilai_akhir = round(0.4 * nilai_formatif + 0.6 * nilai_sumatif)
class CalculateMapelScore {
  double execute({
    required double nilaiFormatif,
    required double nilaiSumatif,
  }) {
    // Validasi input
    if (nilaiFormatif < 0 || nilaiFormatif > 100) {
      throw ArgumentError('Nilai formatif harus antara 0-100');
    }

    if (nilaiSumatif < 0 || nilaiSumatif > 100) {
      throw ArgumentError('Nilai sumatif harus antara 0-100');
    }

    // Hitung nilai akhir dengan bobot 40-60
    double nilaiAkhir =
        (AppConstants.weightFormatif * nilaiFormatif) +
        (AppConstants.weightSumatif * nilaiSumatif);

    // Round ke bilangan bulat terdekat
    return nilaiAkhir.roundToDouble();
  }
}
