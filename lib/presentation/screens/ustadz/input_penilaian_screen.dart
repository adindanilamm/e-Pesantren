import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/santri_entity.dart';
import '../../providers/auth_provider.dart';
import 'input_tahfidz_screen.dart';
import 'input_mapel_screen.dart';
import 'input_akhlak_screen.dart';
import 'input_kehadiran_screen.dart';

class InputPenilaianScreen extends ConsumerStatefulWidget {
  final SantriEntity santri;
  final int initialTab;

  const InputPenilaianScreen({
    super.key,
    required this.santri,
    this.initialTab = 0,
  });

  @override
  ConsumerState<InputPenilaianScreen> createState() =>
      _InputPenilaianScreenState();
}

class _InputPenilaianScreenState extends ConsumerState<InputPenilaianScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<_TabData> _tabs = [];
  List<String> _mapelSubjects = [];

  // Subject categories
  static const List<String> _mapelList = ['Fiqih', 'Hadis', 'Bahasa Arab'];

  @override
  void initState() {
    super.initState();
    // Will initialize tabs after getting user data
  }

  void _initializeTabs(List<String>? userSubjects) {
    final subjects = userSubjects ?? [];

    // Determine which tabs to show
    final bool hasTahfidz = subjects.contains('Tahfidz');
    // Check if user has any mapel subjects
    _mapelSubjects = subjects.where((s) => _mapelList.contains(s)).toList();
    final bool hasMapel = _mapelSubjects.isNotEmpty;

    _tabs = [];

    // Add Tahfidz tab if user teaches Tahfidz
    if (hasTahfidz) {
      _tabs.add(
        _TabData(
          label: '📚 Tahfidz',
          widget: InputTahfidzScreen(santri: widget.santri),
        ),
      );
    }

    // Add Mapel tab if user teaches any mapel
    if (hasMapel) {
      _tabs.add(
        _TabData(
          label: '📖 Mapel',
          widget: InputMapelScreen(
            santri: widget.santri,
            availableSubjects: _mapelSubjects,
          ),
        ),
      );
    }

    // Always add Akhlak and Kehadiran
    _tabs.add(
      _TabData(
        label: '⭐ Akhlak',
        widget: InputAkhlakScreen(santri: widget.santri),
      ),
    );
    _tabs.add(
      _TabData(
        label: '✅ Kehadiran',
        widget: InputKehadiranScreen(santri: widget.santri),
      ),
    );

    // Dispose old controller if exists
    _tabController?.dispose();

    // Create new controller with correct length
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, _tabs.length - 1),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);

    return userAsync.when(
      data: (user) {
        // Initialize tabs based on user's subjects
        if (_tabController == null || _tabs.isEmpty) {
          _initializeTabs(user?.mataPelajaran);
        }

        if (_tabs.isEmpty) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              title: const Text('Input Penilaian'),
              backgroundColor: const Color(0xFF2563EB),
            ),
            body: const Center(
              child: Text('Tidak ada mata pelajaran yang ditugaskan'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Color(0xFF2563EB),
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Kembali',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(Icons.edit, color: Color(0xFF2563EB), size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Input Penilaian',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Color(0xFF64748B),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Santri: ${widget.santri.nama}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tabs
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _tabs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final tab = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(left: index > 0 ? 8 : 0),
                        child: _buildTab(index, tab.label),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _tabs.map((t) => t.widget).toList(),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  Widget _buildTab(int index, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _tabController?.animateTo(index);
        });
      },
      child: AnimatedBuilder(
        animation: _tabController!,
        builder: (context, child) {
          final isSelected = _tabController?.index == index;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          );
        },
      ),
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
                onTap: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
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

// Helper class for tab data
class _TabData {
  final String label;
  final Widget widget;

  _TabData({required this.label, required this.widget});
}
