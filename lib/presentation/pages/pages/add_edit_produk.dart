import 'package:flutter/material.dart';
import 'package:ta_pbo/constants/color_constant.dart';
import 'package:ta_pbo/models/produk_model.dart';

class AddEditProduk extends StatefulWidget {
  final Produk? produk;
  const AddEditProduk({super.key, this.produk});
  @override
  State<AddEditProduk> createState() => _AddEditProdukState();
}

class _AddEditProdukState extends State<AddEditProduk> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _hargaCtrl = TextEditingController();
  final _stokCtrl = TextEditingController();
  final _gambarCtrl = TextEditingController();
  final _extraCtrl = TextEditingController(); // Field Tambahan
  String _selectedKategori = 'Makanan';

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      final p = widget.produk!;
      _namaCtrl.text = p.nama;
      _hargaCtrl.text = p.harga.toString();
      _stokCtrl.text = p.stok.toString();
      _gambarCtrl.text = p.urlGambar;
      _selectedKategori = p.kategori;
      if (p is Makanan) _extraCtrl.text = p.expiredDate;
      if (p is Minuman) _extraCtrl.text = p.ukuran;
      if (p is Elektronik) _extraCtrl.text = p.masaGaransi;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final id =
          widget.produk?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      Produk newItem;
      // Factory Pattern sederhana
      if (_selectedKategori == 'Makanan')
        newItem = Makanan(
            id: id,
            nama: _namaCtrl.text,
            deskripsi: '',
            harga: int.parse(_hargaCtrl.text),
            stok: int.parse(_stokCtrl.text),
            urlGambar: _gambarCtrl.text,
            expiredDate: _extraCtrl.text);
      else if (_selectedKategori == 'Minuman')
        newItem = Minuman(
            id: id,
            nama: _namaCtrl.text,
            deskripsi: '',
            harga: int.parse(_hargaCtrl.text),
            stok: int.parse(_stokCtrl.text),
            urlGambar: _gambarCtrl.text,
            ukuran: _extraCtrl.text);
      else
        newItem = Elektronik(
            id: id,
            nama: _namaCtrl.text,
            deskripsi: '',
            harga: int.parse(_hargaCtrl.text),
            stok: int.parse(_stokCtrl.text),
            urlGambar: _gambarCtrl.text,
            masaGaransi: _extraCtrl.text);

      if (widget.produk == null)
        daftarProduk.add(newItem);
      else {
        final index = daftarProduk.indexWhere((e) => e.id == widget.produk!.id);
        if (index != -1) daftarProduk[index] = newItem;
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String extraLabel = _selectedKategori == 'Makanan'
        ? 'Expired Date'
        : (_selectedKategori == 'Minuman' ? 'Ukuran' : 'Garansi');
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.produk == null ? "Tambah" : "Edit"),
          backgroundColor: ColorConstant.primary),
      body: Form(
          key: _formKey,
          child: ListView(padding: const EdgeInsets.all(20), children: [
            TextFormField(
                controller: _namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama Produk')),
            DropdownButtonFormField(
                value: _selectedKategori,
                items: ['Makanan', 'Minuman', 'Elektronik']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: widget.produk == null
                    ? (v) => setState(() => _selectedKategori = v.toString())
                    : null),
            TextFormField(
                controller: _hargaCtrl,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number),
            TextFormField(
                controller: _stokCtrl,
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number),
            TextFormField(
                controller: _extraCtrl,
                decoration: InputDecoration(labelText: extraLabel)),
            TextFormField(
                controller: _gambarCtrl,
                decoration: const InputDecoration(labelText: 'URL Gambar')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text("SIMPAN"))
          ])),
    );
  }
}
