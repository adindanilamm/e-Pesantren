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

- 👨‍💼 **Admin** untuk mengelola data santri, ustadz, dan wali santri
- 👨‍🏫 **Ustadz** untuk menginput nilai berdasarkan mata pelajaran yang diampu
- 👨‍👩‍👦 **Wali Santri** untuk memantau perkembangan akademik putra/putri mereka

---

## ✨ Fitur Utama

### 🔐 Multi-Role Authentication
| Role | Kemampuan |
|------|-----------|
| **Admin** | Kelola santri, ustadz, wali • CRUD pengguna • Lihat semua data |
| **Ustadz** | Input nilai sesuai mapel yang diampu • Lihat daftar santri |
| **Wali Santri** | Lihat nilai anak • Download rapor PDF |

### 📊 Modul Penilaian
- **Tahfidz** - Penilaian hafalan Al-Qur'an (Surah, Juz, Nilai)
- **Mata Pelajaran** - Fiqih, Hadis, Bahasa Arab
- **Akhlak** - Kejujuran, Kedisiplinan, Kebersihan, Sopan Santun
- **Kehadiran** - Tracking kehadiran harian dengan rekap otomatis

### 📱 User Experience
- 🎨 Modern UI dengan tema biru konsisten
- 📄 Export Rapor ke PDF
- 🔄 Real-time sync dengan Firebase
- 📊 Visualisasi data dengan Pie Chart

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
│   └── mataPelajaran[]    # For Ustadz
│   └── santriIds[]        # For Wali
│
├── 📁 santri/             # Student data
│   └── id, nis, nama, kamar, angkatan
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
- ✅ Tambah data Santri
- ✅ Buat akun Ustadz dengan mapel tertentu (misal: Tahfidz saja)
- ✅ Buat akun Wali Santri dan link ke NIS santri
- ✅ Edit/Hapus pengguna di menu "Pengguna"

#### 2️⃣ Login sebagai Ustadz
```
Email: ustadz@pesantren.id
```
- ✅ Pilih santri dari daftar
- ✅ Input nilai sesuai mapel yang diampu
- ✅ Verifikasi hanya tab mapel yang relevan muncul

#### 3️⃣ Login sebagai Wali Santri
```
Email: wali@pesantren.id
```
- ✅ Lihat profil anak
- ✅ Lihat nilai yang sudah diinput (hanya yang ada datanya)
- ✅ Export rapor PDF

---

## 📝 Asumsi & Catatan Penting

### Asumsi Bisnis
1. **Satu Wali = Satu atau Lebih Santri** - Wali bisa memiliki beberapa anak
2. **Mata Pelajaran Tetap** - Tahfidz, Fiqih, Hadis, Bahasa Arab (dapat diperluas)
3. **Penilaian Akhlak** - Menggunakan skala 1-4 (Kurang-Sangat Baik)
4. **Semester/Tahun Ajaran** - Saat ini hardcode "2024/2025"

### Catatan Teknis
1. **Delete User** - Hanya menghapus dari Firestore, tidak dari Firebase Auth (membutuhkan Admin SDK/Cloud Function)
2. **Offline Mode** - Tidak didukung secara penuh, membutuhkan koneksi internet
3. **Role-Based Access** - Dihandle di app level, bukan Firestore Rules (production harus ditambahkan)

### Known Limitations
- `withOpacity` deprecation warnings (Flutter 3.27+) - cosmetic only
- PDF export membutuhkan font default (tidak support custom font)

---

## 📂 Struktur File Penting

| File | Deskripsi |
|------|-----------|
| `lib/main.dart` | Entry point dengan routing berdasarkan role |
| `lib/presentation/screens/admin/admin_dashboard.dart` | Dashboard Admin dengan navigasi |
| `lib/presentation/screens/ustadz/input_penilaian_screen.dart` | Input nilai dengan dynamic tabs |
| `lib/presentation/screens/wali/rapor_screen.dart` | Rapor dengan nilai dinamis |
| `lib/data/models/user_model.dart` | Model user dengan fallback compatibiliy |

---

## 🎨 Screenshots

<div align="center">

| Admin Dashboard | User Management | Wali Rapor |
|:---:|:---:|:---:|
| Data Santri | Kelola Ustadz/Wali | Lihat Nilai |

</div>

---

## 👥 Kontributor

- **Developer** - UAS PEMROGRAMAN MOBILE NGETES DARI GEMINI

---

## 📜 Lisensi

```
MIT License - Feel free to use and modify
```

---

<div align="center">

**Made with ❤️ using Flutter & Firebase**

</div>
