import 'dart:math';
import '../../../core/constants/app_constants.dart';

/// Use case untuk menghitung nilai Tahfidz
///
/// Formula:
/// 1. capaian = (setoran_ayat / target_ayat) * 100 (max 100)
/// 2. nilai_akhir = round(0.5 * capaian + 0.5 * nilai_tajwid)
class CalculateTahfidzScore {
  double execute({
    required int targetAyat,
    required int setoranAyat,
    required double nilaiTajwid,
  }) {
    // Validasi input
    if (targetAyat <= 0) {
      throw ArgumentError('Target ayat harus lebih dari 0');
    }

    if (setoranAyat < 0) {
      throw ArgumentError('Setoran ayat tidak boleh negatif');
    }

    if (nilaiTajwid < 0 || nilaiTajwid > 100) {
      throw ArgumentError('Nilai tajwid harus antara 0-100');
    }

    // Hitung capaian (maksimal 100)
    double capaian = min((setoranAyat / targetAyat) * 100, 100);

    // Hitung nilai akhir dengan bobot 50-50
    double nilaiAkhir =
        (AppConstants.weightCapaian * capaian) +
        (AppConstants.weightTajwid * nilaiTajwid);

    // Round ke bilangan bulat terdekat
    return nilaiAkhir.roundToDouble();
  }
}
