import '../../../core/constants/app_constants.dart';

/// Use case untuk menghitung Nilai Rapor Akhir
///
/// Formula:
/// Nilai Akhir = round(
///   30% * Tahfidz +
///   20% * Fiqh +
///   20% * Arabic +
///   20% * Akhlak +
///   10% * Kehadiran
/// )
///
/// Predikat:
/// A: 85-100
/// B: 75-84
/// C: 65-74
/// D: <65
class CalculateRaporFinal {
  Map<String, dynamic> execute({
    required double nilaiTahfidz,
    required double nilaiFiqh,
    required double nilaiArabic,
    required double nilaiAkhlak,
    required double nilaiKehadiran,
  }) {
    // Validasi input - semua nilai harus 0-100
    final scores = {
      'Tahfidz': nilaiTahfidz,
      'Fiqh': nilaiFiqh,
      'Arabic': nilaiArabic,
      'Akhlak': nilaiAkhlak,
      'Kehadiran': nilaiKehadiran,
    };

    for (var entry in scores.entries) {
      if (entry.value < 0 || entry.value > 100) {
        throw ArgumentError('Nilai ${entry.key} harus antara 0-100');
      }
    }

    // Hitung nilai akhir dengan bobot
    double nilaiAkhir =
        (AppConstants.weightTahfidz * nilaiTahfidz) +
        (AppConstants.weightFiqh * nilaiFiqh) +
        (AppConstants.weightArabic * nilaiArabic) +
        (AppConstants.weightAkhlak * nilaiAkhlak) +
        (AppConstants.weightKehadiran * nilaiKehadiran);

    // Round ke bilangan bulat terdekat
    nilaiAkhir = nilaiAkhir.roundToDouble();

    // Tentukan predikat
    String predikat;
    if (nilaiAkhir >= AppConstants.predikatA) {
      predikat = 'A';
    } else if (nilaiAkhir >= AppConstants.predikatB) {
      predikat = 'B';
    } else if (nilaiAkhir >= AppConstants.predikatC) {
      predikat = 'C';
    } else {
      predikat = 'D';
    }

    return {'nilaiAkhir': nilaiAkhir, 'predikat': predikat};
  }
}
