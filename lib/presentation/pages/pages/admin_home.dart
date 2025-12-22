import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../../../models/produk_model.dart';
import '../../../models/transaksi_model.dart';
import 'add_edit_produk.dart';
import 'login.dart';
import 'kelola_kategori.dart';

class AdminHomePage extends StatefulWidget {
  final String role; // 'owner' atau 'gudang'
  const AdminHomePage({super.key, required this.role});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // Data Pegawai Dummy
  List<Map<String, String>> daftarPegawai = [
    {"nama": "Fannan", "posisi": "Kasir", "status": "Aktif"},
    {"nama": "Admin Gudang", "posisi": "Logistik", "status": "Aktif"},
  ];

  // Fungsi Hapus Produk (Hanya Gudang yang bersih-bersih data)
  void deleteProduk(Produk produk) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Produk?"),
        content: Text("Yakin hapus ${produk.nama}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              setState(() {
                daftarProduk.remove(produk);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  // Fungsi Pecat Pegawai (Hak Prerogatif Juragan)
  void pecatPegawai(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("PHK Pegawai"),
        content: Text("Pecat ${daftarPegawai[index]['nama']}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                daftarPegawai.removeAt(index);
              });
              Navigator.pop(ctx);
            },
            child:
                const Text("Ya, Pecat", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  double hitungTotalAset() {
    double total = 0;
    for (var p in daftarProduk) {
      total += (p.hargaModal * p.stok);
    }
    return total;
  }

  double hitungTotalProfit() {
    double total = 0;
    for (var trx in riwayatTransaksi) {
      total += trx.hitungProfit();
    }
    return total;
  }

  void handleLogout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    bool isOwner = widget.role == 'owner';

    return DefaultTabController(
      // Juragan punya 3 Tab, Gudang cuma 1 tampilan
      length: isOwner ? 3 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isOwner ? "Dashboard Juragan" : "Manajemen Gudang"),
          backgroundColor: isOwner ? Colors.purple[100] : Colors.blue[100],
          bottom: isOwner
              ? const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.analytics), text: "Laporan"),
                    Tab(icon: Icon(Icons.people), text: "Pegawai"),
                    Tab(
                        icon: Icon(Icons.price_change),
                        text: "Atur Harga"), // TAB KHUSUS JURAGAN
                  ],
                )
              : null,
          actions: [
            if (!isOwner)
              IconButton(
                icon: const Icon(Icons.category),
                tooltip: "Kelola Kategori",
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => const KelolaKategoriPage())),
              ),
            IconButton(icon: const Icon(Icons.logout), onPressed: handleLogout),
          ],
        ),

        body: isOwner
            ? TabBarView(
                children: [
                  _buildHalamanLaporan(), // Tab 1
                  _buildHalamanPegawai(), // Tab 2
                  _buildListBarang(isJuragan: true), // Tab 3 (Edit Harga)
                ],
              )
            : _buildListBarang(
                isJuragan: false), // Tampilan Gudang (Full Access)

        floatingActionButton: isOwner
            ? null
            : FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const AddEditProdukPage()));
                  setState(() {});
                },
              ),
      ),
    );
  }

  // Widget List Barang (Dipakai Gudang & Juragan)
  Widget _buildListBarang({required bool isJuragan}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: daftarProduk.length,
      itemBuilder: (context, index) {
        final p = daftarProduk[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Image.network(
              p.urlGambar,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
            title: Text(p.nama,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Modal: Rp ${p.hargaModal} | Jual: Rp ${p.harga}",
                    style: TextStyle(
                        color: isJuragan ? Colors.purple : Colors.black87)),
                Text("Stok: ${p.stok} unit"),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TOMBOL EDIT (Juragan Edit Harga, Gudang Edit Stok)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: isJuragan ? "Atur Harga" : "Edit Barang",
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => AddEditProdukPage(produk: p)));
                    setState(() {});
                  },
                ),
                // TOMBOL HAPUS (Hanya Gudang)
                if (!isJuragan)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteProduk(p),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHalamanLaporan() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _infoCard("Total Aset (Modal)", hitungTotalAset(), Colors.blue),
        const Gap(10),
        _infoCard("Total Profit Bersih", hitungTotalProfit(), Colors.green),
        const Gap(20),
        const Text("Riwayat Penjualan",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(),
        if (riwayatTransaksi.isEmpty)
          const Center(child: Text("Belum ada data.")),
        ...riwayatTransaksi.reversed.map((trx) => ListTile(
              leading: const Icon(Icons.receipt, color: Colors.grey),
              title: Text(trx.idTransaksi),
              subtitle: Text("Untung: Rp ${trx.hitungProfit().toInt()}"),
              trailing: Text("+ Rp ${trx.total.toInt()}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green)),
            ))
      ],
    );
  }

  Widget _infoCard(String title, double val, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        const Gap(5),
        Text("Rp ${val.toInt()}",
            style:
                GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _buildHalamanPegawai() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: daftarPegawai.length,
      itemBuilder: (ctx, i) => Card(
        child: ListTile(
          leading: CircleAvatar(child: Text(daftarPegawai[i]['nama']![0])),
          title: Text(daftarPegawai[i]['nama']!),
          subtitle: Text(daftarPegawai[i]['posisi']!),
          trailing: IconButton(
            icon: const Icon(Icons.person_remove, color: Colors.red),
            onPressed: () => pecatPegawai(i),
          ),
        ),
      ),
    );
  }
}
