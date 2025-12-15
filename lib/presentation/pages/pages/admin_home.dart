import 'package:flutter/material.dart';
import 'package:ta_pbo/constants/color_constant.dart';
import 'package:ta_pbo/models/produk_model.dart'; // Pastikan import ini benar
import 'package:ta_pbo/presentation/pages/pages/add_edit_produk.dart';
import 'package:ta_pbo/presentation/pages/pages/login.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // --- LOGIKA UTAMA ---
  void _refresh() => setState(() {});

  void _deleteItem(int index) {
    setState(() {
      daftarProduk.removeAt(index);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Barang dihapus')));
  }

  // Fungsi Pop-up Dialog
  Future<void> _openFormDialog({Produk? produk}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 700), // Sedikit lebih tinggi
              child: AddEditProduk(produk: produk),
            ),
          ),
        );
      },
    );
    _refresh();
  }
  // --------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Admin Dashboard',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        backgroundColor: ColorConstant.primary,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const Login())),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorConstant.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Tambah", style: TextStyle(color: Colors.white)),
        onPressed: () => _openFormDialog(),
      ),
      body: daftarProduk.isEmpty
          ? Center(
              child: Text("Belum ada produk",
                  style: TextStyle(color: Colors.grey[600])))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 80),
              itemCount: daftarProduk.length,
              itemBuilder: (context, index) {
                // Ambil item sebagai Parent Class (Produk)
                final Produk item = daftarProduk[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Image.network(
                              item.urlGambar,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Info Produk
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.nama,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              
                              // Menampilkan Harga (Format Rupiah sederhana)
                              Text("Rp ${item.harga}", 
                                  style: TextStyle(color: ColorConstant.primary, fontWeight: FontWeight.bold)),
                              
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  // Badge Kategori
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(item.kategori, style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('Stok: ${item.stok}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Tombol Aksi
                        Column(
                          children: [
                            _actionButton(Icons.edit_rounded, Colors.blue,
                                () => _openFormDialog(produk: item)),
                            const SizedBox(height: 8),
                            _actionButton(Icons.delete_outline_rounded, Colors.red,
                                () => _deleteItem(index)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}