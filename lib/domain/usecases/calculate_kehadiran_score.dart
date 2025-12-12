/// Use case untuk menghitung persentase Kehadiran
///
/// Formula:
/// kehadiran = (hadir / (hadir + sakit + izin + alpa)) * 100
class CalculateKehadiranScore {
  double execute({
    required int hadir,
    required int sakit,
    required int izin,
    required int alpa,
  }) {
    // Validasi input - tidak boleh negatif
    if (hadir < 0 || sakit < 0 || izin < 0 || alpa < 0) {
      throw ArgumentError('Jumlah kehadiran tidak boleh negatif');
    }

    // Hitung total hari
    int totalHari = hadir + sakit + izin + alpa;

    // Jika tidak ada data kehadiran, return 0
    if (totalHari == 0) {
      return 0;
    }

    // Hitung persentase kehadiran
    double persentase = (hadir / totalHari) * 100;

    // Round ke bilangan bulat terdekat
    return persentase.roundToDouble();
  }
}
