import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../../domain/entities/santri_entity.dart';
import 'add_santri_screen.dart';
import 'admin_santri_detail_screen.dart';
import 'admin_profile_screen.dart';
import 'create_user_screen.dart';
import 'user_management_screen.dart';
import '../../providers/nav_provider.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  String? _selectedKamar;
  String? _selectedAngkatan;

  // Local state removed in favor of provider
  // int _selectedIndex = 0;

  final List<String> _kamarOptions = [
    'Semua',
    'A2',
    'A3',
    'B1',
    'C2',
    'D4',
    'E7',
  ];
  final List<String> _angkatanOptions = [
    'Semua',
    '2030',
    '2029',
    '2028',
    '2027',
    '2026',
    '2025',
    '2024',
    '2023',
    '2022',
    '2021',
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(adminTabProvider);
    final userAsync = ref.watch(authStateProvider);
    final userEmail = userAsync.value?.email ?? 'admin@pesantren.id';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: selectedIndex == 0
          ? _buildHomeContent(userEmail)
          : const UserManagementScreen(),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddSantriScreen()),
                );
              },
              backgroundColor: const Color(0xFF2563EB),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateUserScreen()),
                );
              },
              backgroundColor: const Color(0xFF2563EB),
              child: const Icon(Icons.person_add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: _buildBottomNav(context, selectedIndex),
    );
  }

  Widget _buildHomeContent(String userEmail) {
    return Column(
      children: [
        // Blue Header
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xFF2563EB)),
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.business, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Data Santri',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).logout();
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    tooltip: 'Keluar',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      userEmail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Daftar Santri Header
                const Text(
                  'Daftar Santri',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('santri')
                      .snapshots(),
                  builder: (context, snapshot) {
                    final count = snapshot.hasData
                        ? snapshot.data!.docs.length
                        : 0;
                    return Text(
                      'Total $count santri',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Filters
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        icon: Icons.home,
                        label: _selectedKamar ?? 'Semua Kamar',
                        options: _kamarOptions,
                        onChanged: (value) {
                          setState(() {
                            _selectedKamar = value == 'Semua' ? null : value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFilterDropdown(
                        icon: Icons.school,
                        label: _selectedAngkatan ?? 'Semua Angkatan',
                        options: _angkatanOptions,
                        onChanged: (value) {
                          setState(() {
                            _selectedAngkatan = value == 'Semua' ? null : value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Student List
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('santri')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Belum ada data santri',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    var docs = snapshot.data!.docs;

                    // Apply filters
                    if (_selectedKamar != null) {
                      docs = docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return data['kamar'] == _selectedKamar;
                      }).toList();
                    }

                    if (_selectedAngkatan != null) {
                      docs = docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final angkatan = data['angkatan'];
                        if (angkatan is int) {
                          return angkatan == _selectedAngkatan;
                        } else if (angkatan is String) {
                          return int.tryParse(angkatan) == _selectedAngkatan;
                        }
                        return false;
                      }).toList();
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;

                        // Handle angkatan as both String and int
                        int angkatan = 2023;
                        if (data['angkatan'] != null) {
                          if (data['angkatan'] is int) {
                            angkatan = data['angkatan'];
                          } else if (data['angkatan'] is String) {
                            angkatan = int.tryParse(data['angkatan']) ?? 2023;
                          }
                        }

                        final santri = SantriEntity(
                          id: docs[index].id,
                          nis: data['nis'] ?? '',
                          nama: data['nama'] ?? '',

                          kamar: data['kamar'] ?? '',
                          angkatan: angkatan,
                          createdAt:
                              (data['createdAt'] as Timestamp?)?.toDate() ??
                              DateTime.now(),
                        );

                        return _buildStudentCard(context, santri);
                      },
                    );
                  },
                ),
                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown({
    required IconData icon,
    required String label,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      offset: const Offset(0, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) {
        return options.map((option) {
          final isSelected =
              (option == 'Semua' && label.startsWith('Semua')) ||
              label.contains(option);
          return PopupMenuItem<String>(
            value: option,
            child: Row(
              children: [
                Icon(icon, size: 20, color: const Color(0xFF64748B)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option == 'Semua'
                        ? label.split(' ')[0] + ' ' + option
                        : option,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, color: Color(0xFF2563EB), size: 20),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            Icon(icon, size: 18, color: const Color(0xFF64748B)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF64748B),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, SantriEntity santri) {
    // Simulate status - in real app, check from database
    final isSubmitted = santri.id.hashCode % 3 != 0;

    return Dismissible(
      key: Key(santri.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Hapus Santri'),
              content: Text(
                'Apakah Anda yakin ingin menghapus ${santri.nama}?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                  ),
                  child: const Text('Hapus'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        try {
          await FirebaseFirestore.instance
              .collection('santri')
              .doc(santri.id)
              .delete();

          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('${santri.nama} berhasil dihapus'),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } catch (e) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Gagal menghapus: ${e.toString()}'),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminSantriDetailScreen(santri: santri),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      santri.nama,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIS: ${santri.nis} • Kamar ${santri.kamar}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          isSubmitted ? Icons.check_circle : Icons.access_time,
                          size: 14,
                          color: isSubmitted
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isSubmitted ? 'Terkirim' : 'Belum terkirim',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSubmitted
                                ? const Color(0xFF10B981)
                                : const Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, int selectedIndex) {
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
                isActive: selectedIndex == 0,
                onTap: () {
                  ref.read(adminTabProvider.notifier).state = 0;
                },
              ),
              _buildNavItem(
                icon: Icons.people,
                label: 'Pengguna',
                isActive: selectedIndex == 1,
                onTap: () {
                  ref.read(adminTabProvider.notifier).state = 1;
                },
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Profil',
                isActive: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminProfileScreen(),
                    ),
                  );
                },
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
