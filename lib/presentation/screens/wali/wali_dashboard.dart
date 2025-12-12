import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import 'wali_profile_screen.dart';
import 'rapor_screen.dart';

class WaliDashboard extends ConsumerWidget {
  const WaliDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);
    final userName = userAsync.value?.name ?? 'Bapak/Ibu';
    final santriId = userAsync.value?.santriIds?.isNotEmpty == true
        ? userAsync.value!.santriIds!.first
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Blue Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Assalamu\'alaikum, $userName 👋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
                const SizedBox(height: 4),
                const Text(
                  'Selamat datang di Spasantren',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
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
                  // Student Info Card
                  if (santriId != null)
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('santri')
                          .doc(santriId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox(
                            height: 100,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final data =
                            snapshot.data!.data() as Map<String, dynamic>?;
                        if (data == null) return const SizedBox();

                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    '📚',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'PUTRA/PUTRI ANDA',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: const Color(0xFFBFDBFE),
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 32,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['nama'] ?? 'Nama Santri',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              'Kamar: ${data['kamar'] ?? '-'}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              'NIS: ${data['nis'] ?? '-'}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Angkatan: ${data['angkatan'] ?? '-'}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1E293B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 24),

                  // Info Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEEBFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2563EB).withOpacity(0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF2563EB),
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Data nilai dan kehadiran akan muncul setelah Ustadz melakukan input. Untuk melihat rapor lengkap, klik menu Rapor di bawah.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Status Terkini Section
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        color: Color(0xFF2563EB),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Status Terkini',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (santriId != null) ...[
                    // Kehadiran Card
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('rekap_kehadiran')
                          .where('santriId', isEqualTo: santriId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        String value = '-';
                        String subtitle = 'Belum ada data';

                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          int totalHadir = 0;
                          int totalHari = 0;
                          for (var doc in snapshot.data!.docs) {
                            final data = doc.data() as Map<String, dynamic>;
                            totalHadir += (data['hadir'] ?? 0) as int;
                            totalHari += (data['totalHari'] ?? 0) as int;
                          }
                          if (totalHari > 0) {
                            final percentage = (totalHadir / totalHari) * 100;
                            value = '${percentage.toStringAsFixed(0)}%';
                            subtitle = 'Hadir $totalHadir/$totalHari hari';
                          }
                        }

                        return _buildStatusCard(
                          icon: Icons.check_circle,
                          iconColor: const Color(0xFF10B981),
                          iconBg: const Color(0xFFD1FAE5),
                          title: 'Kehadiran',
                          value: value,
                          subtitle: subtitle,
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // Rata-rata Nilai Card
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('penilaian_mapel')
                          .where('santriId', isEqualTo: santriId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        String value = '-';
                        String subtitle = 'Belum ada data';

                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          double totalNilai = 0;
                          for (var doc in snapshot.data!.docs) {
                            final data = doc.data() as Map<String, dynamic>;
                            totalNilai += (data['nilai'] ?? 0).toDouble();
                          }
                          final avg = totalNilai / snapshot.data!.docs.length;
                          value = avg.toStringAsFixed(1);
                          subtitle = 'Dari semua mata pelajaran';
                        }

                        return _buildStatusCard(
                          icon: Icons.bar_chart,
                          iconColor: const Color(0xFF2563EB),
                          iconBg: const Color(0xFFDEEBFF),
                          title: 'Rata-rata Nilai',
                          value: value,
                          subtitle: subtitle,
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // Perilaku Card
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('penilaian_akhlak')
                          .where('santriId', isEqualTo: santriId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        String value = '-';
                        String subtitle = 'Belum ada data';

                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          double totalNilai = 0;
                          int count = 0;
                          for (var doc in snapshot.data!.docs) {
                            final data = doc.data() as Map<String, dynamic>;
                            totalNilai +=
                                (data['kejujuran'] ?? 0) +
                                (data['kedisiplinan'] ?? 0) +
                                (data['kebersihan'] ?? 0) +
                                (data['sopanSantun'] ?? 0);
                            count++;
                          }
                          if (count > 0) {
                            final avg = totalNilai / (count * 4);
                            if (avg >= 3.5) {
                              value = 'Sangat Baik';
                            } else if (avg >= 2.5) {
                              value = 'Baik';
                            } else if (avg >= 1.5) {
                              value = 'Cukup';
                            } else {
                              value = 'Kurang';
                            }
                            subtitle = 'Akhlak & Kedisiplinan';
                          }
                        }

                        return _buildStatusCard(
                          icon: Icons.star,
                          iconColor: const Color(0xFFFBBF24),
                          iconBg: const Color(0xFFFEF3C7),
                          title: 'Perilaku',
                          value: value,
                          subtitle: subtitle,
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Nilai Terbaru Section
                  Row(
                    children: [
                      const Icon(
                        Icons.description,
                        color: Color(0xFF2563EB),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Nilai Terbaru',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (santriId != null)
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('penilaian_tahfidz')
                          .where('santriId', isEqualTo: santriId)
                          .orderBy('tanggal', descending: true)
                          .limit(1)
                          .snapshots(),
                      builder: (context, snapshot) {
                        String title = 'Nilai Terbaru';
                        String value = 'Belum ada data';
                        Color valueColor = const Color(0xFF94A3B8);
                        Color iconBg = const Color(0xFFE2E8F0);
                        Color iconColor = const Color(0xFF94A3B8);

                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          final data =
                              snapshot.data!.docs.first.data()
                                  as Map<String, dynamic>;
                          title = 'Tahfidz';
                          value = (data['nilaiHafalan'] ?? 0).toString();
                          valueColor = const Color(0xFF10B981);
                          iconBg = const Color(0xFFD1FAE5);
                          iconColor = const Color(0xFF10B981);
                        }

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RaporScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: iconBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.menu_book,
                                    color: iconColor,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        value,
                                        style: TextStyle(
                                          fontSize:
                                              snapshot.hasData &&
                                                  snapshot.data!.docs.isNotEmpty
                                              ? 24
                                              : 16,
                                          fontWeight: FontWeight.w700,
                                          color: valueColor,
                                        ),
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
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                onTap: () {},
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Profil',
                isActive: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WaliProfileScreen(),
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
