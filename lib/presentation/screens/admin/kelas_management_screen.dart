import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/modern_text_field.dart';
import '../../widgets/primary_button.dart';

// Mock Provider for Kelas List
final kelasListProvider = StateProvider<List<String>>(
  (ref) => ['Kelas 1A', 'Kelas 1B', 'Kelas 2A', 'Kelas 2B'],
);

class KelasManagementScreen extends ConsumerWidget {
  const KelasManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kelasList = ref.watch(kelasListProvider);
    final textCtrl = TextEditingController();

    void addKelas() {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tambah Kelas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ModernTextField(label: 'Nama Kelas', controller: textCtrl),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'SIMPAN',
                  onPressed: () {
                    if (textCtrl.text.isNotEmpty) {
                      ref
                          .read(kelasListProvider.notifier)
                          .update((state) => [...state, textCtrl.text]);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        title: const Text('Manajemen Kelas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addKelas,
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: kelasList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.class_, color: Color(0xFF2563EB)),
              title: Text(kelasList[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  ref
                      .read(kelasListProvider.notifier)
                      .update(
                        (state) =>
                            state.where((k) => k != kelasList[index]).toList(),
                      );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
