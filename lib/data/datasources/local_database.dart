import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/constants/app_constants.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pesantren.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    // Table Santri
    await db.execute('''
      CREATE TABLE ${AppConstants.santriCollection} (
        id TEXT PRIMARY KEY,
        nis TEXT NOT NULL,
        nama TEXT NOT NULL,
        kamar TEXT NOT NULL,
        angkatan TEXT NOT NULL,
        photoUrl TEXT,
        waliId TEXT,
        createdAt INTEGER NOT NULL
      )
    ''');

    // Table Penilaian
    await db.execute('''
      CREATE TABLE ${AppConstants.penilaianCollection} (
        id TEXT PRIMARY KEY,
        santriId TEXT NOT NULL,
        semester TEXT NOT NULL,
        tahunAjaran TEXT NOT NULL,
        targetAyat INTEGER NOT NULL,
        setoranAyat INTEGER NOT NULL,
        nilaiTajwid REAL NOT NULL,
        fiqhFormatif REAL NOT NULL,
        fiqhSumatif REAL NOT NULL,
        arabicFormatif REAL NOT NULL,
        arabicSumatif REAL NOT NULL,
        skorDisiplin INTEGER NOT NULL,
        skorAdab INTEGER NOT NULL,
        skorKebersihan INTEGER NOT NULL,
        skorKerjasama INTEGER NOT NULL,
        hadir INTEGER NOT NULL,
        sakit INTEGER NOT NULL,
        izin INTEGER NOT NULL,
        alpa INTEGER NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        FOREIGN KEY (santriId) REFERENCES ${AppConstants.santriCollection} (id)
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
