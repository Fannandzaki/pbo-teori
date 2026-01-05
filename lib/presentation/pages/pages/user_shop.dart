import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/produk_model.dart';
import '../../../models/user_model.dart';
import '../../../models/transaksi_model.dart';
import '../../widget/produk_image.dart'; // Import Widget Baru
import 'login.dart';

class UserShopPage extends StatefulWidget {
  final String namaKasir;
  const UserShopPage({super.key, this.namaKasir = "Kasir"});

  @override
  State<UserShopPage> createState() => _UserShopPageState();
}

class _UserShopPageState extends State<UserShopPage> {
  // ... (State & Logika User Shop tetap sama) ...
  Customer currentPelanggan = Customer(
    id: "TRX", username: "Umum", password: "", alamat: "-", noHp: "-", saldo: 0,
  );

  final TextEditingController _namaPembeliController = TextEditingController();
  final TextEditingController _alamatPembeliController = TextEditingController();
  final TextEditingController _searchController = TextEditingController(); 
  
  Map<Produk, int> keranjang = {};
  
  String selectedCategory = "Semua";
  List<Produk> filteredProduk = [];

  @override
  void initState() {
    super.initState();
    filteredProduk = List.from(daftarProduk);
  }

  void runFilter() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredProduk = daftarProduk.where((p) {
        bool matchName = p.nama.toLowerCase().contains(query);
        bool matchCategory = selectedCategory == "Semua" || p.kategori == selectedCategory;
        return matchName && matchCategory;
      }).toList();
    });
  }

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

  // --- DIALOG LOGIC (TIDAK BERUBAH) ---
  void showInputDataDialog() {
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Checkout", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _namaPembeliController, decoration: const InputDecoration(labelText: "Nama Pembeli", border: OutlineInputBorder())),
              const Gap(10),
              TextField(controller: _alamatPembeliController, decoration: const InputDecoration(labelText: "Alamat (Opsional)", border: OutlineInputBorder())),
              const Gap(10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Tanggal Transaksi", style: GoogleFonts.inter(fontSize: 14)),
                subtitle: Text("${selectedDate.day}-${selectedDate.month}-${selectedDate.year}", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
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
                prosesPembayaran(selectedDate);
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
      tgl: tglTransaksi,
      total: totalBelanja,
      items: itemsBeli,
    );

    riwayatTransaksi.add(trx);
    _showStrukDialog(trx);
    setState(() {
      keranjang.clear();
      // Reset filter setelah transaksi agar stok terupdate di UI
      runFilter();
    });
  }

  void _showStrukDialog(Transaksi trx) {
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
                Text("STRUK BELANJA", style: GoogleFonts.courierPrime(fontWeight: FontWeight.bold, fontSize: 18)),
                const Divider(thickness: 1, color: Colors.black54),
                _rowStruk("Kasir", widget.namaKasir),
                _rowStruk("Pembeli", currentPelanggan.username),
                _rowStruk("Tgl", "${trx.tgl.day}/${trx.tgl.month}/${trx.tgl.year}"),
                
                const Gap(8),
                const Text("- - - - - - - - - - - - - - - - -", style: TextStyle(color: Colors.grey)), 
                const Gap(8),

                ...trx.items.map((item) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${item['produk'].nama} x${item['qty']}", style: GoogleFonts.courierPrime()),
                        Text("Rp ${item['produk'].harga * item['qty']}", style: GoogleFonts.courierPrime()),
                      ],
                    )),
                
                const Gap(8),
                const Divider(thickness: 1, color: Colors.black87),
                const Gap(8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("TOTAL", style: GoogleFonts.courierPrime(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Rp ${trx.total.toInt()}", style: GoogleFonts.courierPrime(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                    onPressed: () => Navigator.pop(context), 
                    child: const Text("Tutup")
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowStruk(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.courierPrime(fontSize: 12)),
          Text(val, style: GoogleFonts.courierPrime(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- BUILD UI ---
  @override
  Widget build(BuildContext context) {
    int totalItems = keranjang.values.fold(0, (sum, qty) => sum + qty);
    double totalHarga = hitungTotalKeranjang();
    
    List<String> displayKategori = ["Semua", ...daftarKategori];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kasir Area", style: GoogleFonts.inter(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
            Text("Shift: ${widget.namaKasir}", style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const Login()))
            ),
          )
        ],
      ),
      
      body: Column(
        children: [
          // --- SEARCH BAR ---
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            color: const Color(0xFFF6F8FB),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => runFilter(), 
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: "Cari nama produk...",
                hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // --- KATEGORI HORIZONTAL ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: displayKategori.map((kategori) {
                bool isSelected = selectedCategory == kategori;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCategory = kategori;
                      });
                      runFilter();
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[700] : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.blue[700]! : Colors.grey[300]!
                        ),
                        boxShadow: isSelected 
                          ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] 
                          : []
                      ),
                      child: Text(
                        kategori,
                        style: GoogleFonts.inter(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 13
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // --- LIST PRODUK ---
          Expanded(
            child: filteredProduk.isEmpty 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                      const Gap(10),
                      Text("Produk tidak ditemukan", style: GoogleFonts.inter(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100), 
                  itemCount: filteredProduk.length,
                  separatorBuilder: (c, i) => const Gap(12),
                  itemBuilder: (context, index) {
                    final p = filteredProduk[index]; 
                    int qtyInCart = keranjang[p] ?? 0;
                    bool isHabis = p.stok <= 0;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // BAGIAN GAMBAR MENGGUNAKAN ProductImage
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ColorFiltered(
                                colorFilter: isHabis 
                                    ? const ColorFilter.mode(Colors.grey, BlendMode.saturation) 
                                    : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                                child: ProductImage(
                                  imagePath: p.urlGambar,
                                  width: 80, 
                                  height: 80, 
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Gap(16),
                            // Info Produk
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.nama, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15, color: isHabis ? Colors.grey : Colors.black87)),
                                  const Gap(4),
                                  Text("Stok: ${p.stok} | ${p.kategori}", style: GoogleFonts.inter(fontSize: 12, color: isHabis ? Colors.red : Colors.grey)), // Tambah Info Kategori
                                  const Gap(4),
                                  Text("Rp ${p.harga}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.blue[700], fontSize: 14)),
                                ],
                              ),
                            ),
                            // Tombol Aksi
                            if (isHabis)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                                child: Text("HABIS", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                              )
                            else
                              qtyInCart == 0
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[50], foregroundColor: Colors.blue,
                                      elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                    ),
                                    onPressed: () => tambahKeKeranjang(p),
                                    child: const Text("Beli"),
                                  )
                                : Container(
                                    decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove, size: 18, color: Colors.blue),
                                          onPressed: () => kurangiDariKeranjang(p),
                                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                        ),
                                        Text("$qtyInCart", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.blue)),
                                        IconButton(
                                          icon: const Icon(Icons.add, size: 18, color: Colors.blue),
                                          onPressed: () => tambahKeKeranjang(p),
                                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),

      // FAB Modern dengan Ringkasan
      floatingActionButton: totalItems > 0 ? FloatingActionButton.extended(
        backgroundColor: Colors.blue[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (ctx) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Keranjang Belanja", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Gap(16),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: keranjang.entries.map((e) => ListTile(
                        // Menggunakan ProductImage di keranjang juga
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8), 
                          child: ProductImage(
                            imagePath: e.key.urlGambar, 
                            width: 40, 
                            height: 40, 
                            fit: BoxFit.cover
                          )
                        ),
                        title: Text(e.key.nama, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        subtitle: Text("${e.value} x Rp ${e.key.harga}", style: GoogleFonts.inter(color: Colors.grey)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            kurangiDariKeranjang(e.key);
                            Navigator.pop(ctx); 
                            setState((){});
                          }
                        ),
                      )).toList(),
                    ),
                  ),
                  const Divider(),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total", style: GoogleFonts.inter(fontSize: 16, color: Colors.grey)),
                      Text("Rp ${totalHarga.toInt()}", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    ],
                  ),
                  const Gap(20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700], padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () { Navigator.pop(ctx); showInputDataDialog(); },
                      child: Text("Checkout Sekarang", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  )
                ],
              ),
            )
          );
        },
        label: Row(
          children: [
            Text("$totalItems Item  |  Rp ${totalHarga.toInt()}", style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            const Gap(10),
            const Icon(Icons.shopping_cart_checkout, color: Colors.white),
          ],
        ),
      ) : null,
    );
  }
}