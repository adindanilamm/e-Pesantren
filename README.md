# 🕌 SPASANTREN - Sistem Penilaian Akademik Santri

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)

**Aplikasi Manajemen Penilaian Santri untuk Pesantren Modern**

[🚀 Getting Started](#-getting-started) • [📖 Dokumentasi](#-arsitektur) • [🧪 Testing](#-cara-uji) • [📜 Lisensi](#-lisensi)

</div>

---

## 📋 Deskripsi

**SPASANTREN** adalah aplikasi mobile berbasis Flutter yang dirancang untuk memudahkan pengelolaan penilaian akademik di lingkungan pesantren. Aplikasi ini memungkinkan:

- 👨‍💼 **Admin** untuk mengelola data santri, ustadz, wali santri, dan akun admin lainnya
- 👨‍🏫 **Ustadz** untuk menginput nilai berdasarkan mata pelajaran yang diampu
- 👨‍👩‍👦 **Wali Santri** untuk memantau perkembangan akademik putra/putri mereka

---

## ✨ Fitur Utama

### 🔐 Multi-Role Authentication
| Role | Kemampuan |
|------|-----------|
| **Admin** | Kelola santri, ustadz, wali • CRUD pengguna • Tambah admin baru • Kelola Wali Kelas |
| **Ustadz** | Input nilai sesuai mapel yang diampu • Lihat statistik mengajar dinamis |
| **Wali Santri** | Lihat nilai anak • Download rapor PDF |

### 🛡️ Keamanan Login
- **CAPTCHA Simulasi** - Verifikasi "I'm not a robot" sebelum login

### 👨‍🏫 Fitur Wali Kelas
- Ustadz dapat ditugaskan sebagai **Wali Kelas** untuk kamar tertentu
- Saat menambah Santri, pilihan Wali Kelas otomatis mengisi field Kamar
- Admin dapat melihat daftar santri yang diwalikan oleh setiap Ustadz

### 📊 Modul Penilaian
- **Tahfidz** - Penilaian hafalan Al-Qur'an (Surah, Juz, Nilai)
- **Mata Pelajaran** - Fiqih, Hadis, Bahasa Arab, Akhlak
- **Akhlak** - Kejujuran, Kedisiplinan, Kebersihan, Sopan Santun
- **Kehadiran** - Tracking kehadiran harian dengan rekap otomatis

### 📱 User Experience
- 🎨 Modern UI dengan tema biru konsisten
- 📄 Export Rapor ke PDF
- 🔄 Real-time sync dengan Firebase
- 📊 Visualisasi data dengan Pie Chart
- ⏰ Time Picker untuk input jam mengajar (tanpa ketik manual)

---

## 🏗 Arsitektur

Aplikasi ini menggunakan **Clean Architecture** dengan pattern:

```
lib/
├── 📁 core/
│   ├── constants/        # App-wide constants
│   └── theme/            # Theme configuration
│
├── 📁 data/
│   ├── models/           # Data models (Firestore mapping)
│   └── repositories/     # Repository implementations
│
├── 📁 domain/
│   ├── entities/         # Business entities
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Business logic
│
└── 📁 presentation/
    ├── providers/        # Riverpod state management
    ├── screens/          # UI screens by role
    │   ├── admin/        # Admin screens
    │   ├── ustadz/       # Ustadz screens
    │   └── wali/         # Wali Santri screens
    └── widgets/          # Reusable widgets
```

### 🔧 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter 3.x** | Cross-platform UI framework |
| **Riverpod** | State management |
| **Firebase Auth** | Authentication |
| **Cloud Firestore** | NoSQL database |
| **PDF/Printing** | Report generation |
| **FL Chart** | Data visualization |

### 📊 Database Schema (Firestore)

```
📦 Firestore
├── 📁 users/              # All user accounts
│   ├── uid, name, email, role
│   ├── mataPelajaran[]    # For Ustadz (array of subjects)
│   ├── jamMengajar        # For Ustadz (e.g., "09:00-15:00")
│   ├── isWaliKelas        # Boolean
│   ├── waliKelasKamar     # Kamar yang diwalikan
│   └── santriIds[]        # For Wali Santri
│
├── 📁 santri/             # Student data
│   ├── id, nis, nama, kamar, angkatan
│   ├── waliKelasId        # Link to Ustadz
│   └── waliKelasName
│
├── 📁 penilaian_tahfidz/  # Tahfidz grades
├── 📁 penilaian_mapel/    # Subject grades
├── 📁 penilaian_akhlak/   # Behavior grades
└── 📁 rekap_kehadiran/    # Attendance summary
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Firebase project configured
- Android Studio / VS Code

### Installation

```bash
# 1. Clone repository
git clone <repository-url>
cd UASPROGREMMINGMOBILE

# 2. Install dependencies
flutter pub get

# 3. Configure Firebase
# - Pastikan file google-services.json (Android) ada di android/app/
# - Pastikan file GoogleService-Info.plist (iOS) ada di ios/Runner/

# 4. Run the app
flutter run
```

### Firebase Configuration

1. Buat project di [Firebase Console](https://console.firebase.google.com)
2. Enable **Authentication** (Email/Password)
3. Enable **Cloud Firestore**
4. Download dan tempatkan file konfigurasi:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

---

## 🧪 Cara Uji

### Static Analysis
```bash
flutter analyze
```

### Unit Tests
```bash
flutter test
```

### Manual Testing Flow

#### 1️⃣ Login sebagai Admin
```
Email: admin@pesantren.id
Password: [sesuai yang dibuat]
```
- ✅ Tambah data Santri (dengan pilihan Wali Kelas)
- ✅ Buat akun Ustadz dengan mapel dan jam mengajar (via Time Picker)
- ✅ Buat akun Wali Santri dan link ke NIS santri
- ✅ Buat akun Admin baru (via menu Profil)
- ✅ Edit/Hapus pengguna di menu "Pengguna"
- ✅ Verifikasi CAPTCHA saat login

#### 2️⃣ Login sebagai Ustadz
```
Email: ustadz@pesantren.id
```
- ✅ Lihat statistik mengajar dinamis:
  - Total Kelas = jumlah mata pelajaran yang diampu
  - Total Santri = jumlah santri dari Firestore
  - Jam Mengajar = dari data profil
- ✅ Pilih santri dan input nilai

#### 3️⃣ Login sebagai Wali Santri
```
Email: wali@pesantren.id
```
- ✅ Lihat profil anak
- ✅ Lihat nilai yang sudah diinput
- ✅ Export rapor PDF

---

## 📝 Asumsi & Catatan Penting

### Asumsi Bisnis
1. **Satu Wali = Satu atau Lebih Santri** - Wali bisa memiliki beberapa anak
2. **Mata Pelajaran Tetap** - Tahfidz, Fiqih, Hadis, Akhlak, Bahasa Arab
3. **Penilaian Akhlak** - Menggunakan skala 1-4 (Kurang-Sangat Baik)
4. **Wali Kelas** - Ustadz dapat ditugaskan sebagai wali untuk satu kamar

### Catatan Teknis
1. **Secondary App Pattern** - Digunakan saat Admin membuat akun baru agar tidak ter-logout
2. **Offline Mode** - Tidak didukung secara penuh, membutuhkan koneksi internet
3. **Role-Based Access** - Dihandle di app level

### Known Limitations
- `withOpacity` deprecation warnings (Flutter 3.27+) - cosmetic only
- PDF export membutuhkan font default

---

## 📂 Struktur File Penting

| File | Deskripsi |
|------|-----------|
| `lib/main.dart` | Entry point dengan routing berdasarkan role |
| `lib/presentation/screens/admin/admin_dashboard.dart` | Dashboard Admin dengan navigasi |
| `lib/presentation/screens/admin/create_user_screen.dart` | Form buat Ustadz/Wali dengan Time Picker |
| `lib/presentation/screens/admin/add_santri_screen.dart` | Form tambah santri dengan pilihan Wali Kelas |
| `lib/presentation/screens/ustadz/ustadz_dashboard.dart` | Dashboard Ustadz dengan statistik dinamis |
| `lib/presentation/screens/wali/rapor_screen.dart` | Rapor dengan nilai dinamis |
| `lib/presentation/screens/login_screen.dart` | Login dengan CAPTCHA simulasi |
| `lib/data/models/user_model.dart` | Model user dengan jamMengajar |
| `lib/presentation/providers/nav_provider.dart` | State navigasi bersama |

---

## 👥 Kontributor

- **Developer** - UAS PEMROGRAMAN MOBILE

---

## 📜 Lisensi

```
MIT License - Feel free to use and modify
```

---

<div align="center">

**Made with ❤️ using Flutter & Firebase**

</div>
