import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/user_entity.dart';
import '../../widgets/modern_text_field.dart';
import '../../widgets/primary_button.dart';

// Mock Provider for Ustadz List (In real app, this would be a repository)
final ustadzListProvider = StateProvider<List<UserEntity>>(
  (ref) => [
    const UserEntity(
      uid: '1',
      email: 'ustadz1@pesantren.com',
      name: 'Ustadz Abdullah',
      role: 'ustadz',
    ),
    const UserEntity(
      uid: '2',
      email: 'ustadz2@pesantren.com',
      name: 'Ustadz Budi',
      role: 'ustadz',
    ),
  ],
);

class UstadzManagementScreen extends ConsumerStatefulWidget {
  const UstadzManagementScreen({super.key});

  @override
  ConsumerState<UstadzManagementScreen> createState() =>
      _UstadzManagementScreenState();
}

class _UstadzManagementScreenState
    extends ConsumerState<UstadzManagementScreen> {
  void _showAddEditDialog([UserEntity? ustadz]) {
    showDialog(
      context: context,
      builder: (context) => _AddEditUstadzDialog(ustadz: ustadz),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ustadzList = ref.watch(ustadzListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Ustadz')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ustadzList.length,
        itemBuilder: (context, index) {
          final ustadz = ustadzList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryTeal.withOpacity(0.1),
                child: Text(ustadz.name[0]),
              ),
              title: Text(
                ustadz.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(ustadz.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showAddEditDialog(ustadz),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Delete logic
                      ref
                          .read(ustadzListProvider.notifier)
                          .update(
                            (state) => state
                                .where((u) => u.uid != ustadz.uid)
                                .toList(),
                          );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddEditUstadzDialog extends ConsumerStatefulWidget {
  final UserEntity? ustadz;

  const _AddEditUstadzDialog({this.ustadz});

  @override
  ConsumerState<_AddEditUstadzDialog> createState() =>
      _AddEditUstadzDialogState();
}

class _AddEditUstadzDialogState extends ConsumerState<_AddEditUstadzDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.ustadz?.name ?? '');
    _emailCtrl = TextEditingController(text: widget.ustadz?.email ?? '');
    _passwordCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newUser = UserEntity(
        uid:
            widget.ustadz?.uid ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        role: 'ustadz',
      );

      if (widget.ustadz == null) {
        ref
            .read(ustadzListProvider.notifier)
            .update((state) => [...state, newUser]);
      } else {
        ref
            .read(ustadzListProvider.notifier)
            .update(
              (state) =>
                  state.map((u) => u.uid == newUser.uid ? newUser : u).toList(),
            );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.ustadz == null ? 'Tambah Ustadz' : 'Edit Ustadz',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              ModernTextField(
                label: 'Nama Lengkap',
                controller: _nameCtrl,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              ModernTextField(
                label: 'Email',
                controller: _emailCtrl,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              if (widget.ustadz == null) ...[
                const SizedBox(height: 16),
                ModernTextField(
                  label: 'Password',
                  controller: _passwordCtrl,
                  isPassword: true,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
              ],
              const SizedBox(height: 32),
              PrimaryButton(text: 'SIMPAN', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
