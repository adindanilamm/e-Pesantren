import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/santri_entity.dart';
import '../../../domain/entities/penilaian_entity.dart';
import '../../providers/penilaian_provider.dart';
import '../../widgets/modern_text_field.dart';
import '../../widgets/primary_button.dart';

class InputNilaiScreen extends ConsumerStatefulWidget {
  final SantriEntity santri;

  const InputNilaiScreen({super.key, required this.santri});

  @override
  ConsumerState<InputNilaiScreen> createState() => _InputNilaiScreenState();
}

class _InputNilaiScreenState extends ConsumerState<InputNilaiScreen> {
  final _formKey = GlobalKey<FormState>();

  // Tahfidz Controllers
  final _targetAyatCtrl = TextEditingController();
  final _setoranAyatCtrl = TextEditingController();
  final _nilaiTajwidCtrl = TextEditingController();

  // Fiqh Controllers
  final _fiqhFormatifCtrl = TextEditingController();
  final _fiqhSumatifCtrl = TextEditingController();

  // Bahasa Arab Controllers
  final _arabicFormatifCtrl = TextEditingController();
  final _arabicSumatifCtrl = TextEditingController();

  // Akhlak Sliders (1-4 scale)
  double _skorDisiplin = 3;
  double _skorAdab = 3;
  double _skorKebersihan = 3;
  double _skorKerjasama = 3;

  @override
  void dispose() {
    _targetAyatCtrl.dispose();
    _setoranAyatCtrl.dispose();
    _nilaiTajwidCtrl.dispose();
    _fiqhFormatifCtrl.dispose();
    _fiqhSumatifCtrl.dispose();
    _arabicFormatifCtrl.dispose();
    _arabicSumatifCtrl.dispose();
    super.dispose();
  }

  // Calculate Tahfidz final score
  double _calculateTahfidzScore() {
    final target = int.tryParse(_targetAyatCtrl.text) ?? 1;
    final setoran = int.tryParse(_setoranAyatCtrl.text) ?? 0;
    final tajwid = double.tryParse(_nilaiTajwidCtrl.text) ?? 0;

    return (setoran / target * 50) + (tajwid * 0.5);
  }

  // Calculate Academic final score (formatif 40% + sumatif 60%)
  double _calculateAcademicScore(double formatif, double sumatif) {
    return (formatif * 0.4) + (sumatif * 0.6);
  }

  // Calculate Akhlak final score
  double _calculateAkhlakScore() {
    final avg =
        (_skorDisiplin + _skorAdab + _skorKebersihan + _skorKerjasama) / 4;
    return (avg / 4) * 100; // Convert 1-4 scale to 0-100
  }

  void _savePenilaian() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // Parse input values
      final targetAyat = int.parse(_targetAyatCtrl.text);
      final setoranAyat = int.parse(_setoranAyatCtrl.text);
      final nilaiTajwid = double.parse(_nilaiTajwidCtrl.text);

      final fiqhFormatif = double.parse(_fiqhFormatifCtrl.text);
      final fiqhSumatif = double.parse(_fiqhSumatifCtrl.text);

      final arabicFormatif = double.parse(_arabicFormatifCtrl.text);
      final arabicSumatif = double.parse(_arabicSumatifCtrl.text);

      // Create nested score objects
      final tahfidzScore = TahfidzScore(
        targetAyat: targetAyat,
        setoranAyat: setoranAyat,
        nilaiTajwid: nilaiTajwid,
        nilaiAkhir: _calculateTahfidzScore(),
      );

      final fiqhScore = AcademicScore(
        formatif: fiqhFormatif,
        sumatif: fiqhSumatif,
        nilaiAkhir: _calculateAcademicScore(fiqhFormatif, fiqhSumatif),
      );

      final bahasaArabScore = AcademicScore(
        formatif: arabicFormatif,
        sumatif: arabicSumatif,
        nilaiAkhir: _calculateAcademicScore(arabicFormatif, arabicSumatif),
      );

      final akhlakAvg =
          (_skorDisiplin + _skorAdab + _skorKebersihan + _skorKerjasama) / 4;
      final akhlakScore = AkhlakScore(
        skorDisiplin: _skorDisiplin.round(),
        skorAdab: _skorAdab.round(),
        skorKebersihan: _skorKebersihan.round(),
        skorKerjasama: _skorKerjasama.round(),
        rataRata: akhlakAvg,
        nilaiAkhir: _calculateAkhlakScore(),
      );

      // Create composite document ID
      final tahunAjaran = '2024/2025'; // TODO: Make dynamic
      final semester = 'Ganjil'; // TODO: Make dynamic
      final docId = '${widget.santri.id}_${tahunAjaran}_$semester';

      final penilaian = PenilaianEntity(
        id: docId,
        santriId: widget.santri.id,
        tahunAjaran: tahunAjaran,
        semester: semester,
        tahfidz: tahfidzScore,
        fiqh: fiqhScore,
        bahasaArab: bahasaArabScore,
        akhlak: akhlakScore,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: currentUser.uid,
        updatedBy: currentUser.uid,
      );

      await ref
          .read(penilaianControllerProvider.notifier)
          .savePenilaian(penilaian);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nilai berhasil disimpan'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Nilai: ${widget.santri.nama}')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.primaryTeal),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Kehadiran diinput terpisah. Halaman ini hanya untuk nilai akademik dan akhlak.',
                        style: TextStyle(
                          color: AppTheme.primaryTeal.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tahfidz Section
              _buildSection('Tahfidz Al-Qur\'an', Icons.menu_book, [
                ModernTextField(
                  label: 'Target Ayat',
                  controller: _targetAyatCtrl,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                ModernTextField(
                  label: 'Setoran Ayat',
                  controller: _setoranAyatCtrl,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                ModernTextField(
                  label: 'Nilai Tajwid (0-100)',
                  controller: _nilaiTajwidCtrl,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
              ]),
              const SizedBox(height: 16),

              // Fiqh Section
              _buildSection('Fiqh', Icons.mosque, [
                ModernTextField(
                  label: 'Nilai Formatif (0-100)',
                  controller: _fiqhFormatifCtrl,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                ModernTextField(
                  label: 'Nilai Sumatif (0-100)',
                  controller: _fiqhSumatifCtrl,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
              ]),
              const SizedBox(height: 16),

              // Bahasa Arab Section
              _buildSection('Bahasa Arab', Icons.translate, [
                ModernTextField(
                  label: 'Nilai Formatif (0-100)',
                  controller: _arabicFormatifCtrl,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                ModernTextField(
                  label: 'Nilai Sumatif (0-100)',
                  controller: _arabicSumatifCtrl,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
              ]),
              const SizedBox(height: 16),

              // Akhlak Section
              _buildSection('Akhlak & Kepribadian', Icons.favorite, [
                _buildSlider(
                  'Disiplin',
                  _skorDisiplin,
                  (v) => setState(() => _skorDisiplin = v),
                ),
                _buildSlider(
                  'Adab pada Guru',
                  _skorAdab,
                  (v) => setState(() => _skorAdab = v),
                ),
                _buildSlider(
                  'Kebersihan',
                  _skorKebersihan,
                  (v) => setState(() => _skorKebersihan = v),
                ),
                _buildSlider(
                  'Kerja Sama',
                  _skorKerjasama,
                  (v) => setState(() => _skorKerjasama = v),
                ),
              ]),
              const SizedBox(height: 32),

              PrimaryButton(text: 'SIMPAN NILAI', onPressed: _savePenilaian),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.softShadow,
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: AppTheme.primaryTeal),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: children,
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    final labels = ['', 'Kurang', 'Cukup', 'Baik', 'Sangat Baik'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                labels[value.round()],
                style: const TextStyle(
                  color: AppTheme.primaryTeal,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 1,
          max: 4,
          divisions: 3,
          activeColor: AppTheme.primaryTeal,
          label: labels[value.round()],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
