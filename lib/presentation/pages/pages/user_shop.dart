// lib/presentation/pages/pages/user_shop.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../models/produk_model.dart';
import '../../../models/user_model.dart';
import '../../../models/transaksi_model.dart';
import 'login.dart';

class UserShopPage extends StatefulWidget {
  final String namaKasir;
  const UserShopPage({super.key, this.namaKasir = "Kasir"});

  @override
  State<UserShopPage> createState() => _UserShopPageState();
}

class _UserShopPageState extends State<UserShopPage> {
  Customer currentPelanggan = Customer(
    id: "TRX", username: "Umum", password: "", alamat: "-", noHp: "-", saldo: 0,
  );

  final TextEditingController _namaPembeliController = TextEditingController();
  final TextEditingController _alamatPembeliController = TextEditingController();
  Map<Produk, int> keranjang = {};

  void tambahKeKeranjang(Produk produk) {
    if (produk.stok <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Stok Habis!"), backgroundColor: Colors.red));
      return;
    }
    setState(() {
      if (keranjang.containsKey(produk)) {
        if (keranjang[produk]! < produk.stok) {
          keranjang[produk] = keranjang[produk]! + 1;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Stok tidak cukup!")));
        }
      } else {
        keranjang[produk] = 1;
      }
    });
  }

  void kurangiDariKeranjang(Produk produk) {
    setState(() {
      if (keranjang.containsKey(produk)) {
        if (keranjang[produk]! > 1) {
          keranjang[produk] = keranjang[produk]! - 1;
        } else {
          keranjang.remove(produk);
        }
      }
    });
  }

  double hitungTotalKeranjang() {
    double total = 0;
    keranjang.forEach((produk, qty) {
      total += (produk.harga * qty);
    });
    return total;
  }

  // MODIFIKASI: Tambah Date Picker
  void showInputDataDialog() {
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Checkout & Tanggal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _namaPembeliController, decoration: const InputDecoration(labelText: "Nama Pembeli")),
              TextField(controller: _alamatPembeliController, decoration: const InputDecoration(labelText: "Alamat (Opsional)")),
              const Gap(10),
              // Input Tanggal
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Tanggal Transaksi"),
                subtitle: Text("${selectedDate.day}-${selectedDate.month}-${selectedDate.year}"),
                trailing: const Icon(Icons.calendar_month, color: Colors.blue),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setDialogState(() => selectedDate = picked);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentPelanggan = Customer(
                    id: "TRX",
                    username: _namaPembeliController.text.isEmpty ? "Umum" : _namaPembeliController.text,
                    password: "",
                    alamat: _alamatPembeliController.text,
                    noHp: "-",
                    saldo: 0
                  );
                });
                Navigator.pop(context);
                prosesPembayaran(selectedDate); // Kirim tanggal
              },
              child: const Text("Bayar"),
            ),
          ],
        ),
      ),
    );
  }

  void prosesPembayaran(DateTime tglTransaksi) {
    double totalBelanja = hitungTotalKeranjang();
    if (totalBelanja <= 0) return;

    List<Map<String, dynamic>> itemsBeli = [];
    keranjang.forEach((produk, qty) {
      if (produk.stok >= qty) produk.stok -= qty;
      itemsBeli.add({'produk': produk, 'qty': qty});
    });

    Transaksi trx = Transaksi(
      idTransaksi: "TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
      tgl: tglTransaksi, // Gunakan tanggal inputan
      total: totalBelanja,
      items: itemsBeli,
    );

    riwayatTransaksi.add(trx);
    _showStrukDialog(trx);
    setState(() => keranjang.clear());
  }

  void _showStrukDialog(Transaksi trx) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("STRUK BELANJA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Divider(),
              Text("Kasir: ${widget.namaKasir}"),
              Text("Pembeli: ${currentPelanggan.username}"),
              Text("Tgl: ${trx.tgl.day}/${trx.tgl.month}/${trx.tgl.year}"),
              const Divider(),
              ...trx.items.map((item) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item['produk'].nama} x${item['qty']}"),
                      Text("Rp ${item['produk'].harga * item['qty']}"),
                    ],
                  )),
              const Divider(),
              Text("TOTAL: Rp ${trx.total.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold)),
              const Gap(20),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup"))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Kasir: ${widget.namaKasir}"),
          backgroundColor: Colors.indigo,
          actions: [
            IconButton(icon: const Icon(Icons.logout), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const Login())))
          ]),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.shopping_cart),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (ctx) => Container(
                      padding: const EdgeInsets.all(16),
                      height: 400,
                      child: Column(children: [
                        const Text("Keranjang", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ListView(
                              children: keranjang.entries.map((e) => ListTile(
                                        title: Text(e.key.nama),
                                        subtitle: Text("Qty: ${e.value}"),
                                        trailing: IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              kurangiDariKeranjang(e.key);
                                              Navigator.pop(ctx);
                                              setState(() {});
                                            }),
                                      )).toList()),
                        ),
                        ElevatedButton(
                            onPressed: keranjang.isEmpty ? null : () { Navigator.pop(ctx); showInputDataDialog(); },
                            child: const Text("Checkout"))
                      ]),
                    ));
          }),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: daftarProduk.length,
        itemBuilder: (context, index) {
          final p = daftarProduk[index];
          return Card(
            child: ListTile(
              leading: Image.network(p.urlGambar, width: 50, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
              title: Text(p.nama),
              subtitle: Text("Stok: ${p.stok} | Rp ${p.harga}"),
              trailing: ElevatedButton(
                onPressed: p.stok > 0 ? () => tambahKeKeranjang(p) : null,
                child: Text(p.stok > 0 ? "Beli" : "Habis"),
              ),
            ),
          );
        },
      ),
    );
  }
}