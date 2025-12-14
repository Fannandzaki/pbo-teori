import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ta_pbo/constants/color_constant.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  // Data dummy awal biar tidak kosong banget saat pertama buka
  final List<Map<String, dynamic>> BarangList = [
    {'Name': 'Kecap Manis', 'Price': '15000'},
    {'Name': 'Sabun Cuci', 'Price': '23000'},
  ];

  final TextEditingController NameController = TextEditingController();
  final TextEditingController PriceController = TextEditingController();

  void AddBarang() {
    if (NameController.text.isEmpty || PriceController.text.isEmpty) return;
    setState(() {
      BarangList.add({
        'Name': NameController.text,
        'Price': PriceController.text,
      });
    });
    NameController.clear();
    PriceController.clear();
    Navigator.of(context).pop();
  }

  void EditBarang(int index) {
    NameController.text = BarangList[index]['Name'];
    PriceController.text = BarangList[index]['Price'];
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Agar keyboard tidak menutupi
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) {
          return BuildInputForm(() {
            if (NameController.text.isEmpty || PriceController.text.isEmpty)
              return;
            setState(() {
              BarangList[index] = {
                'Name': NameController.text,
                'Price': PriceController.text,
              };
            });
            NameController.clear();
            PriceController.clear();
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
          TextField(
            controller: NameController,
            decoration: InputDecoration(
              labelText: 'Nama Barang',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: PriceController,
            decoration: InputDecoration(
              labelText: 'Harga Barang (Rp)',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            keyboardType: TextInputType.number,
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
              child: Text("Simpan",
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
      backgroundColor: ColorConstant.background, // Background abu muda
      appBar: AppBar(
        title: Text('Toko Barang',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BarangList.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('Belum ada barang,\ntambahkan yuk!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: Colors.grey)),
              ],
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: BarangList.length,
              itemBuilder: (context, index) {
                // Tampilan CARD yang lebih bagus
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
                      // Icon/Gambar Placeholder
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: ColorConstant.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.shopping_bag,
                            color: ColorConstant.primary),
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
                                  color: ColorConstant.primary),
                            ),
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
