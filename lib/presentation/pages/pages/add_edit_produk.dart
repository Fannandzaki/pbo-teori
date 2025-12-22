import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// Naik 3 level ke lib/models (sesuai struktur folder-mu)
import '../../../models/produk_model.dart';
// Naik 2 level ke lib/presentation/widget
import '../../widget/input_widget.dart';
import '../../widget/tombol.dart';

class AddEditProdukPage extends StatefulWidget {
  final Produk? produk;
  const AddEditProdukPage({super.key, this.produk});

  @override
  State<AddEditProdukPage> createState() => _AddEditProdukPageState();
}

class _AddEditProdukPageState extends State<AddEditProdukPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _hargaModalController =
      TextEditingController(); // Input Harga Beli
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
      _hargaModalController.text =
          widget.produk!.hargaModal.toString(); // Load Harga Modal
      _stokController.text = widget.produk!.stok.toString();
      _gambarController.text = widget.produk!.urlGambar;

      if (!daftarKategori.contains(widget.produk!.kategori)) {
        daftarKategori.add(widget.produk!.kategori);
      }
      selectedKategori = widget.produk!.kategori;

      if (widget.produk is Makanan) {
        _expDateController.text = (widget.produk as Makanan).expiredDate;
      } else if (widget.produk is Minuman) {
        _ukuranController.text = (widget.produk as Minuman).ukuran;
      } else if (widget.produk is Elektronik) {
        _garansiController.text = (widget.produk as Elektronik).garansi;
      }
    }
  }

  void saveProduk() {
    String nama = _namaController.text;
    int harga = int.tryParse(_hargaController.text) ?? 0;
    int hargaModal =
        int.tryParse(_hargaModalController.text) ?? 0; // Ambil Harga Modal
    int stok = int.tryParse(_stokController.text) ?? 0;
    String gambar = _gambarController.text;
    String id =
        widget.produk?.id ?? "PRD-${DateTime.now().millisecondsSinceEpoch}";

    if (selectedKategori == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pilih kategori!")));
      return;
    }

    Produk produkBaru;

    if (selectedKategori == "Makanan") {
      produkBaru = Makanan(
        id: id,
        nama: nama,
        harga: harga,
        hargaModal: hargaModal,
        stok: stok,
        kategori: selectedKategori!,
        urlGambar: gambar,
        expDate: _expDateController.text,
      );
    } else if (selectedKategori == "Minuman") {
      produkBaru = Minuman(
        id: id,
        nama: nama,
        harga: harga,
        hargaModal: hargaModal,
        stok: stok,
        kategori: selectedKategori!,
        urlGambar: gambar,
        ukuran: _ukuranController.text,
      );
    } else if (selectedKategori == "Elektronik") {
      produkBaru = Elektronik(
        id: id,
        nama: nama,
        harga: harga,
        hargaModal: hargaModal,
        stok: stok,
        kategori: selectedKategori!,
        urlGambar: gambar,
        garansi: _garansiController.text,
      );
    } else {
      produkBaru = Minuman(
        id: id,
        nama: nama,
        harga: harga,
        hargaModal: hargaModal,
        stok: stok,
        kategori: selectedKategori!,
        urlGambar: gambar,
        ukuran: "-",
      );
    }

    if (widget.produk != null) {
      int index = daftarProduk.indexOf(widget.produk!);
      daftarProduk[index] = produkBaru;
    } else {
      daftarProduk.add(produkBaru);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.produk != null ? "Edit Produk" : "Tambah Produk")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InputWidget(hint: "Nama Produk", controller: _namaController),
            const Gap(10),
            DropdownButtonFormField<String>(
              value: selectedKategori,
              decoration: const InputDecoration(
                  labelText: "Kategori", border: OutlineInputBorder()),
              items: daftarKategori.map((String kategori) {
                return DropdownMenuItem<String>(
                    value: kategori, child: Text(kategori));
              }).toList(),
              onChanged: (String? newValue) =>
                  setState(() => selectedKategori = newValue),
            ),
            const Gap(10),
            if (selectedKategori == "Makanan")
              InputWidget(
                  hint: "Expired Date (YYYY-MM-DD)",
                  controller: _expDateController),
            if (selectedKategori == "Minuman")
              InputWidget(
                  hint: "Ukuran (cth: 250ml)", controller: _ukuranController),
            if (selectedKategori == "Elektronik")
              InputWidget(hint: "Masa Garansi", controller: _garansiController),
            const Gap(10),

            // --- HARGA MODAL DAN HARGA JUAL ---
            Row(
              children: [
                Expanded(
                    child: InputWidget(
                        hint: "Harga Modal (Beli)",
                        controller: _hargaModalController,
                        isNumber: true)),
                const Gap(10),
                Expanded(
                    child: InputWidget(
                        hint: "Harga Jual",
                        controller: _hargaController,
                        isNumber: true)),
              ],
            ),

            const Gap(10),
            InputWidget(
                hint: "Stok", controller: _stokController, isNumber: true),
            const Gap(10),
            InputWidget(hint: "URL Gambar", controller: _gambarController),
            const Gap(20),
            Tombol(text: "Simpan", onPressed: saveProduk),
          ],
        ),
      ),
    );
  }
}
