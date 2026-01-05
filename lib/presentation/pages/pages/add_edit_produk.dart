import 'dart:io'; // Import dart:io
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart'; // Pastikan import ini ada untuk styling teks
import 'package:image_picker/image_picker.dart'; // Import Image Picker
import '../../../models/produk_model.dart';
import '../../widget/input_widget.dart';
import '../../widget/produk_image.dart'; // Import Widget Baru
import '../../widget/tombol.dart';

class AddEditProdukPage extends StatefulWidget {
  final Produk? produk;
  final bool isGudang; // Flag akses

  const AddEditProdukPage({super.key, this.produk, this.isGudang = false});

  @override
  State<AddEditProdukPage> createState() => _AddEditProdukPageState();
}

class _AddEditProdukPageState extends State<AddEditProdukPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _hargaModalController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _gambarController = TextEditingController(); // Tetap simpan path sebagai String
  
  // Controller untuk field spesifik
  final TextEditingController _expDateController = TextEditingController();
  final TextEditingController _ukuranController = TextEditingController();
  final TextEditingController _garansiController = TextEditingController();
  
  final TextEditingController _cukaiController = TextEditingController();
  final TextEditingController _jenisAtkController = TextEditingController();
  final TextEditingController _bahanController = TextEditingController();

  String? selectedKategori;

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      _namaController.text = widget.produk!.nama;
      _hargaController.text = widget.produk!.harga.toString();
      _hargaModalController.text = widget.produk!.hargaModal.toString();
      _stokController.text = widget.produk!.stok.toString();
      _gambarController.text = widget.produk!.urlGambar;
      selectedKategori = widget.produk!.kategori;

      if (!daftarKategori.contains(widget.produk!.kategori)) {
        daftarKategori.add(widget.produk!.kategori);
      }
      
      if (widget.produk is Makanan) {
        _expDateController.text = (widget.produk as Makanan).expiredDate;
      } else if (widget.produk is Minuman) {
        _ukuranController.text = (widget.produk as Minuman).ukuran;
      } else if (widget.produk is Elektronik) {
        _garansiController.text = (widget.produk as Elektronik).garansi;
      } else if (widget.produk is Rokok) {
        _cukaiController.text = (widget.produk as Rokok).pitaCukai;
      } else if (widget.produk is AlatTulis) {
        _jenisAtkController.text = (widget.produk as AlatTulis).jenis;
      } else if (widget.produk is PerlengkapanRumah) {
        _bahanController.text = (widget.produk as PerlengkapanRumah).bahan;
      }
    }
  }

  // --- FUNGSI AMBIL GAMBAR ---
  Future<void> _pickImage() async {
    // Jika user gudang, cegah ganti gambar
    if (widget.isGudang) return; 

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _gambarController.text = image.path; // Simpan path file lokal
      });
    }
  }

  void saveProduk() {
    String nama = _namaController.text;
    int harga = int.tryParse(_hargaController.text) ?? 0;
    int hargaModal = int.tryParse(_hargaModalController.text) ?? 0;
    int stok = int.tryParse(_stokController.text) ?? 0;
    String gambar = _gambarController.text;
    String id = widget.produk?.id ?? "PRD-${DateTime.now().millisecondsSinceEpoch}";

    if (selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih kategori!")));
      return;
    }

    Produk produkBaru;

    if (selectedKategori == "Makanan") {
      produkBaru = Makanan(id: id, nama: nama, harga: harga, hargaModal: hargaModal, stok: stok, kategori: selectedKategori!, urlGambar: gambar, expDate: _expDateController.text);
    } else if (selectedKategori == "Minuman") {
      produkBaru = Minuman(id: id, nama: nama, harga: harga, hargaModal: hargaModal, stok: stok, kategori: selectedKategori!, urlGambar: gambar, ukuran: _ukuranController.text);
    } else if (selectedKategori == "Elektronik") {
      produkBaru = Elektronik(id: id, nama: nama, harga: harga, hargaModal: hargaModal, stok: stok, kategori: selectedKategori!, urlGambar: gambar, garansi: _garansiController.text);
    } else if (selectedKategori == "Rokok") {
      produkBaru = Rokok(id: id, nama: nama, harga: harga, hargaModal: hargaModal, stok: stok, kategori: selectedKategori!, urlGambar: gambar, pitaCukai: _cukaiController.text);
    } else if (selectedKategori == "Alat Tulis") {
      produkBaru = AlatTulis(id: id, nama: nama, harga: harga, hargaModal: hargaModal, stok: stok, kategori: selectedKategori!, urlGambar: gambar, jenis: _jenisAtkController.text);
    } else if (selectedKategori == "Perlengkapan Rumah") {
      produkBaru = PerlengkapanRumah(id: id, nama: nama, harga: harga, hargaModal: hargaModal, stok: stok, kategori: selectedKategori!, urlGambar: gambar, bahan: _bahanController.text);
    } else {
      produkBaru = Minuman(id: id, nama: nama, harga: harga, hargaModal: hargaModal, stok: stok, kategori: selectedKategori!, urlGambar: gambar, ukuran: "-");
    }

    setState(() {
      if (widget.produk != null) {
        int index = daftarProduk.indexOf(widget.produk!);
        daftarProduk[index] = produkBaru;
      } else {
        daftarProduk.add(produkBaru);
      }
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.produk != null ? "Edit Produk" : "Tambah Produk")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            InputWidget(hint: "Nama Produk", controller: _namaController, enabled: !widget.isGudang),
            const Gap(16),
            DropdownButtonFormField<String>(
              initialValue: selectedKategori,
              decoration: const InputDecoration(labelText: "Kategori", border: OutlineInputBorder()),
              items: daftarKategori.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
              onChanged: widget.isGudang ? null : (v) => setState(() => selectedKategori = v),
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(child: InputWidget(hint: "Harga Modal", controller: _hargaModalController, isNumber: true, enabled: !widget.isGudang)),
                const Gap(12),
                Expanded(child: InputWidget(hint: "Harga Jual", controller: _hargaController, isNumber: true, enabled: !widget.isGudang)),
              ],
            ),
            const Gap(16),
            InputWidget(hint: "Stok Barang", controller: _stokController, isNumber: true),
            const Gap(16),

            // --- BAGIAN INPUT GAMBAR ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Foto Produk", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            const Gap(8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  // Menggunakan Widget ProductImage
                  child: ProductImage(
                    imagePath: _gambarController.text,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            if (!widget.isGudang)
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt, size: 16),
                label: const Text("Ganti Foto"),
              ),
            // ---------------------------
            
            if (selectedKategori == "Makanan") ...[const Gap(16), InputWidget(hint: "Expired Date", controller: _expDateController, enabled: !widget.isGudang)],
            if (selectedKategori == "Minuman") ...[const Gap(16), InputWidget(hint: "Ukuran", controller: _ukuranController, enabled: !widget.isGudang)],
            if (selectedKategori == "Elektronik") ...[const Gap(16), InputWidget(hint: "Garansi", controller: _garansiController, enabled: !widget.isGudang)],
            if (selectedKategori == "Rokok") ...[const Gap(16), InputWidget(hint: "Tahun Cukai", controller: _cukaiController, enabled: !widget.isGudang)],
            if (selectedKategori == "Alat Tulis") ...[const Gap(16), InputWidget(hint: "Jenis (Buku/Pena)", controller: _jenisAtkController, enabled: !widget.isGudang)],
            if (selectedKategori == "Perlengkapan Rumah") ...[const Gap(16), InputWidget(hint: "Bahan Material", controller: _bahanController, enabled: !widget.isGudang)],

            const Gap(30),
            Tombol(text: "Simpan Data", isFullwidth: true, onPressed: saveProduk),
          ],
        ),
      ),
    );
  }
}