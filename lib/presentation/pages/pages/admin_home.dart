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
    {"nama": "Fannan", "posisi": "Kasir", "role": "kasir"},
    {"nama": "Admin Gudang", "posisi": "Logistik", "role": "gudang"},
  ];

  // State untuk Filter Recap (Default: Harian)
  String _selectedRecapType = 'Harian'; 

  // --- LOGIKA FILTER TRANSAKSI ---
  List<Transaksi> getTransaksiByPeriode(String tipe) {
    DateTime now = DateTime.now();
    return riwayatTransaksi.where((trx) {
      if (tipe == "Harian") {
        return trx.tgl.day == now.day &&
            trx.tgl.month == now.month &&
            trx.tgl.year == now.year;
      } else if (tipe == "Mingguan") {
        final weekAgo = now.subtract(const Duration(days: 7));
        // Ambil data 7 hari terakhir
        return trx.tgl.isAfter(weekAgo) && trx.tgl.isBefore(now.add(const Duration(days: 1)));
      } else if (tipe == "Bulanan") {
        return trx.tgl.month == now.month && trx.tgl.year == now.year;
      }
      return false;
    }).toList();
  }

  double hitungTotal(List<Transaksi> list) => list.fold(0, (sum, item) => sum + item.total);
  double hitungProfit(List<Transaksi> list) => list.fold(0, (sum, item) => sum + item.hitungProfit());

  double hitungTotalAset() => daftarProduk.fold(0, (sum, p) => sum + (p.hargaModal * p.stok));
  double hitungTotalProfitAllTime() => riwayatTransaksi.fold(0, (sum, trx) => sum + trx.hitungProfit());

  // --- FUNGSI HAPUS ---
  void deleteProduk(Produk produk) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Produk?"),
        content: Text("Yakin hapus ${produk.nama}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              setState(() { daftarProduk.remove(produk); });
              Navigator.pop(ctx);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  // --- FUNGSI TAMBAH PEGAWAI ---
  void showTambahPegawai() {
    final nameController = TextEditingController();
    String selectedRole = 'kasir';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Tambah Pegawai", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
              const Gap(15),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nama", border: OutlineInputBorder())),
              const Gap(15),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(labelText: "Role", border: OutlineInputBorder()),
                items: const [DropdownMenuItem(value: 'kasir', child: Text("Kasir")), DropdownMenuItem(value: 'gudang', child: Text("Gudang"))],
                onChanged: (val) => setModalState(() => selectedRole = val!),
              ),
              const Gap(20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  setState(() {
                    daftarPegawai.add({"nama": nameController.text, "posisi": selectedRole == 'kasir' ? "Kasir" : "Logistik", "role": selectedRole});
                  });
                  Navigator.pop(ctx);
                },
                child: const Text("Simpan", style: TextStyle(color: Colors.white)),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  // --- FUNGSI POP-UP STRUK ---
  void _showDetailStruk(Transaksi trx) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("DETAIL TRANSAKSI", style: GoogleFonts.courierPrime(fontWeight: FontWeight.bold, fontSize: 18)),
                const Text("--------------------------------", style: TextStyle(letterSpacing: 2)),
                const Gap(10),
                _rowStruk("ID", trx.idTransaksi),
                _rowStruk("Tgl", "${trx.tgl.day}/${trx.tgl.month}/${trx.tgl.year}"),
                const Gap(10),
                const Text("--------------------------------", style: TextStyle(letterSpacing: 2)),
                ...trx.items.map((item) {
                  final p = item['produk'] as Produk;
                  final qty = item['qty'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.nama, style: GoogleFonts.courierPrime(fontWeight: FontWeight.bold)),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text("$qty x ${p.harga}", style: GoogleFonts.courierPrime()),
                          Text("${p.harga * qty}", style: GoogleFonts.courierPrime()),
                        ]),
                        Text("Profit: +${(p.harga - p.hargaModal) * qty}", style: GoogleFonts.courierPrime(color: Colors.green, fontSize: 12)),
                      ],
                    ),
                  );
                }),
                const Gap(10),
                const Text("--------------------------------", style: TextStyle(letterSpacing: 2)),
                _rowStruk("TOTAL", "Rp ${trx.total.toInt()}", isBold: true),
                _rowStruk("PROFIT", "Rp ${trx.hitungProfit().toInt()}", isBold: true, color: Colors.green),
                const Gap(20),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowStruk(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.courierPrime(fontSize: 13)),
          Text(value, style: GoogleFonts.courierPrime(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isOwner = widget.role == 'owner';
    // Juragan punya 4 Tab: Dashboard, Recap, Pegawai, Barang
    // Gudang cuma 1 tampilan
    
    return DefaultTabController(
      length: isOwner ? 4 : 1, 
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: Text(isOwner ? "Juragan Dashboard" : "Gudang", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          backgroundColor: isOwner ? Colors.purple[50] : Colors.blue[50],
          bottom: isOwner ? const TabBar(
            isScrollable: true, // Agar muat di layar kecil
            indicatorColor: Colors.purple,
            labelColor: Colors.purple,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Home"),
              Tab(text: "Recap"), // Tab Baru "Recap"
              Tab(text: "Pegawai"),
              Tab(text: "Barang"),
            ]
          ) : null,
          actions: [
            if (!isOwner) IconButton(icon: const Icon(Icons.category), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const KelolaKategoriPage()))),
            IconButton(icon: const Icon(Icons.logout), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const Login()))),
          ],
        ),
        
        body: isOwner
            ? TabBarView(
                children: [
                  _buildHalamanDashboard(), // Tab 1: Home
                  _buildHalamanRecap(),     // Tab 2: Recap (Fitur Baru)
                  _buildHalamanPegawai(),   // Tab 3: Pegawai
                  _buildListBarang(isJuragan: true), // Tab 4: Barang
                ],
              )
            : _buildListBarang(isJuragan: false),
            
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: isOwner ? Colors.purple : Colors.blue,
          onPressed: isOwner ? showTambahPegawai : () async { 
            await Navigator.push(context, MaterialPageRoute(builder: (c) => const AddEditProdukPage())); 
            setState(() {}); 
          },
          icon: Icon(isOwner ? Icons.person_add : Icons.add),
          label: Text(isOwner ? "Pegawai" : "Barang"),
        ),
      ),
    );
  }

  // TAB 1: DASHBOARD UMUM
  Widget _buildHalamanDashboard() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _infoCard("Total Nilai Aset", hitungTotalAset(), Colors.blue),
        const Gap(10),
        _infoCard("Total Profit (Seumur Hidup)", hitungTotalProfitAllTime(), Colors.green),
        const Gap(20),
        const Text("Selamat Datang, Juragan!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Text("Gunakan tab 'Recap' untuk melihat laporan keuangan rinci per periode.", style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  // TAB 2: RECAP (HARIAN/MINGGUAN/BULANAN)
  Widget _buildHalamanRecap() {
    List<Transaksi> data = getTransaksiByPeriode(_selectedRecapType);
    double omset = hitungTotal(data);
    double profit = hitungProfit(data);

    return Column(
      children: [
        // 1. Filter Buttons
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ["Harian", "Mingguan", "Bulanan"].map((type) {
              bool isSelected = _selectedRecapType == type;
              return InkWell(
                onTap: () {
                  setState(() { _selectedRecapType = type; });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.purple : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(type, style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold
                  )),
                ),
              );
            }).toList(),
          ),
        ),

        // 2. Summary Card
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.purple, Colors.deepPurpleAccent]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Pemasukan $_selectedRecapType", style: const TextStyle(color: Colors.white70)),
                  Text("Rp ${omset.toInt()}", style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Text("Profit Bersih", style: TextStyle(color: Colors.white70)),
                  Text("+Rp ${profit.toInt()}", style: GoogleFonts.inter(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
              ],
            ),
          ),
        ),

        // 3. List Transaksi
        Expanded(
          child: data.isEmpty 
          ? Center(child: Text("Belum ada data untuk periode $_selectedRecapType"))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                // Balik urutan agar yg terbaru di atas
                final trx = data[data.length - 1 - index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    onTap: () => _showDetailStruk(trx), // KLIK MUNCUL POPUP
                    leading: const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.receipt, color: Colors.white, size: 20)),
                    title: Text(trx.idTransaksi, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${trx.tgl.day}/${trx.tgl.month} • ${trx.items.length} Barang"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Rp ${trx.total.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("+Rp ${trx.hitungProfit().toInt()}", style: const TextStyle(color: Colors.green, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
        ),
      ],
    );
  }

  // TAB 3: PEGAWAI
  Widget _buildHalamanPegawai() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: daftarPegawai.length,
      itemBuilder: (ctx, i) => Card(
        child: ListTile(
          leading: CircleAvatar(child: Text(daftarPegawai[i]['nama']![0])),
          title: Text(daftarPegawai[i]['nama']!),
          subtitle: Text("Role: ${daftarPegawai[i]['role']!.toUpperCase()}"),
          trailing: IconButton(icon: const Icon(Icons.person_remove, color: Colors.red), onPressed: () { setState(() { daftarPegawai.removeAt(i); }); }),
        ),
      ),
    );
  }

  // TAB 4: BARANG
  Widget _buildListBarang({required bool isJuragan}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: daftarProduk.length,
      itemBuilder: (context, index) {
        final p = daftarProduk[index];
        return Card(
          child: ListTile(
            leading: Image.network(p.urlGambar, width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
            title: Text(p.nama),
            subtitle: Text("Stok: ${p.stok} | Jual: ${p.harga}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (c) => AddEditProdukPage(produk: p, isGudang: !isJuragan)));
                    setState(() {});
                  },
                ),
                if (!isJuragan) IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => deleteProduk(p)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoCard(String title, double val, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            Text("Rp ${val.toInt()}", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
          Icon(Icons.monetization_on, color: color.withOpacity(0.5), size: 30)
        ],
      ),
    );
  }
}