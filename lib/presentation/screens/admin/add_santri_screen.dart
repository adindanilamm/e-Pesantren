import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddSantriScreen extends StatefulWidget {
  const AddSantriScreen({super.key});

  @override
  State<AddSantriScreen> createState() => _AddSantriScreenState();
}

class _AddSantriScreenState extends State<AddSantriScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nisController = TextEditingController();
  final _namaController = TextEditingController();
  final _kamarController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedAngkatan = '2023';
  String? _selectedWaliKelasId;
  String? _selectedWaliKelasName;

  final List<String> _angkatanOptions = ['2023', '2022', '2021', '2020'];

  @override
  void dispose() {
    _nisController.dispose();
    _namaController.dispose();
    _kamarController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
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

  Future<void> _saveSantri() async {
    if (_formKey.currentState!.validate()) {
      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) return;

        await FirebaseFirestore.instance.collection('santri').add({
          'nis': _nisController.text.trim(),
          'nama': _namaController.text.trim(),
          'tanggalLahir': Timestamp.fromDate(_selectedDate),
          'kamar': _kamarController.text.trim(),
          'angkatan': int.parse(_selectedAngkatan),
          'waliKelasId': _selectedWaliKelasId,
          'waliKelasName': _selectedWaliKelasName,
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': currentUser.uid,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Santri berhasil ditambahkan'),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          Navigator.pop(context);
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2563EB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kembali',
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Row(
                children: [
                  Icon(Icons.person_add, color: Color(0xFF2563EB), size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Tambah Santri Baru',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // NIS Field
              _buildTextField(
                controller: _nisController,
                label: 'NIS',
                hint: 'Contoh: 2025-001',
                icon: Icons.badge,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIS tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nama Lengkap Field
              _buildTextField(
                controller: _namaController,
                label: 'Nama Lengkap',
                hint: 'Nama santri',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tanggal Lahir
              const Text(
                'Tanggal Lahir',
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
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Kamar/Asrama Field
              _buildTextField(
                controller: _kamarController,
                label: 'Kamar/Asrama',
                hint: _selectedWaliKelasId != null
                    ? 'Mengikuti Wali Kelas'
                    : 'Contoh: A1, B2, C3...',
                icon: Icons.home,
                readOnly: _selectedWaliKelasId != null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kamar tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Angkatan Dropdown
              const Text(
                'Angkatan',
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
                    value: _selectedAngkatan,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF64748B),
                    ),
                    items: _angkatanOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.school,
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
                          _selectedAngkatan = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Wali Kelas Dropdown
              const Text(
                'Wali Kelas',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'ustadz')
                    .where('isWaliKelas', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> waliKelasOptions = [];

                  if (snapshot.hasData) {
                    for (var doc in snapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      waliKelasOptions.add({
                        'uid': doc.id,
                        'name': data['name'] ?? 'Unknown',
                        'kamar': data['waliKelasKamar'] ?? '-',
                      });
                    }
                  }

                  return Container(
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
                        value: _selectedWaliKelasId,
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: Color(0xFF94A3B8),
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Pilih Wali Kelas',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF64748B),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text(
                              'Tidak ada wali kelas',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                          ...waliKelasOptions.map((wali) {
                            return DropdownMenuItem<String>(
                              value: wali['uid'],
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.school,
                                    color: Color(0xFF7C3AED),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          wali['name'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        Text(
                                          'Kamar ${wali['kamar']}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedWaliKelasId = newValue;

                            if (newValue != null) {
                              final selected = waliKelasOptions.firstWhere(
                                (w) => w['uid'] == newValue,
                                orElse: () => {'name': null, 'kamar': ''},
                              );
                              _selectedWaliKelasName = selected['name'];

                              // Auto-fill kamar if available
                              if (selected['kamar'] != null &&
                                  selected['kamar'] != '-') {
                                _kamarController.text = selected['kamar'];
                              }
                            } else {
                              _selectedWaliKelasName = null;
                              // Optional: Clear kamar or leave it
                              _kamarController.clear();
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveSantri,
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
                        'Simpan',
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
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    bool readOnly = false,
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
            color: readOnly ? const Color(0xFFF1F5F9) : Colors.white,
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
            readOnly: readOnly,
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
            style: TextStyle(
              fontSize: 14,
              color: readOnly
                  ? const Color(0xFF64748B)
                  : const Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home,
                label: 'Beranda',
                isActive: true,
                onTap: () => Navigator.pop(context),
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Profil',
                isActive: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF94A3B8),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
