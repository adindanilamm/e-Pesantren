import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/santri_entity.dart';

class InputMapelScreen extends StatefulWidget {
  final SantriEntity santri;
  final List<String> availableSubjects;

  const InputMapelScreen({
    super.key,
    required this.santri,
    required this.availableSubjects,
  });

  @override
  State<InputMapelScreen> createState() => _InputMapelScreenState();
}

class _InputMapelScreenState extends State<InputMapelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formatifController = TextEditingController();
  final _sumatifController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  late String _selectedAspek;
  late List<String> _aspekOptions;

  @override
  void initState() {
    super.initState();
    // Use available subjects passed from parent
    _aspekOptions = widget.availableSubjects.isNotEmpty
        ? widget.availableSubjects
        : ['Fiqih', 'Hadis', 'Bahasa Arab'];
    _selectedAspek = _aspekOptions.first;
  }

  @override
  void dispose() {
    _formatifController.dispose();
    _sumatifController.dispose();
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

        final formatif = double.parse(_formatifController.text.trim());
        final sumatif = double.parse(_sumatifController.text.trim());
        final nilaiAkhir = (formatif + sumatif) / 2;

        await FirebaseFirestore.instance.collection('penilaian_mapel').add({
          'santriId': widget.santri.id,
          'santriNama': widget.santri.nama,
          'aspek': _selectedAspek,
          'tanggal': Timestamp.fromDate(_selectedDate),
          'nilaiFormatif': formatif,
          'nilaiSumatif': sumatif,
          'nilai': nilaiAkhir, // Added for dashboard compatibility
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': currentUser.uid,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Penilaian Mapel berhasil disimpan'),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          _formKey.currentState!.reset();
          _formatifController.clear();
          _sumatifController.clear();
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
                Icon(Icons.book, color: Color(0xFF2563EB), size: 20),
                SizedBox(width: 8),
                Text(
                  'Penilaian Fiqh/Bahasa Arab',
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

            // Aspek Dropdown
            const Text(
              'Aspek',
              style: TextStyle(
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
                  value: _selectedAspek,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF64748B),
                  ),
                  items: _aspekOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.subject,
                            color: Color(0xFF64748B),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            value,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedAspek = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nilai Formatif
            _buildTextField(
              label: 'Nilai Formatif (0-100)',
              controller: _formatifController,
              icon: Icons.edit_note,
              hint: '0-100',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nilai formatif tidak boleh kosong';
                }
                final nilai = double.tryParse(value);
                if (nilai == null || nilai < 0 || nilai > 100) {
                  return 'Nilai harus antara 0-100';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Nilai Sumatif
            _buildTextField(
              label: 'Nilai Sumatif (0-100)',
              controller: _sumatifController,
              icon: Icons.assignment,
              hint: '0-100',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nilai sumatif tidak boleh kosong';
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
