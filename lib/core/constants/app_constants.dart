// App Constants
class AppConstants {
  // App Info
  static const String appName = 'e-Penilaian Santri';
  static const String appVersion = '1.0.0';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String santriCollection = 'santri';
  static const String penilaianCollection = 'penilaian';
  static const String kelasCollection = 'kelas';

  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleUstadz = 'ustadz';
  static const String roleWali = 'wali_santri';

  // Calculation Weights for Rapor
  static const double weightTahfidz = 0.30;
  static const double weightFiqh = 0.20;
  static const double weightArabic = 0.20;
  static const double weightAkhlak = 0.20;
  static const double weightKehadiran = 0.10;

  // Tahfidz Calculation Weights
  static const double weightCapaian = 0.5;
  static const double weightTajwid = 0.5;

  // Mapel (Fiqh & Arabic) Weights
  static const double weightFormatif = 0.4;
  static const double weightSumatif = 0.6;

  // Predikat Thresholds
  static const double predikatA = 85;
  static const double predikatB = 75;
  static const double predikatC = 65;

  // Akhlak Scale
  static const int akhlakMinScore = 1;
  static const int akhlakMaxScore = 4;
  static const int akhlakIndicatorCount = 4;
}
