import 'package:equatable/equatable.dart';

/// Nested class for Tahfidz assessment
class TahfidzScore extends Equatable {
  final int targetAyat;
  final int setoranAyat;
  final double nilaiTajwid;
  final double nilaiAkhir;

  const TahfidzScore({
    required this.targetAyat,
    required this.setoranAyat,
    required this.nilaiTajwid,
    required this.nilaiAkhir,
  });

  @override
  List<Object?> get props => [targetAyat, setoranAyat, nilaiTajwid, nilaiAkhir];

  TahfidzScore copyWith({
    int? targetAyat,
    int? setoranAyat,
    double? nilaiTajwid,
    double? nilaiAkhir,
  }) {
    return TahfidzScore(
      targetAyat: targetAyat ?? this.targetAyat,
      setoranAyat: setoranAyat ?? this.setoranAyat,
      nilaiTajwid: nilaiTajwid ?? this.nilaiTajwid,
      nilaiAkhir: nilaiAkhir ?? this.nilaiAkhir,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetAyat': targetAyat,
      'setoranAyat': setoranAyat,
      'nilaiTajwid': nilaiTajwid,
      'nilaiAkhir': nilaiAkhir,
    };
  }

  factory TahfidzScore.fromJson(Map<String, dynamic> json) {
    return TahfidzScore(
      targetAyat: json['targetAyat'] as int,
      setoranAyat: json['setoranAyat'] as int,
      nilaiTajwid: (json['nilaiTajwid'] as num).toDouble(),
      nilaiAkhir: (json['nilaiAkhir'] as num).toDouble(),
    );
  }
}

/// Nested class for academic subject assessment (Fiqh, Bahasa Arab)
class AcademicScore extends Equatable {
  final double formatif;
  final double sumatif;
  final double nilaiAkhir;

  const AcademicScore({
    required this.formatif,
    required this.sumatif,
    required this.nilaiAkhir,
  });

  @override
  List<Object?> get props => [formatif, sumatif, nilaiAkhir];

  AcademicScore copyWith({
    double? formatif,
    double? sumatif,
    double? nilaiAkhir,
  }) {
    return AcademicScore(
      formatif: formatif ?? this.formatif,
      sumatif: sumatif ?? this.sumatif,
      nilaiAkhir: nilaiAkhir ?? this.nilaiAkhir,
    );
  }

  Map<String, dynamic> toJson() {
    return {'formatif': formatif, 'sumatif': sumatif, 'nilaiAkhir': nilaiAkhir};
  }

  factory AcademicScore.fromJson(Map<String, dynamic> json) {
    return AcademicScore(
      formatif: (json['formatif'] as num).toDouble(),
      sumatif: (json['sumatif'] as num).toDouble(),
      nilaiAkhir: (json['nilaiAkhir'] as num).toDouble(),
    );
  }
}

/// Nested class for character assessment
class AkhlakScore extends Equatable {
  final int skorDisiplin;
  final int skorAdab;
  final int skorKebersihan;
  final int skorKerjasama;
  final double rataRata;
  final double nilaiAkhir;

  const AkhlakScore({
    required this.skorDisiplin,
    required this.skorAdab,
    required this.skorKebersihan,
    required this.skorKerjasama,
    required this.rataRata,
    required this.nilaiAkhir,
  });

  @override
  List<Object?> get props => [
    skorDisiplin,
    skorAdab,
    skorKebersihan,
    skorKerjasama,
    rataRata,
    nilaiAkhir,
  ];

  AkhlakScore copyWith({
    int? skorDisiplin,
    int? skorAdab,
    int? skorKebersihan,
    int? skorKerjasama,
    double? rataRata,
    double? nilaiAkhir,
  }) {
    return AkhlakScore(
      skorDisiplin: skorDisiplin ?? this.skorDisiplin,
      skorAdab: skorAdab ?? this.skorAdab,
      skorKebersihan: skorKebersihan ?? this.skorKebersihan,
      skorKerjasama: skorKerjasama ?? this.skorKerjasama,
      rataRata: rataRata ?? this.rataRata,
      nilaiAkhir: nilaiAkhir ?? this.nilaiAkhir,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skorDisiplin': skorDisiplin,
      'skorAdab': skorAdab,
      'skorKebersihan': skorKebersihan,
      'skorKerjasama': skorKerjasama,
      'rataRata': rataRata,
      'nilaiAkhir': nilaiAkhir,
    };
  }

  factory AkhlakScore.fromJson(Map<String, dynamic> json) {
    return AkhlakScore(
      skorDisiplin: json['skorDisiplin'] as int,
      skorAdab: json['skorAdab'] as int,
      skorKebersihan: json['skorKebersihan'] as int,
      skorKerjasama: json['skorKerjasama'] as int,
      rataRata: (json['rataRata'] as num).toDouble(),
      nilaiAkhir: (json['nilaiAkhir'] as num).toDouble(),
    );
  }
}

/// Entity for assessment scores (EXCLUDING attendance)
class PenilaianEntity extends Equatable {
  final String id;
  final String santriId;
  final String tahunAjaran;
  final String semester;
  final TahfidzScore tahfidz;
  final AcademicScore fiqh;
  final AcademicScore bahasaArab;
  final AkhlakScore akhlak;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;

  const PenilaianEntity({
    required this.id,
    required this.santriId,
    required this.tahunAjaran,
    required this.semester,
    required this.tahfidz,
    required this.fiqh,
    required this.bahasaArab,
    required this.akhlak,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  @override
  List<Object?> get props => [
    id,
    santriId,
    tahunAjaran,
    semester,
    tahfidz,
    fiqh,
    bahasaArab,
    akhlak,
    createdAt,
    updatedAt,
    createdBy,
    updatedBy,
  ];

  PenilaianEntity copyWith({
    String? id,
    String? santriId,
    String? tahunAjaran,
    String? semester,
    TahfidzScore? tahfidz,
    AcademicScore? fiqh,
    AcademicScore? bahasaArab,
    AkhlakScore? akhlak,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return PenilaianEntity(
      id: id ?? this.id,
      santriId: santriId ?? this.santriId,
      tahunAjaran: tahunAjaran ?? this.tahunAjaran,
      semester: semester ?? this.semester,
      tahfidz: tahfidz ?? this.tahfidz,
      fiqh: fiqh ?? this.fiqh,
      bahasaArab: bahasaArab ?? this.bahasaArab,
      akhlak: akhlak ?? this.akhlak,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}
