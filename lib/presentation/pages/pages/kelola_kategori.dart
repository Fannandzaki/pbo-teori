// lib/presentation/pages/pages/kelola_kategori.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../../../models/produk_model.dart'; // Import ini penting

class KelolaKategoriPage extends StatefulWidget {
  const KelolaKategoriPage({super.key});

  @override
  State<KelolaKategoriPage> createState() => _KelolaKategoriPageState();
}

class _KelolaKategoriPageState extends State<KelolaKategoriPage> {
  final TextEditingController _kategoriController = TextEditingController();

  void tambahKategori() {
    String baru = _kategoriController.text.trim();
    if (baru.isNotEmpty) {
      // Cek agar tidak ada duplikat
      if (!daftarKategori.contains(baru)) {
        setState(() {
          daftarKategori.add(baru);
        });
        _kategoriController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kategori '$baru' berhasil ditambahkan")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kategori sudah ada!")),
        );
      }
    }
  }

  void hapusKategori(String kategori) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Kategori"),
        content: Text("Yakin hapus kategori '$kategori'?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              setState(() {
                daftarKategori.remove(kategori);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Kategori")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _kategoriController,
                    decoration: const InputDecoration(
                      labelText: "Nama Kategori Baru",
                      border: OutlineInputBorder(),
                      hintText: "Contoh: Sembako, Obat, dll",
                    ),
                  ),
                ),
                const Gap(10),
                ElevatedButton(
                  onPressed: tambahKategori,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const Gap(20),
            const Divider(),

            // List Kategori
            Expanded(
              child: ListView.builder(
                itemCount: daftarKategori.length,
                itemBuilder: (context, index) {
                  final kategori = daftarKategori[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.label, color: Colors.blue),
                      title: Text(kategori,
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w500)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => hapusKategori(kategori),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
