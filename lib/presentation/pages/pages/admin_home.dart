import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../../../models/produk_model.dart';
import '../../../models/transaksi_model.dart';
import '../../widget/produk_image.dart'; // Import Widget Baru
import 'add_edit_produk.dart';
import 'login.dart';
import 'kelola_kategori.dart';

class AdminHomePage extends StatefulWidget {
  final String role; 
  const AdminHomePage({super.key, required this.role});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, String>> daftarPegawai = [
    {"nama": "Fannan", "posisi": "Kasir", "role": "kasir"},
    {"nama": "Admin Gudang", "posisi": "Logistik", "role": "gudang"},
  ];

  String _selectedRecapType = 'Harian';

  @override
  void initState() {
    super.initState();
    bool isOwner = widget.role == 'owner';
    _tabController = TabController(length: isOwner ? 4 : 1, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ... (Bagian FAB, getTransaksiByPeriode, hitungTotal, dll TETAP SAMA seperti sebelumnya) ...
  // Salin fungsi logika bisnis dari file lama Anda di sini jika tidak ingin menulis ulang semua.
  // Kode di bawah ini saya singkat bagian logikanya agar fokus ke perubahan UI ListBarang.

  List<Transaksi> getTransaksiByPeriode(String tipe) {
    DateTime now = DateTime.now();
    return riwayatTransaksi.where((trx) {
      if (tipe == "Harian") {
        return trx.tgl.day == now.day && trx.tgl.month == now.month && trx.tgl.year == now.year;
      } else if (tipe == "Mingguan") {
        final weekAgo = now.subtract(const Duration(days: 7));
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

  void showTambahPegawai() {
     // ... (Kode showTambahPegawai tetap sama) ...
     // Saya singkat agar tidak terlalu panjang, copy dari file lama.
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
                initialValue: selectedRole,
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

  void _showDetailStruk(Transaksi trx) {
    // ... (Kode _showDetailStruk tetap sama) ...
    // Saya singkat agar tidak terlalu panjang.
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
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
                      ],
                    ),
                  );
                }),
                const Gap(10),
                const Text("--------------------------------", style: TextStyle(letterSpacing: 2)),
                _rowStruk("TOTAL", "Rp ${trx.total.toInt()}", isBold: true),
                _rowStruk("PROFIT", "Rp ${trx.hitungProfit().toInt()}", isBold: true, color: Colors.green),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], foregroundColor: Colors.black, elevation: 0),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Tutup"),
                  ),
                ),
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

  // --- BUILD UI ---

  @override
  Widget build(BuildContext context) {
    bool isOwner = widget.role == 'owner';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        // ... (Kode AppBar tetap sama) ...
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isOwner ? "Juragan Dashboard" : "Gudang Area",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 20),
            ),
            Text(
              isOwner ? "Pantau bisnis Anda" : "Kelola stok & logistik",
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        bottom: isOwner ? TabBar(
          controller: _tabController, 
          isScrollable: true,
          indicatorColor: Colors.purple,
          indicatorWeight: 3,
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Home"),
            Tab(text: "Recap"),
            Tab(text: "Pegawai"),
            Tab(text: "Barang"),
          ],
        ) : null,
        actions: [
          if (!isOwner) IconButton(icon: const Icon(Icons.category, color: Colors.black87), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const KelolaKategoriPage()))),
          IconButton(icon: const Icon(Icons.logout, color: Colors.red), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const Login()))),
          const Gap(8),
        ],
      ),
      
      body: isOwner
          ? TabBarView(
              controller: _tabController,
              children: [
                _buildHalamanDashboard(),
                _buildHalamanRecap(),
                _buildHalamanPegawai(),
                _buildListBarang(isJuragan: true),
              ],
            )
          : _buildTampilanGudang(),
      
      // FloatingActionButton logic juga dicopy dari file lama
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget? _buildFloatingActionButton() {
      // ... (Copy logika FAB dari file lama) ...
      bool isOwner = widget.role == 'owner';
    if (!isOwner) {
      return FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (c) => const AddEditProdukPage()));
          setState(() {});
        },
        icon: const Icon(Icons.add_box, color: Colors.white),
        label: Text("Stok Baru", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
      );
    }
    int currentIndex = _tabController.index;
    if (currentIndex == 2) { 
      return FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: showTambahPegawai,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: Text("Pegawai", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
      );
    } else if (currentIndex == 3) {
      return FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (c) => const AddEditProdukPage()));
          setState(() {});
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("Barang", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
      );
    }
    return null;
  }

  // ... (Widget _buildTampilanGudang, _buildMiniStat, _buildHalamanDashboard, _buildModernStatCard, _buildHalamanRecap, _buildHalamanPegawai TETAP SAMA) ...
  // Silakan gunakan kode dari file sebelumnya untuk widget-widget tersebut.

  // --- BAGIAN PENTING YANG DIUBAH ---
  
  Widget _buildListBarang({required bool isJuragan}) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: daftarProduk.length,
      separatorBuilder: (_, __) => const Gap(12),
      itemBuilder: (context, index) {
        final p = daftarProduk[index];
        return Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (c) => AddEditProdukPage(produk: p, isGudang: !isJuragan)));
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // MENGGUNAKAN ProductImage DI SINI
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12), 
                      child: ProductImage(
                        imagePath: p.urlGambar, 
                        width: 70, 
                        height: 70, 
                        fit: BoxFit.cover
                      ),
                    ),
                    const Gap(16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.nama, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)), const Gap(4), Text("Stok: ${p.stok} pcs", style: GoogleFonts.inter(color: p.stok < 5 ? Colors.red : Colors.grey[600], fontWeight: p.stok < 5 ? FontWeight.bold : FontWeight.normal, fontSize: 13)), const Gap(4), Text("Rp ${p.harga}", style: GoogleFonts.inter(color: Colors.blue[700], fontWeight: FontWeight.bold, fontSize: 14))])),
                    if (!isJuragan) IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => deleteProduk(p)) else const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  // (Pastikan method lain dari file asli tetap ada)
   Widget _buildTampilanGudang() {
    int totalStok = daftarProduk.fold(0, (sum, p) => sum + p.stok);
    int itemsLow = daftarProduk.where((p) => p.stok < 5).length;

    return Column(
      children: [
        // Header Ringkasan untuk Gudang
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildMiniStat("Total Fisik", "$totalStok Unit", Colors.blue),
              ),
              const Gap(15),
              Expanded(
                child: _buildMiniStat("Stok Menipis", "$itemsLow Item", Colors.orange),
              ),
            ],
          ),
        ),
        // List Barang
        Expanded(child: _buildListBarang(isJuragan: false)),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12, color: color[800])), 
          const Gap(4),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color[900])), 
        ],
      ),
    );
  }

  Widget _buildHalamanDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ringkasan Aset", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const Gap(16),
          _buildModernStatCard("Total Nilai Aset", hitungTotalAset(), [Colors.blue, Colors.blueAccent], Icons.inventory_2),
          const Gap(16),
          _buildModernStatCard("Total Profit (All Time)", hitungTotalProfitAllTime(), [Colors.green, Colors.teal], Icons.monetization_on),
          const Gap(30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Column(
              children: [
                const Icon(Icons.store, size: 48, color: Colors.purple),
                const Gap(10),
                Text("Selamat Datang, Juragan!", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                const Gap(8),
                Text("Gunakan tab 'Recap' untuk melihat laporan keuangan, atau kelola 'Pegawai' dan 'Barang' melalui tab yang tersedia.", textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.grey[600], height: 1.5)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildModernStatCard(String title, double val, List<Color> gradientColors, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: gradientColors.last.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 14)),
              const Gap(8),
              Text("Rp ${val.toInt()}", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.white, size: 28))
        ],
      ),
    );
  }

  Widget _buildHalamanRecap() {
    List<Transaksi> data = getTransaksiByPeriode(_selectedRecapType);
    double omset = hitungTotal(data);
    double profit = hitungProfit(data);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          color: Colors.white,
          child: Row(
            children: ["Harian", "Mingguan", "Bulanan"].map((type) {
              bool isSelected = _selectedRecapType == type;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => setState(() => _selectedRecapType = type),
                    borderRadius: BorderRadius.circular(30),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(color: isSelected ? Colors.purple : Colors.grey[100], borderRadius: BorderRadius.circular(30), border: Border.all(color: isSelected ? Colors.purple : Colors.grey.shade300)),
                      child: Center(child: Text(type, style: GoogleFonts.inter(color: isSelected ? Colors.white : Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12))),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.purple, Colors.deepPurpleAccent], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Pemasukan", style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)), const Gap(4), Text("Rp ${omset.toInt()}", style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]),
                Container(width: 1, height: 40, color: Colors.white24),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text("Profit Bersih", style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)), const Gap(4), Text("+Rp ${profit.toInt()}", style: GoogleFonts.inter(color: const Color(0xFF69F0AE), fontSize: 20, fontWeight: FontWeight.bold))]),
              ],
            ),
          ),
        ),
        Expanded(
          child: data.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.receipt_long, size: 60, color: Colors.grey[300]), const Gap(10), Text("Belum ada data $_selectedRecapType", style: TextStyle(color: Colors.grey[500]))]))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: data.length,
                  separatorBuilder: (c, i) => const Gap(12),
                  itemBuilder: (context, index) {
                    final trx = data[data.length - 1 - index];
                    return InkWell(
                      onTap: () => _showDetailStruk(trx),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))]),
                        child: Row(
                          children: [
                            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.purple[50], shape: BoxShape.circle), child: const Icon(Icons.receipt, color: Colors.purple, size: 20)),
                            const Gap(16),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(trx.idTransaksi, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)), Text("${trx.tgl.day}/${trx.tgl.month} • ${trx.items.length} Item", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12))])),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text("Rp ${trx.total.toInt()}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)), Text("+Rp ${trx.hitungProfit().toInt()}", style: GoogleFonts.inter(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600))])
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

  Widget _buildHalamanPegawai() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: daftarPegawai.length,
      separatorBuilder: (_, __) => const Gap(12),
      itemBuilder: (ctx, i) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Row(
          children: [
            CircleAvatar(radius: 24, backgroundColor: Colors.purple[50], child: Text(daftarPegawai[i]['nama']![0], style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold))),
            const Gap(16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(daftarPegawai[i]['nama']!, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15)), Text(daftarPegawai[i]['posisi']!, style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13))])),
            IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => setState(() => daftarPegawai.removeAt(i))),
          ],
        ),
      ),
    );
  }
}