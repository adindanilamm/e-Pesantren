import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/santri_entity.dart';

class InputTahfidzScreen extends StatefulWidget {
  final SantriEntity santri;

  const InputTahfidzScreen({super.key, required this.santri});

  @override
  State<InputTahfidzScreen> createState() => _InputTahfidzScreenState();
}

class _InputTahfidzScreenState extends State<InputTahfidzScreen> {
  final _formKey = GlobalKey<FormState>();
  final _surahController = TextEditingController();
  final _ayatController = TextEditingController();
  final _nilaiController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _surahController.dispose();
    _ayatController.dispose();
    _nilaiController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _savePenilaian() async {
    if (_formKey.currentState!.validate()) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) return;

        await FirebaseFirestore.instance.collection('penilaian_tahfidz').add({
          'santriId': widget.santri.id,
          'santriNama': widget.santri.nama,
          'minggu': Timestamp.fromDate(
            _selectedDate,
          ), // Used for weekly grouping
          'tanggal': Timestamp.fromDate(_selectedDate), // Used for sorting
          'surah': _surahController.text.trim(),
          'ayatSetor': _ayatController.text.trim(),
          'nilaiHafalan': double.parse(
            _nilaiController.text.trim(),
          ), // Changed from nilaiTajwid to match schema
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': currentUser.uid,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Penilaian Tahfidz berhasil disimpan'),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          _formKey.currentState!.reset();
          _surahController.clear();
          _ayatController.clear();
          _nilaiController.clear();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            const Row(
              children: [
                Icon(Icons.menu_book, color: Color(0xFF2563EB), size: 20),
                SizedBox(width: 8),
                Text(
                  'Penilaian Tahfidz',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tanggal (Minggu)
            const Text(
              'Tanggal Setor',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Surah
            _buildTextField(
              label: 'Surah',
              controller: _surahController,
              icon: Icons.book,
              hint: 'Nama Surah',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Surah tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Ayat Setor
            _buildTextField(
              label: 'Ayat Setor',
              controller: _ayatController,
              icon: Icons.format_list_numbered,
              hint: 'Jumlah ayat',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ayat setor tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Nilai Tajwid
            _buildTextField(
              label: 'Nilai Tajwid (0-100)',
              controller: _nilaiController,
              icon: Icons.star,
              hint: '0-100',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nilai tidak boleh kosong';
                }
                final nilai = double.tryParse(value);
                if (nilai == null || nilai < 0 || nilai > 100) {
                  return 'Nilai harus antara 0-100';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _savePenilaian,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Simpan 💾',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
          ),
        ),
      ],
    );
  }
}
