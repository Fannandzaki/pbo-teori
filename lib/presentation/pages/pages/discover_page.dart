import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ta_pbo/constants/color_constant.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  // 1. Data Dummy sekarang punya field 'Stock'
  final List<Map<String, dynamic>> BarangList = [
    {'Name': 'Kecap Manis', 'Price': '15000', 'Stock': '50'},
    {
      'Name': 'Sabun Cuci',
      'Price': '23000',
      'Stock': '5'
    }, // Stok sedikit contohnya
    {'Name': 'Minyak Goreng', 'Price': '35000', 'Stock': '120'},
  ];

  final TextEditingController NameController = TextEditingController();
  final TextEditingController PriceController = TextEditingController();
  final TextEditingController StockController =
      TextEditingController(); // Controller baru

  void AddBarang() {
    // Validasi input harus lengkap
    if (NameController.text.isEmpty ||
        PriceController.text.isEmpty ||
        StockController.text.isEmpty) return;

    setState(() {
      BarangList.add({
        'Name': NameController.text,
        'Price': PriceController.text,
        'Stock': StockController.text, // Simpan stok
      });
    });
    _clearControllers();
    Navigator.of(context).pop();
  }

  void EditBarang(int index) {
    NameController.text = BarangList[index]['Name'];
    PriceController.text = BarangList[index]['Price'];
    StockController.text = BarangList[index]['Stock']; // Isi stok saat edit

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) {
          return BuildInputForm(() {
            if (NameController.text.isEmpty ||
                PriceController.text.isEmpty ||
                StockController.text.isEmpty) return;

            setState(() {
              BarangList[index] = {
                'Name': NameController.text,
                'Price': PriceController.text,
                'Stock': StockController.text,
              };
            });
            _clearControllers();
            Navigator.of(context).pop();
          }, "Edit Barang");
        });
  }

  void DeleteBarang(int index) {
    setState(() {
      BarangList.removeAt(index);
    });
  }

  void ShowAddBarangModal() {
    _clearControllers(); // Pastikan bersih saat mau tambah baru
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) {
          return BuildInputForm(AddBarang, "Tambah");
        });
  }

  void _clearControllers() {
    NameController.clear();
    PriceController.clear();
    StockController.clear();
  }

  Widget BuildInputForm(VoidCallback onSave, String action) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 30,
          left: 24,
          right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$action Barang',
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Input Nama
          TextField(
            controller: NameController,
            decoration: InputDecoration(
              labelText: 'Nama Barang',
              prefixIcon: const Icon(Icons.label_outline),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),

          // Row untuk Harga dan Stok agar sejajar (hemat tempat)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: PriceController,
                  decoration: InputDecoration(
                    labelText: 'Harga (Rp)',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: StockController,
                  decoration: InputDecoration(
                    labelText: 'Stok Awal',
                    prefixIcon: const Icon(Icons.inventory_2_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Simpan Data",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      appBar: AppBar(
        title: Text('Inventory Gudang', // Judul disesuaikan tema Admin
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Hilangkan tombol back default
        actions: [
          // Tombol Logout kecil di pojok kanan
          IconButton(
              onPressed: () {
                Navigator.of(context).pop(); // Keluar ke login
              },
              icon: Icon(Icons.logout, color: Colors.red[300]))
        ],
      ),
      body: BarangList.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('Gudang kosong,\nmulai stok barang sekarang!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: Colors.grey)),
              ],
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: BarangList.length,
              itemBuilder: (context, index) {
                // Konversi stok ke integer untuk cek logika warna
                int stockVal =
                    int.tryParse(BarangList[index]['Stock'].toString()) ?? 0;
                bool isLowStock = stockVal < 10;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
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
                  child: Row(
                    children: [
                      // Icon Box
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isLowStock
                              ? Colors.red
                                  .withOpacity(0.1) // Merah jika stok sedikit
                              : ColorConstant.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.inventory_2,
                            color: isLowStock
                                ? Colors.red
                                : ColorConstant.primary),
                      ),
                      const SizedBox(width: 16),

                      // Info Barang
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              BarangList[index]['Name'],
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstant.textTitle),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Rp ${BarangList[index]['Price']}",
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600]), // Harga warna abu
                            ),
                            const SizedBox(height: 4),
                            // Tampilan Stok
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                  color: isLowStock ? Colors.red : Colors.green,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                "Stok: ${BarangList[index]['Stock']} pcs",
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),

                      // Tombol Aksi
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: Colors.grey),
                            onPressed: () => EditBarang(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () => DeleteBarang(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: ShowAddBarangModal,
        backgroundColor: ColorConstant.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
