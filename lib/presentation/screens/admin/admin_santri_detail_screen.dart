import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/santri_entity.dart';

class AdminSantriDetailScreen extends StatefulWidget {
  final SantriEntity santri;

  const AdminSantriDetailScreen({super.key, required this.santri});

  @override
  State<AdminSantriDetailScreen> createState() =>
      _AdminSantriDetailScreenState();
}

class _AdminSantriDetailScreenState extends State<AdminSantriDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
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
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
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
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.santri.nama,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NIS: ${widget.santri.nis} • Kamar ${widget.santri.kamar}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF64748B),
              indicator: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(8),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.all(8),
              tabs: const [
                Tab(text: 'Penilaian'),
                Tab(text: 'Kehadiran'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildPenilaianTab(), _buildKehadiranTab()],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildPenilaianTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info message
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
                Icon(Icons.info_outline, color: Color(0xFF2563EB), size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Data nilai akan muncul setelah Ustadz melakukan input penilaian',
                    style: TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Real data from Firebase - Tahfidz
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('penilaian_tahfidz')
                .where('santriId', isEqualTo: widget.santri.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _buildEmptyScoreCard('Tahfidz');
              }

              final docs = snapshot.data!.docs;
              double totalNilai = 0;
              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                totalNilai += (data['nilaiHafalan'] ?? 0).toDouble();
              }
              final avgNilai = docs.isNotEmpty
                  ? totalNilai / docs.length.toDouble()
                  : 0.0;

              return _buildScoreCard('Tahfidz', avgNilai);
            },
          ),
          const SizedBox(height: 12),

          // Real data - Mapel
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('penilaian_mapel')
                .where('santriId', isEqualTo: widget.santri.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _buildEmptyScoreCard('Mata Pelajaran');
              }

              final docs = snapshot.data!.docs;
              double totalNilai = 0;
              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                totalNilai += (data['nilai'] ?? 0).toDouble();
              }
              final avgNilai = docs.isNotEmpty
                  ? totalNilai / docs.length.toDouble()
                  : 0.0;

              return _buildScoreCard('Mata Pelajaran', avgNilai);
            },
          ),
          const SizedBox(height: 12),

          // Real data - Akhlak
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('penilaian_akhlak')
                .where('santriId', isEqualTo: widget.santri.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _buildEmptyScoreCard('Akhlak');
              }

              final docs = snapshot.data!.docs;
              double totalNilai = 0;
              int count = 0;

              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                // Akhlak uses 1-4 scale, convert to 0-100
                final kejujuran = (data['kejujuran'] ?? 0) * 25.0;
                final kedisiplinan = (data['kedisiplinan'] ?? 0) * 25.0;
                final kebersihan = (data['kebersihan'] ?? 0) * 25.0;
                final sopanSantun = (data['sopanSantun'] ?? 0) * 25.0;

                totalNilai +=
                    (kejujuran + kedisiplinan + kebersihan + sopanSantun) / 4;
                count++;
              }
              final avgNilai = count > 0 ? totalNilai / count.toDouble() : 0.0;

              return _buildScoreCard('Akhlak', avgNilai);
            },
          ),
          const SizedBox(height: 12),

          // Kehadiran
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('rekap_kehadiran')
                .where('santriId', isEqualTo: widget.santri.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _buildEmptyScoreCard('Kehadiran');
              }

              final docs = snapshot.data!.docs;
              int totalHadir = 0;
              int totalHari = 0;

              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                totalHadir += (data['hadir'] ?? 0) as int;
                totalHari += (data['totalHari'] ?? 0) as int;
              }

              final persentase = totalHari > 0
                  ? (totalHadir / totalHari) * 100
                  : 0;

              return Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kehadiran',
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                    ),
                    Text(
                      '${persentase.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Grafik Tahfidz
          const Text(
            'Grafik Tahfidz',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('penilaian_tahfidz')
                .where('santriId', isEqualTo: widget.santri.id)
                .orderBy('tanggal', descending: false)
                .limit(6)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container(
                  height: 200,
                  padding: const EdgeInsets.all(20),
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
                  child: const Center(
                    child: Text(
                      'Belum ada data penilaian Tahfidz',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  ),
                );
              }

              final docs = snapshot.data!.docs;
              final barGroups = <BarChartGroupData>[];

              for (int i = 0; i < docs.length; i++) {
                final data = docs[i].data() as Map<String, dynamic>;
                final nilai = (data['nilaiHafalan'] ?? 0).toDouble();

                barGroups.add(
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: nilai,
                        color: const Color(0xFF2563EB),
                        width: 40,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                height: 200,
                padding: const EdgeInsets.all(20),
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
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              'W${value.toInt() + 1}',
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: barGroups,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, double nilai) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          Text(
            nilai.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyScoreCard(String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          const Text(
            '-',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKehadiranTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rekap_kehadiran')
          .where('santriId', isEqualTo: widget.santri.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Info message
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
                          'Data kehadiran akan muncul setelah Ustadz melakukan input kehadiran',
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

                // Empty state
                Container(
                  padding: const EdgeInsets.all(40),
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
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Belum ada data kehadiran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Calculate attendance stats
        int totalHadir = 0;
        int totalSakit = 0;
        int totalIzin = 0;
        int totalAlpa = 0;
        int totalHari = 0;

        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;
          totalHadir += (data['hadir'] ?? 0) as int;
          totalSakit += (data['sakit'] ?? 0) as int;
          totalIzin += (data['izin'] ?? 0) as int;
          totalAlpa += (data['alpa'] ?? 0) as int;
          totalHari += (data['totalHari'] ?? 0) as int;
        }

        final persentaseHadir = totalHari > 0
            ? (totalHadir / totalHari) * 100
            : 0.0;
        final persentaseSakit = totalHari > 0
            ? (totalSakit / totalHari) * 100
            : 0.0;
        final persentaseIzin = totalHari > 0
            ? (totalIzin / totalHari) * 100
            : 0.0;
        final persentaseAlpa = totalHari > 0
            ? (totalAlpa / totalHari) * 100
            : 0.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Statistik Kehadiran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),

              // Attendance Stats Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildAttendanceCard(
                    'Hadir',
                    '$totalHadir hari',
                    const Color(0xFF10B981),
                  ),
                  _buildAttendanceCard(
                    'Sakit',
                    '$totalSakit hari',
                    const Color(0xFFFBBF24),
                  ),
                  _buildAttendanceCard(
                    'Izin',
                    '$totalIzin hari',
                    const Color(0xFF3B82F6),
                  ),
                  _buildAttendanceCard(
                    'Alpa',
                    '$totalAlpa hari',
                    const Color(0xFFEF4444),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Percentage
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Persentase Kehadiran:',
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${persentaseHadir.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Pie Chart
              Container(
                height: 250,
                padding: const EdgeInsets.all(20),
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
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: [
                      if (persentaseHadir > 0)
                        PieChartSectionData(
                          value: persentaseHadir,
                          color: const Color(0xFF10B981),
                          title:
                              'Hadir\n${persentaseHadir.toStringAsFixed(1)}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      if (persentaseSakit > 0)
                        PieChartSectionData(
                          value: persentaseSakit,
                          color: const Color(0xFFFBBF24),
                          title:
                              'Sakit\n${persentaseSakit.toStringAsFixed(1)}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      if (persentaseIzin > 0)
                        PieChartSectionData(
                          value: persentaseIzin,
                          color: const Color(0xFF3B82F6),
                          title: 'Izin\n${persentaseIzin.toStringAsFixed(1)}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      if (persentaseAlpa > 0)
                        PieChartSectionData(
                          value: persentaseAlpa,
                          color: const Color(0xFFEF4444),
                          title: 'Alpa\n${persentaseAlpa.toStringAsFixed(1)}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
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
