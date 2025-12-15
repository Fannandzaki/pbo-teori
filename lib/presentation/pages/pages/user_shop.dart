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
  // --- STATE FILTER KATEGORI ---
  String _selectedCategory = 'Semua'; // Default tampilkan semua
  final List<String> _categories = ['Semua', 'Makanan', 'Minuman', 'Elektronik'];

  // --- LOGIKA PROGRAM (BELI) ---
  void _beliProduk(Produk item) {
    if (item.stok > 0) {
      setState(() {
        item.stok--; 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil membeli ${item.nama}!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stok habis!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // LOGIKA FILTER: Saring list berdasarkan kategori yang dipilih
    final List<Produk> filteredList = _selectedCategory == 'Semua'
        ? daftarProduk
        : daftarProduk.where((item) => item.kategori == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Katalog Produk',
          style: TextStyle(
            color: ColorConstant.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded, color: ColorConstant.primary),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Login()),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. BANNER SAPAAN
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mau belanja apa hari ini? 🛍️",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                // 2. TOMBOL FILTER KATEGORI (CHIPS)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          // Styling Chip agar modern
                          selectedColor: ColorConstant.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? Colors.transparent : Colors.grey[300]!,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // 3. GRID PRODUK (YANG SUDAH DI-FILTER)
          Expanded(
            child: filteredList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text("Tidak ada produk di kategori ini", style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return _buildProductCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET KARTU PRODUK (SAMA SEPERTI SEBELUMNYA) ---
  Widget _buildProductCard(Produk item) {
    return GestureDetector(
      onTap: () => _showDetailDialog(item),
      child: Container(
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
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Hero(
                  tag: item.id,
                  child: Image.network(
                    item.urlGambar,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[100],
                      child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nama,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rp ${item.harga}",
                    style: TextStyle(color: ColorConstant.primary, fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item.stok > 0 ? ColorConstant.primary : Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: item.stok > 0 ? () => _beliProduk(item) : null,
                      child: Text(
                        item.stok > 0 ? "Beli" : "Habis",
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- POPUP DETAIL (SAMA SEPERTI SEBELUMNYA) ---
  void _showDetailDialog(Produk item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(item.urlGambar, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (_,__,___)=> const Icon(Icons.image)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.nama, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Rp ${item.harga}", style: TextStyle(fontSize: 16, color: ColorConstant.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _buildDetailRow("Kategori", item.kategori),
              _buildDetailRow("Stok", "${item.stok}"),
              _buildDetailRow("Deskripsi", item.deskripsi),
              
              if (item is Makanan) _buildDetailRow("Expired", item.expiredDate),
              if (item is Minuman) _buildDetailRow("Ukuran", item.ukuran),
              if (item is Elektronik) _buildDetailRow("Garansi", item.masaGaransi),
              
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.stok > 0 ? ColorConstant.primary : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: item.stok > 0 ? () {
                    Navigator.pop(context);
                    _beliProduk(item);
                  } : null,
                  child: const Text("Beli Sekarang", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87))),
        ],
      ),
    );
  }
}