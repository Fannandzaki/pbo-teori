import 'package:flutter/material.dart';
import 'package:ta_pbo/constants/color_constant.dart';
import 'package:ta_pbo/models/produk_model.dart';
import 'package:ta_pbo/presentation/pages/pages/login.dart';

class UserShopPage extends StatefulWidget {
  const UserShopPage({super.key});
  @override
  State<UserShopPage> createState() => _UserShopPageState();
}

class _UserShopPageState extends State<UserShopPage> {
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  final List<String> _categories = [
    'Semua',
    'Makanan',
    'Minuman',
    'Elektronik'
  ];

  List<Produk> get _filteredItems {
    return daftarProduk.where((item) {
      final matchesSearch =
          item.nama.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'Semua' || item.kategori == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _beliBarang(Produk item) {
    if (item.stok > 0) {
      setState(() {
        item.stok--;
      }); // Kurangi Stok
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text("Berhasil Membeli"),
                content:
                    Text("Anda membeli ${item.nama}.\nSisa Stok: ${item.stok}"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"))
                ],
              ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Stok Habis!"), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SMART Shop"), actions: [
        IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const Login()))),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                decoration: InputDecoration(
                    hintText: 'Cari barang...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                onChanged: (val) => setState(() => _searchQuery = val)),
            const SizedBox(height: 10),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: _categories
                        .map((cat) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                                label: Text(cat),
                                selected: _selectedCategory == cat,
                                onSelected: (b) =>
                                    setState(() => _selectedCategory = cat))))
                        .toList())),
            const SizedBox(height: 10),
            Expanded(
                child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return Card(
                    child: Column(children: [
                  Expanded(
                      child: Image.network(item.urlGambar,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image))),
                  Text(item.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Rp ${item.harga}",
                      style: TextStyle(color: ColorConstant.primary)),
                  Text("Stok: ${item.stok}",
                      style: TextStyle(
                          color: item.stok < 5 ? Colors.red : Colors.green)),
                  ElevatedButton(
                      onPressed: item.stok > 0 ? () => _beliBarang(item) : null,
                      child: const Text("Beli"))
                ]));
              },
            ))
          ],
        ),
      ),
    );
  }
}
