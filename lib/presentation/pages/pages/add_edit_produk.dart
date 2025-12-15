import 'package:flutter/material.dart';
import 'package:ta_pbo/constants/color_constant.dart';
import 'package:ta_pbo/models/produk_model.dart';

class AddEditProduk extends StatefulWidget {
  final Produk? produk; // Menerima Parent Class

  const AddEditProduk({super.key, this.produk});

  @override
  State<AddEditProduk> createState() => _AddEditProdukState();
}

class _AddEditProdukState extends State<AddEditProduk> {
  final _formKey = GlobalKey<FormState>();

  // Controller Field Umum
  final _idController = TextEditingController();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _urlGambarController = TextEditingController();
  
  // Controller Field Khusus (Kita pakai satu controller dinamis untuk atribut unik)
  final _atributKhususController = TextEditingController();

  String _selectedKategori = 'Makanan'; // Default
  final List<String> _kategoriOptions = ['Makanan', 'Minuman', 'Elektronik'];

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      // MODE EDIT: Isi data lama
      final p = widget.produk!;
      _idController.text = p.id;
      _namaController.text = p.nama;
      _deskripsiController.text = p.deskripsi;
      _hargaController.text = p.harga.toString();
      _stokController.text = p.stok.toString();
      _urlGambarController.text = p.urlGambar;
      _selectedKategori = p.kategori;

      // Cek Tipe Child Class untuk mengisi atribut khusus
      if (p is Makanan) {
        _atributKhususController.text = p.expiredDate;
      } else if (p is Minuman) {
        _atributKhususController.text = p.ukuran;
      } else if (p is Elektronik) {
        _atributKhususController.text = p.masaGaransi;
      }
    }
  }

  void _saveProduk() {
    if (_formKey.currentState!.validate()) {
      Produk produkBaru;

      // 1. Tentukan Child Class apa yang akan dibuat berdasarkan Kategori
      if (_selectedKategori == 'Makanan') {
        produkBaru = Makanan(
          id: _idController.text,
          nama: _namaController.text,
          deskripsi: _deskripsiController.text,
          harga: int.parse(_hargaController.text),
          stok: int.parse(_stokController.text),
          urlGambar: _urlGambarController.text,
          expiredDate: _atributKhususController.text,
        );
      } else if (_selectedKategori == 'Minuman') {
        produkBaru = Minuman(
          id: _idController.text,
          nama: _namaController.text,
          deskripsi: _deskripsiController.text,
          harga: int.parse(_hargaController.text),
          stok: int.parse(_stokController.text),
          urlGambar: _urlGambarController.text,
          ukuran: _atributKhususController.text,
        );
      } else {
        produkBaru = Elektronik(
          id: _idController.text,
          nama: _namaController.text,
          deskripsi: _deskripsiController.text,
          harga: int.parse(_hargaController.text),
          stok: int.parse(_stokController.text),
          urlGambar: _urlGambarController.text,
          masaGaransi: _atributKhususController.text,
        );
      }

      // 2. Simpan ke List Global
      if (widget.produk == null) {
        // Mode Tambah
        daftarProduk.add(produkBaru);
      } else {
        // Mode Edit (Cari index data lama, lalu replace dengan object baru)
        int index = daftarProduk.indexOf(widget.produk!);
        if (index != -1) {
          daftarProduk[index] = produkBaru;
        }
      }

      Navigator.pop(context); // Tutup Dialog
    }
  }

  // Label atribut khusus berubah sesuai kategori
  String get _labelAtributKhusus {
    switch (_selectedKategori) {
      case 'Makanan': return 'Expired Date (Contoh: 20-12-2025)';
      case 'Minuman': return 'Ukuran (Contoh: 500 ml)';
      case 'Elektronik': return 'Masa Garansi (Contoh: 1 Tahun)';
      default: return 'Keterangan Tambahan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.produk == null ? 'Tambah Produk' : 'Edit Produk',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          
          // FORM SCROLLABLE
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pilihan Kategori (Dropdown)
                    _buildLabel("Kategori Produk"),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedKategori,
                          isExpanded: true,
                          items: _kategoriOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedKategori = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel("ID Produk"),
                    _buildTextField(controller: _idController, hint: "M01", icon: Icons.qr_code),
                    const SizedBox(height: 16),

                    _buildLabel("Nama Produk"),
                    _buildTextField(controller: _namaController, hint: "Nama Barang", icon: Icons.inventory),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                             _buildLabel("Harga (Rp)"),
                             _buildTextField(controller: _hargaController, hint: "0", icon: Icons.attach_money, isNumber: true),
                          ]),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                             _buildLabel("Stok"),
                             _buildTextField(controller: _stokController, hint: "0", icon: Icons.numbers, isNumber: true),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // FIELD KHUSUS (Berubah label sesuai kategori)
                    _buildLabel(_labelAtributKhusus),
                    _buildTextField(controller: _atributKhususController, hint: "Isi sesuai kategori...", icon: Icons.info_outline),
                    const SizedBox(height: 16),

                    _buildLabel("URL Gambar"),
                    _buildTextField(controller: _urlGambarController, hint: "https://...", icon: Icons.image),
                    const SizedBox(height: 16),
                    
                    _buildLabel("Deskripsi"),
                    _buildTextField(controller: _deskripsiController, hint: "Deskripsi singkat...", icon: Icons.description, maxLines: 3),
                  ],
                ),
              ),
            ),
          ),

          // TOMBOL SIMPAN
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveProduk,
                child: const Text('Simpan Data', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: (val) => val!.isEmpty ? 'Harus diisi' : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}