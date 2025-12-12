import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen>
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
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
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
                const Row(
                  children: [
                    Icon(Icons.person_add, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Kelola Akun Pengguna',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Buat akun baru untuk Wali Santri atau Ustadz',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
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
                Tab(text: '👨‍👩‍👧 Buat Akun Wali'),
                Tab(text: '👨‍🏫 Buat Akun Ustadz'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [CreateWaliForm(), CreateUstadzForm()],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
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
                isActive: false,
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

// Create Wali Form
class CreateWaliForm extends StatefulWidget {
  const CreateWaliForm({super.key});

  @override
  State<CreateWaliForm> createState() => _CreateWaliFormState();
}

class _CreateWaliFormState extends State<CreateWaliForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nisController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nisController.dispose();
    super.dispose();
  }

  Future<void> _createWaliAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password tidak cocok'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Lookup santri by NIS
      final santriQuery = await FirebaseFirestore.instance
          .collection('santri')
          .where('nis', isEqualTo: _nisController.text.trim())
          .limit(1)
          .get();

      if (santriQuery.docs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Santri dengan NIS tersebut tidak ditemukan'),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      final santriId = santriQuery.docs.first.id;

      // Create secondary app to create user without logging out
      FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      try {
        // Create user with secondary Auth instance
        final userCredential = await FirebaseAuth.instanceFor(app: secondaryApp)
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );

        // Use PRIMARY Firestore (where Admin is logged in) to create the user document
        // This ensures we have Admin permissions to write to 'users' collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'email': _emailController.text.trim(),
              'name': _nameController.text.trim(),
              'role': 'wali_santri',
              'santriId': santriId,
              'santriIds': [santriId], // Add array field for compatibility
              'createdAt': FieldValue.serverTimestamp(),
              'createdBy': FirebaseAuth.instance.currentUser!.uid,
            });

        // Delete secondary app
        await secondaryApp.delete();
      } catch (e) {
        // Ensure secondary app is deleted even if error occurs
        await secondaryApp.delete();
        rethrow;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Akun Wali berhasil dibuat'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        // Clear form
        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        _nisController.clear();
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan';
      if (e.code == 'weak-password') {
        message = 'Password terlalu lemah';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email sudah digunakan';
      } else if (e.code == 'invalid-email') {
        message = 'Email tidak valid';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFFEF4444),
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
            content: Text('Error: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
            // Info Card
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
                      'Akun Wali akan terhubung dengan santri tertentu',
                      style: TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name Field
            _buildTextField(
              controller: _nameController,
              label: 'Nama Lengkap',
              hint: 'Contoh: Bapak Ahmad',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email Field
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'contoh@email.com',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!value.contains('@')) {
                  return 'Email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password Field
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Minimal 6 karakter',
              icon: Icons.lock,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (value.length < 6) {
                  return 'Password minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Confirm Password Field
            _buildTextField(
              controller: _confirmPasswordController,
              label: 'Konfirmasi Password',
              hint: 'Ulangi password',
              icon: Icons.lock_outline,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi password tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // NIS Field
            _buildTextField(
              controller: _nisController,
              label: 'NIS Santri',
              hint: 'Contoh: 2024001',
              icon: Icons.badge,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIS tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createWaliAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Buat Akun Wali',
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
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
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
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
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

// Create Ustadz Form
class CreateUstadzForm extends StatefulWidget {
  const CreateUstadzForm({super.key});

  @override
  State<CreateUstadzForm> createState() => _CreateUstadzFormState();
}

class _CreateUstadzFormState extends State<CreateUstadzForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  // Predefined list of subjects
  static const List<String> _availableSubjects = [
    'Tahfidz',
    'Fiqih',
    'Hadis',
    'Akhlak',
    'Bahasa Arab',
  ];

  // Predefined list of kamar
  static const List<String> _availableKamar = [
    'A2',
    'A3',
    'B1',
    'C2',
    'D4',
    'E7',
  ];

  // Selected subjects
  final Set<String> _selectedSubjects = {};

  // Wali Kelas options
  bool _isWaliKelas = false;
  String? _selectedWaliKelasKamar;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _createUstadzAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password tidak cocok'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create secondary app to create user without logging out
      FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      try {
        // Create user with secondary Auth instance
        final userCredential = await FirebaseAuth.instanceFor(app: secondaryApp)
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );

        // Validate subject selection
        if (_selectedSubjects.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Pilih minimal satu mata pelajaran'),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
          await secondaryApp.delete();
          setState(() => _isLoading = false);
          return;
        }

        // Convert Set to List for Firestore
        final subjects = _selectedSubjects.toList();

        // Use PRIMARY Firestore (where Admin is logged in) to create the user document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'uid': userCredential.user!.uid,
              'email': _emailController.text.trim(),
              'name': _nameController.text.trim(),
              'role': 'ustadz',
              'subjects': subjects,
              'mataPelajaran': subjects,
              'isWaliKelas': _isWaliKelas,
              'waliKelasKamar': _isWaliKelas ? _selectedWaliKelasKamar : null,
              'createdAt': FieldValue.serverTimestamp(),
              'createdBy': FirebaseAuth.instance.currentUser!.uid,
            });

        // Delete secondary app
        await secondaryApp.delete();
      } catch (e) {
        // Ensure secondary app is deleted even if error occurs
        await secondaryApp.delete();
        rethrow;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Akun Ustadz berhasil dibuat'),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        // Clear form
        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        _selectedSubjects.clear();
        setState(() {
          _isWaliKelas = false;
          _selectedWaliKelasKamar = null;
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Terjadi kesalahan';
      if (e.code == 'weak-password') {
        message = 'Password terlalu lemah';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email sudah digunakan';
      } else if (e.code == 'invalid-email') {
        message = 'Email tidak valid';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFFEF4444),
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
            content: Text('Error: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
            // Info Card
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
                      'Akun Ustadz dapat mengajar beberapa mata pelajaran',
                      style: TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name Field
            _buildTextField(
              controller: _nameController,
              label: 'Nama Lengkap',
              hint: 'Contoh: Ustadz Abdullah',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email Field
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'contoh@email.com',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!value.contains('@')) {
                  return 'Email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password Field
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Minimal 6 karakter',
              icon: Icons.lock,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (value.length < 6) {
                  return 'Password minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Confirm Password Field
            _buildTextField(
              controller: _confirmPasswordController,
              label: 'Konfirmasi Password',
              hint: 'Ulangi password',
              icon: Icons.lock_outline,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi password tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Wali Kelas Section
            Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.school,
                        color: Color(0xFF7C3AED),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Status Wali Kelas',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: _isWaliKelas,
                        onChanged: (value) {
                          setState(() {
                            _isWaliKelas = value;
                            if (!value) _selectedWaliKelasKamar = null;
                          });
                        },
                        activeColor: const Color(0xFF7C3AED),
                      ),
                    ],
                  ),
                  if (_isWaliKelas) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Pilih Kamar yang Diwalikan',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableKamar.map((kamar) {
                        final isSelected = _selectedWaliKelasKamar == kamar;
                        return ChoiceChip(
                          label: Text(kamar),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedWaliKelasKamar = selected ? kamar : null;
                            });
                          },
                          selectedColor: const Color(0xFFEDE9FE),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? const Color(0xFF7C3AED)
                                : const Color(0xFF64748B),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Subjects Selection (Checkboxes)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mata Pelajaran yang Diampu',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
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
                  child: Column(
                    children: _availableSubjects.map((subject) {
                      return CheckboxListTile(
                        title: Text(
                          subject,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        value: _selectedSubjects.contains(subject),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedSubjects.add(subject);
                            } else {
                              _selectedSubjects.remove(subject);
                            }
                          });
                        },
                        activeColor: const Color(0xFF2563EB),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }).toList(),
                  ),
                ),
                if (_selectedSubjects.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 8,
                      children: _selectedSubjects
                          .map(
                            (s) => Chip(
                              label: Text(
                                s,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: const Color(0xFFDEEBFF),
                              labelStyle: const TextStyle(
                                color: Color(0xFF2563EB),
                              ),
                              deleteIconColor: const Color(0xFF2563EB),
                              onDeleted: () {
                                setState(() => _selectedSubjects.remove(s));
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createUstadzAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Buat Akun Ustadz',
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
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
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
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
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
