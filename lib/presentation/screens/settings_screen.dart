import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'Akun'),
          _buildSettingTile(context, 'Profil Saya', Icons.person_outline, () {
            // Navigate to Profile
          }),
          _buildSettingTile(
            context,
            'Ganti Password',
            Icons.lock_outline,
            () {},
          ),

          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Aplikasi'),
          _buildSettingTile(
            context,
            'Notifikasi',
            Icons.notifications_outlined,
            () {},
            trailing: Switch(value: true, onChanged: (v) {}),
          ),
          _buildSettingTile(
            context,
            'Mode Gelap',
            Icons.dark_mode_outlined,
            () {},
            trailing: Switch(value: false, onChanged: (v) {}),
          ),
          _buildSettingTile(
            context,
            'Tentang Aplikasi',
            Icons.info_outline,
            () {
              showAboutDialog(
                context: context,
                applicationName: 'e-Penilaian Santri',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Pesantren App',
              );
            },
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                ref.read(authControllerProvider.notifier).logout();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('KELUAR APLIKASI'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF2563EB),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.textGray),
        title: Text(title),
        trailing:
            trailing ??
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textGray,
            ),
        onTap: onTap,
      ),
    );
  }
}
