import 'package:flutter/material.dart';
import 'package:ta_pbo/constants/color_constant.dart';
import 'package:ta_pbo/models/produk_model.dart';
import 'package:ta_pbo/presentation/pages/pages/add_edit_produk.dart'; // File langkah 5
import 'package:ta_pbo/presentation/pages/pages/login.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  void _refresh() => setState(() {}); // Fungsi refresh tampilan

  void _deleteItem(int index) {
    setState(() {
      daftarProduk.removeAt(index);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Barang dihapus')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard',
            style: TextStyle(color: Colors.white)),
        backgroundColor: ColorConstant.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const Login())),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstant.primary,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddEditProduk()));
          _refresh();
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: daftarProduk.length,
        itemBuilder: (context, index) {
          final item = daftarProduk[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Image.network(item.urlGambar,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image)),
              title: Text(item.nama,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${item.kategori} | Stok: ${item.stok}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddEditProduk(produk: item)));
                      _refresh();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(index),
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
