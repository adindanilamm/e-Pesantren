import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/primary_button.dart';

class RaporScreen extends StatefulWidget {
  const RaporScreen({super.key});

  @override
  State<RaporScreen> createState() => _RaporScreenState();
}

class _RaporScreenState extends State<RaporScreen> {
  Map<String, dynamic>? _raporData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRaporData();
  }

  Future<void> _loadRaporData() async {
    try {
      final data = await _fetchRaporData();
      setState(() {
        _raporData = data;
        _isLoading = false;
        if (data.containsKey('error')) {
          _error = data['error'];
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  Future<Map<String, dynamic>> _fetchRaporData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return {'error': 'User not logged in'};
      }

      // Get user data to find santriId
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final userData = userDoc.data();
      // Support both santriId and santriIds
      String santriId = userData?['santriId'] ?? '';
      if (santriId.isEmpty && userData?['santriIds'] != null) {
        final santriIds = userData!['santriIds'] as List<dynamic>;
        if (santriIds.isNotEmpty) {
          santriId = santriIds.first.toString();
        }
      }

      if (santriId.isEmpty) {
        return {'error': 'Santri ID not found'};
      }

      // Get santri data
      final santriDoc = await FirebaseFirestore.instance
          .collection('santri')
          .doc(santriId)
          .get();

      final santriData = santriDoc.data();

      // Fetch all penilaian data
      final tahfidzDocs = await FirebaseFirestore.instance
          .collection('penilaian_tahfidz')
          .where('santriId', isEqualTo: santriId)
          .get();

      final mapelDocs = await FirebaseFirestore.instance
          .collection('penilaian_mapel')
          .where('santriId', isEqualTo: santriId)
          .get();

      final akhlakDocs = await FirebaseFirestore.instance
          .collection('penilaian_akhlak')
          .where('santriId', isEqualTo: santriId)
          .get();

      final kehadiranDocs = await FirebaseFirestore.instance
          .collection('rekap_kehadiran')
          .where('santriId', isEqualTo: santriId)
          .get();

      // Build scores map - only include subjects that have data
      Map<String, Map<String, dynamic>> scores = {};

      // Calculate Tahfidz average
      if (tahfidzDocs.docs.isNotEmpty) {
        double total = 0;
        for (var doc in tahfidzDocs.docs) {
          total += (doc.data()['nilaiHafalan'] ?? 0).toDouble();
        }
        final avg = total / tahfidzDocs.docs.length;
        scores['Tahfidz'] = {
          'nilai': avg,
          'icon': 'menu_book',
          'count': tahfidzDocs.docs.length,
        };
      }

      // Calculate per-subject averages for Mapel
      Map<String, List<double>> mapelValues = {};
      for (var doc in mapelDocs.docs) {
        final data = doc.data();
        final mapel = data['mapel'] ?? data['aspek'] ?? 'Unknown';
        final nilai = (data['nilai'] ?? 0).toDouble();
        if (!mapelValues.containsKey(mapel)) {
          mapelValues[mapel] = [];
        }
        mapelValues[mapel]!.add(nilai);
      }

      for (var entry in mapelValues.entries) {
        final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
        String iconName = 'book';
        if (entry.key.toLowerCase().contains('fiqih') ||
            entry.key.toLowerCase().contains('fiqh')) {
          iconName = 'mosque';
        } else if (entry.key.toLowerCase().contains('arab')) {
          iconName = 'translate';
        } else if (entry.key.toLowerCase().contains('hadis')) {
          iconName = 'auto_stories';
        }
        scores[entry.key] = {
          'nilai': avg,
          'icon': iconName,
          'count': entry.value.length,
        };
      }

      // Calculate Akhlak average
      if (akhlakDocs.docs.isNotEmpty) {
        double total = 0;
        for (var doc in akhlakDocs.docs) {
          final data = doc.data();
          final avg =
              ((data['kejujuran'] ?? 0) +
                  (data['kedisiplinan'] ?? 0) +
                  (data['kebersihan'] ?? 0) +
                  (data['sopanSantun'] ?? 0)) /
              4.0;
          total += avg * 25; // Convert 1-4 scale to 0-100
        }
        final akhlakAvg = total / akhlakDocs.docs.length;
        scores['Akhlak'] = {
          'nilai': akhlakAvg,
          'icon': 'favorite',
          'count': akhlakDocs.docs.length,
        };
      }

      // Calculate Kehadiran percentage
      if (kehadiranDocs.docs.isNotEmpty) {
        int totalHadir = 0;
        int totalHari = 0;
        for (var doc in kehadiranDocs.docs) {
          totalHadir += (doc.data()['hadir'] ?? 0) as int;
          totalHari += (doc.data()['totalHari'] ?? 0) as int;
        }
        if (totalHari > 0) {
          final kehadiranPersen = (totalHadir / totalHari) * 100;
          scores['Kehadiran'] = {
            'nilai': kehadiranPersen,
            'icon': 'calendar_today',
            'count': kehadiranDocs.docs.length,
          };
        }
      }

      // Calculate overall average
      double nilaiAkhir = 0;
      if (scores.isNotEmpty) {
        double sum = 0;
        for (var score in scores.values) {
          sum += score['nilai'] as double;
        }
        nilaiAkhir = sum / scores.length;
      }

      return {
        'nama': santriData?['nama'] ?? 'N/A',
        'nis': santriData?['nis'] ?? 'N/A',
        'kamar': santriData?['kamar'] ?? 'N/A',
        'angkatan': santriData?['angkatan']?.toString() ?? 'N/A',
        'scores': scores,
        'nilaiAkhir': nilaiAkhir,
        'hasData': scores.isNotEmpty,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  String _getPredikat(double nilai) {
    if (nilai >= 90) return 'A (Sangat Baik)';
    if (nilai >= 80) return 'B (Baik)';
    if (nilai >= 70) return 'C (Cukup)';
    if (nilai >= 60) return 'D (Kurang)';
    return 'E (Sangat Kurang)';
  }

  String _getPredikatShort(double nilai) {
    if (nilai >= 90) return 'A';
    if (nilai >= 80) return 'B';
    if (nilai >= 70) return 'C';
    if (nilai >= 60) return 'D';
    return 'E';
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'menu_book':
        return Icons.menu_book;
      case 'mosque':
        return Icons.mosque;
      case 'translate':
        return Icons.translate;
      case 'auto_stories':
        return Icons.auto_stories;
      case 'favorite':
        return Icons.favorite;
      case 'calendar_today':
        return Icons.calendar_today;
      default:
        return Icons.book;
    }
  }

  Future<void> _generatePdf(BuildContext context) async {
    if (_raporData == null || _raporData!.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data tidak tersedia untuk dicetak')),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final data = _raporData!;
      final scores = data['scores'] as Map<String, Map<String, dynamic>>;

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#2563EB'),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'LAPORAN HASIL BELAJAR SANTRI',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Tahun Ajaran 2024/2025',
                        style: const pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),

                // Student Info
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Nama: ${data['nama']}',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text('NIS: ${data['nis']}'),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Kamar: ${data['kamar']}'),
                          pw.SizedBox(height: 4),
                          pw.Text('Angkatan: ${data['angkatan']}'),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),

                // Nilai Table
                pw.Text(
                  'NILAI PENILAIAN',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),

                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    // Header
                    pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#F1F5F9'),
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'Aspek Penilaian',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'Nilai',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'Predikat',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    // Dynamic rows based on actual data
                    ...scores.entries.map(
                      (entry) => _buildTableRow(
                        entry.key,
                        entry.value['nilai'] as double,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),

                // Final Score
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#DBEAFE'),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'NILAI AKHIR',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Rata-rata: ${data['nilaiAkhir'].toStringAsFixed(2)}',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Predikat: ${_getPredikat(data['nilaiAkhir'])}',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),

                pw.Spacer(),

                // Footer
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text('Wali Kelas'),
                        pw.SizedBox(height: 50),
                        pw.Container(
                          width: 150,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(color: PdfColors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      if (mounted) {
        Navigator.pop(context); // Close loading
      }

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading if still open
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
      }
    }
  }

  pw.TableRow _buildTableRow(String label, double nilai) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(12), child: pw.Text(label)),
        pw.Padding(
          padding: const pw.EdgeInsets.all(12),
          child: pw.Text(
            nilai.toStringAsFixed(1),
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(12),
          child: pw.Text(_getPredikat(nilai)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        title: const Text('Rapor Santri'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _generatePdf(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Color(0xFFEF4444),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terjadi Kesalahan',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            )
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final data = _raporData!;
    final scores = data['scores'] as Map<String, Map<String, dynamic>>? ?? {};
    final nilaiAkhir = data['nilaiAkhir'] as double? ?? 0;
    final hasData = data['hasData'] as bool? ?? false;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Nilai Rata-Rata',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  hasData ? nilaiAkhir.toStringAsFixed(1) : '-',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hasData)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Predikat: ${_getPredikat(nilaiAkhir)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Info if no data
          if (!hasData)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFBBF24)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFFD97706)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Belum ada nilai yang diinput oleh Ustadz. Silakan hubungi pihak pesantren untuk informasi lebih lanjut.',
                      style: TextStyle(color: Color(0xFF92400E)),
                    ),
                  ),
                ],
              ),
            ),

          // Dynamic score cards - only show subjects with actual data
          if (hasData) ...[
            const SizedBox(height: 8),
            ...scores.entries.map(
              (entry) => _buildScoreCard(
                context,
                entry.key,
                entry.value['nilai'].toStringAsFixed(1),
                _getPredikatShort(entry.value['nilai'] as double),
                _getIcon(entry.value['icon'] as String),
              ),
            ),
          ],

          const SizedBox(height: 32),
          if (hasData)
            PrimaryButton(
              text: 'EXPORT PDF',
              icon: Icons.picture_as_pdf,
              onPressed: () => _generatePdf(context),
            ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(
    BuildContext context,
    String mapel,
    String nilai,
    String predikat,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              mapel,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                nilai,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2563EB),
                ),
              ),
              Text(
                'Predikat $predikat',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
