import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/santri_entity.dart';

class InputKehadiranScreen extends StatefulWidget {
  final SantriEntity santri;

  const InputKehadiranScreen({super.key, required this.santri});

  @override
  State<InputKehadiranScreen> createState() => _InputKehadiranScreenState();
}

class _InputKehadiranScreenState extends State<InputKehadiranScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'Hadir';

  final List<Map<String, dynamic>> _statusOptions = [
    {'value': 'Hadir', 'icon': '✅', 'color': Color(0xFF10B981)},
    {'value': 'Sakit', 'icon': '😷', 'color': Color(0xFFFBBF24)},
    {'value': 'Izin', 'icon': '🙏', 'color': Color(0xFF3B82F6)},
    {'value': 'Alpa', 'icon': '❌', 'color': Color(0xFFEF4444)},
  ];

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
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

        // 1. Save daily attendance
        await FirebaseFirestore.instance.collection('kehadiran').add({
          'santriId': widget.santri.id,
          'santriNama': widget.santri.nama,
          'tanggal': Timestamp.fromDate(_selectedDate),
          'status': _selectedStatus,
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': currentUser.uid,
        });

        // 2. Update summary (rekap_kehadiran)
        final rekapRef = FirebaseFirestore.instance
            .collection('rekap_kehadiran')
            .where('santriId', isEqualTo: widget.santri.id)
            .limit(1);

        final rekapSnapshot = await rekapRef.get();

        if (rekapSnapshot.docs.isEmpty) {
          // Create new summary
          await FirebaseFirestore.instance.collection('rekap_kehadiran').add({
            'santriId': widget.santri.id,
            'santriNama': widget.santri.nama,
            'hadir': _selectedStatus == 'Hadir' ? 1 : 0,
            'sakit': _selectedStatus == 'Sakit' ? 1 : 0,
            'izin': _selectedStatus == 'Izin' ? 1 : 0,
            'alpa': _selectedStatus == 'Alpa' ? 1 : 0,
            'totalHari': 1,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Update existing summary
          final docId = rekapSnapshot.docs.first.id;
          final data = rekapSnapshot.docs.first.data();

          await FirebaseFirestore.instance
              .collection('rekap_kehadiran')
              .doc(docId)
              .update({
                'hadir':
                    (data['hadir'] ?? 0) + (_selectedStatus == 'Hadir' ? 1 : 0),
                'sakit':
                    (data['sakit'] ?? 0) + (_selectedStatus == 'Sakit' ? 1 : 0),
                'izin':
                    (data['izin'] ?? 0) + (_selectedStatus == 'Izin' ? 1 : 0),
                'alpa':
                    (data['alpa'] ?? 0) + (_selectedStatus == 'Alpa' ? 1 : 0),
                'totalHari': (data['totalHari'] ?? 0) + 1,
                'updatedAt': FieldValue.serverTimestamp(),
              });
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Kehadiran berhasil disimpan'),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
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
                Icon(Icons.check_circle, color: Color(0xFF2563EB), size: 20),
                SizedBox(width: 8),
                Text(
                  'Input Kehadiran',
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            _getMonthName(_selectedDate.month),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Status Kehadiran
            const Text(
              'Status Kehadiran',
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
                  value: _selectedStatus,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF64748B),
                  ),
                  items: _statusOptions.map((Map<String, dynamic> option) {
                    return DropdownMenuItem<String>(
                      value: option['value'],
                      child: Row(
                        children: [
                          Text(
                            option['icon'],
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            option['value'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: option['color'],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    }
                  },
                ),
              ),
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

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }
}
