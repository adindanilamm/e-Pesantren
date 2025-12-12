import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/santri_entity.dart';

class InputAkhlakScreen extends StatefulWidget {
  final SantriEntity santri;

  const InputAkhlakScreen({super.key, required this.santri});

  @override
  State<InputAkhlakScreen> createState() => _InputAkhlakScreenState();
}

class _InputAkhlakScreenState extends State<InputAkhlakScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();

  String? _kejujuran;
  String? _kedisiplinan;
  String? _kebersihan;
  String? _sopanSantun;

  final List<String> _nilaiOptions = ['1', '2', '3', '4'];

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
      if (_kejujuran == null ||
          _kedisiplinan == null ||
          _kebersihan == null ||
          _sopanSantun == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Semua aspek harus diisi'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) return;

        await FirebaseFirestore.instance.collection('penilaian_akhlak').add({
          'santriId': widget.santri.id,
          'santriNama': widget.santri.nama,
          'tanggal': Timestamp.fromDate(_selectedDate),
          'kejujuran': int.parse(_kejujuran!),
          'kedisiplinan': int.parse(_kedisiplinan!),
          'kebersihan': int.parse(_kebersihan!),
          'sopanSantun': int.parse(_sopanSantun!),
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': currentUser.uid,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Penilaian Akhlak berhasil disimpan'),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          setState(() {
            _kejujuran = null;
            _kedisiplinan = null;
            _kebersihan = null;
            _sopanSantun = null;
          });
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
                Icon(Icons.star, color: Color(0xFF2563EB), size: 20),
                SizedBox(width: 8),
                Text(
                  'Penilaian Akhlak',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tanggal
            const Text(
              'Tanggal',
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

            // Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDEEBFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Color(0xFF2563EB), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Skala 1-4 (1=Kurang, 2=Cukup, 3=Baik, 4=Sangat Baik)',
                      style: TextStyle(fontSize: 12, color: Color(0xFF2563EB)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Kejujuran
            _buildDropdown(
              label: 'Kejujuran',
              value: _kejujuran,
              onChanged: (value) => setState(() => _kejujuran = value),
            ),
            const SizedBox(height: 16),

            // Kedisiplinan
            _buildDropdown(
              label: 'Kedisiplinan',
              value: _kedisiplinan,
              onChanged: (value) => setState(() => _kedisiplinan = value),
            ),
            const SizedBox(height: 16),

            // Kebersihan
            _buildDropdown(
              label: 'Kebersihan',
              value: _kebersihan,
              onChanged: (value) => setState(() => _kebersihan = value),
            ),
            const SizedBox(height: 16),

            // Sopan Santun
            _buildDropdown(
              label: 'Sopan Santun',
              value: _sopanSantun,
              onChanged: (value) => setState(() => _sopanSantun = value),
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Text(
                'Pilih nilai 1-4',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
              items: _nilaiOptions.map((String val) {
                String emoji = '';
                String desc = '';
                switch (val) {
                  case '1':
                    emoji = '😐';
                    desc = 'Kurang';
                    break;
                  case '2':
                    emoji = '😊';
                    desc = 'Cukup';
                    break;
                  case '3':
                    emoji = '😄';
                    desc = 'Baik';
                    break;
                  case '4':
                    emoji = '⭐';
                    desc = 'Sangat Baik';
                    break;
                }
                return DropdownMenuItem<String>(
                  value: val,
                  child: Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 12),
                      Text(
                        '$val - $desc',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
