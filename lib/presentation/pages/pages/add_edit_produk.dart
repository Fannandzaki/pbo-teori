// lib/presentation/pages/pages/add_edit_produk.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../models/produk_model.dart';
import '../../widget/input_widget.dart';
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
  final TextEditingController _gambarController = TextEditingController();
  final TextEditingController _expDateController = TextEditingController();
  final TextEditingController _ukuranController = TextEditingController();
  final TextEditingController _garansiController = TextEditingController();

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

      // Handle data khusus
      if (!daftarKategori.contains(widget.produk!.kategori)) {
        daftarKategori.add(widget.produk!.kategori);
      }
      
      if (widget.produk is Makanan) _expDateController.text = (widget.produk as Makanan).expiredDate;
      else if (widget.produk is Minuman) _ukuranController.text = (widget.produk as Minuman).ukuran;
      else if (widget.produk is Elektronik) _garansiController.text = (widget.produk as Elektronik).garansi;
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
            // Jika Gudang, nama produk dikunci
            InputWidget(hint: "Nama Produk", controller: _namaController, enabled: !widget.isGudang),
            const Gap(16),
            DropdownButtonFormField<String>(
              value: selectedKategori,
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
            // Stok selalu bisa diedit (Gudang & Juragan)
            InputWidget(hint: "Stok Barang", controller: _stokController, isNumber: true),
            const Gap(16),
            InputWidget(hint: "URL Gambar", controller: _gambarController, enabled: !widget.isGudang),
            
            // Kolom Khusus
            if (selectedKategori == "Makanan") ...[const Gap(16), InputWidget(hint: "Expired Date", controller: _expDateController, enabled: !widget.isGudang)],
            if (selectedKategori == "Minuman") ...[const Gap(16), InputWidget(hint: "Ukuran", controller: _ukuranController, enabled: !widget.isGudang)],
            if (selectedKategori == "Elektronik") ...[const Gap(16), InputWidget(hint: "Garansi", controller: _garansiController, enabled: !widget.isGudang)],
            
            const Gap(30),
            Tombol(text: "Simpan Data", isFullwidth: true, onPressed: saveProduk),
          ],
        ),
      ),
    );
  }
}