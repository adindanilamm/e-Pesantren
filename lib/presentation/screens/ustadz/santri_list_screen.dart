import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/santri_entity.dart';
import '../../providers/santri_provider.dart';
import '../../widgets/modern_text_field.dart';
import '../../widgets/santri_card.dart';
import 'input_penilaian_screen.dart';
import 'ustadz_santri_detail_screen.dart';

class SantriListScreen extends ConsumerStatefulWidget {
  const SantriListScreen({super.key});

  @override
  ConsumerState<SantriListScreen> createState() => _SantriListScreenState();
}

class _SantriListScreenState extends ConsumerState<SantriListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showInputMenu(SantriEntity santri) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              santri.nama,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'NIS: ${santri.nis} • Kamar ${santri.kamar}',
              style: const TextStyle(color: AppTheme.textGray, fontSize: 14),
            ),
            const SizedBox(height: 24),
            _buildMenuItem(
              icon: Icons.visibility,
              title: 'Lihat Detail',
              subtitle: 'Nilai & Kehadiran',
              color: const Color(0xFF2563EB),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UstadzSantriDetailScreen(santri: santri),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              icon: Icons.edit,
              title: 'Input Penilaian',
              subtitle: 'Tahfidz, Mapel, Akhlak, Kehadiran',
              color: const Color(0xFF10B981),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InputPenilaianScreen(santri: santri),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textGray,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final santriListAsync = ref.watch(santriSearchProvider(_searchQuery));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        title: const Text('Daftar Santri'),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: AppTheme.softShadow,
            ),
            child: ModernTextField(
              label: 'Cari Santri',
              hint: 'Nama atau NIS',
              controller: _searchController,
              prefixIcon: Icons.search,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // List
          Expanded(
            child: santriListAsync.when(
              data: (santriList) {
                if (santriList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off_outlined,
                          size: 64,
                          color: AppTheme.textGray.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text('Data santri tidak ditemukan'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: santriList.length,
                  itemBuilder: (context, index) {
                    final santri = santriList[index];
                    return SantriCard(
                      santri: santri,
                      onTap: () => _showInputMenu(santri),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryTeal),
              ),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
