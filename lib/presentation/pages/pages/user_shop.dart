import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
// Import yang dibutuhkan
import '../../../models/produk_model.dart';
import '../../../models/user_model.dart';
import '../../../models/transaksi_model.dart';
import 'login.dart'; // Pastikan import login.dart benar agar bisa logout

class UserShopPage extends StatefulWidget {
  const UserShopPage({super.key});

  @override
  State<UserShopPage> createState() => _UserShopPageState();
}

class _UserShopPageState extends State<UserShopPage> {
  // 1. DATA CUSTOMER DUMMY
  Customer currentUser = Customer(
    id: "CUST001",
    username: "Fannan",
    password: "123",
    alamat: "Jl. Mawar No. 10",
    noHp: "08123456789",
    saldo: 50000000.0,
  );

  // 2. KERANJANG BELANJA
  // Key: Produk, Value: Jumlah (Qty)
  Map<Produk, int> keranjang = {};

  // --- LOGIKA KERANJANG ---

  void tambahKeKeranjang(Produk produk) {
    setState(() {
      if (keranjang.containsKey(produk)) {
        keranjang[produk] = keranjang[produk]! + 1;
      } else {
        keranjang[produk] = 1;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${produk.nama} ditambahkan ke keranjang"),
        duration: const Duration(milliseconds: 500),
      ),
    );
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

  // --- LOGIKA CHECKOUT (BELI SEKALIGUS) ---
  void handleCheckout() {
    double totalBelanja = hitungTotalKeranjang();

    if (totalBelanja <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Keranjang kosong!")));
      return;
    }

    if (currentUser.saldo >= totalBelanja) {
      // 1. Kurangi Saldo
      setState(() {
        currentUser.kurangiSaldo(totalBelanja);
      });

      // 2. Siapkan Data untuk Transaksi Model Baru
      List<Map<String, dynamic>> itemsBeli = [];
      keranjang.forEach((produk, qty) {
        itemsBeli.add({
          'produk': produk,
          'qty': qty,
        });
      });

      // 3. Buat Objek Transaksi
      Transaksi trx = Transaksi(
        idTransaksi:
            "TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}",
        tgl: DateTime.now(),
        total: totalBelanja,
        items: itemsBeli,
      );

      // 4. Print Struk & Tampilkan Dialog
      trx.cetakStruk();
      _showStrukDialog(trx);

      // 5. Kosongkan Keranjang setelah sukses
      setState(() {
        keranjang.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Saldo tidak cukup!"), backgroundColor: Colors.red),
      );
    }
  }

  // --- LOGIKA LOGOUT ---
  void handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah anda yakin ingin keluar?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal")),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login()));
            },
            child: const Text("Keluar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- TAMPILAN DIALOG STRUK (Updated) ---
  void _showStrukDialog(Transaksi trx) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          // Pakai scroll biar kalau panjang aman
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.receipt_long,
                          size: 40, color: Colors.black54),
                      Text("SUPERMARKET KITA",
                          style: GoogleFonts.courierPrime(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Text("Jl. Telekomunikasi No. 1",
                          style: GoogleFonts.courierPrime(fontSize: 12)),
                    ],
                  ),
                ),
                const Divider(thickness: 1, color: Colors.black),

                // INFO CUSTOMER (Sesuai Class Diagram: Customer punya Alamat & NoHP)
                Text("INFO PELANGGAN:",
                    style: GoogleFonts.courierPrime(
                        fontWeight: FontWeight.bold, fontSize: 12)),
                Text("Nama   : ${currentUser.username}",
                    style: GoogleFonts.courierPrime(fontSize: 12)),
                Text("No HP  : ${currentUser.noHp}",
                    style: GoogleFonts.courierPrime(
                        fontSize: 12)), // Data No HP muncul
                Text("Alamat : ${currentUser.alamat}",
                    style: GoogleFonts.courierPrime(
                        fontSize: 12)), // Data Alamat muncul
                const Gap(10),
                const Gap(10),

                // INFO TRANSAKSI (Sesuai Class Diagram: Transaksi punya ID & Tgl)
                Text("DETAIL BELANJA:",
                    style: GoogleFonts.courierPrime(
                        fontWeight: FontWeight.bold, fontSize: 12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ID: ${trx.idTransaksi}",
                        style: GoogleFonts.courierPrime(fontSize: 10)),
                    Text(trx.tgl.toString().substring(0, 10),
                        style: GoogleFonts.courierPrime(fontSize: 10)),
                  ],
                ),
                const Divider(thickness: 1, color: Colors.black26),

                // DAFTAR BARANG
                ...trx.items.map((item) {
                  Produk p = item['produk'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text("${p.nama} (x${item['qty']})",
                                style: GoogleFonts.courierPrime(fontSize: 12))),
                        Text("Rp ${(p.harga * item['qty']).toInt()}",
                            style: GoogleFonts.courierPrime(fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),

                const Divider(thickness: 2, color: Colors.black),

                // TOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("TOTAL BAYAR",
                        style: GoogleFonts.courierPrime(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Rp ${trx.total.toInt()}",
                        style: GoogleFonts.courierPrime(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const Gap(5),
                Center(
                  child: Text("Sisa Saldo: Rp ${currentUser.saldo.toInt()}",
                      style: GoogleFonts.courierPrime(
                          color: Colors.grey, fontSize: 12)),
                ),
                const Gap(20),

                // FOOTER
                Center(
                    child: Text("-- Terima Kasih --",
                        style: GoogleFonts.courierPrime(
                            fontStyle: FontStyle.italic))),
                const Gap(20),

                // TOMBOL CETAK / TUTUP
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Di sini implementasi 'Cetak Struk' secara visual selesai
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87),
                    icon:
                        const Icon(Icons.print, color: Colors.white, size: 16),
                    label: const Text("Cetak / Simpan",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- MODAL KERANJANG (POP UP BAWAH) ---
  void showKeranjangModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(// Agar tampilan modal bisa di-update real-time
            builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Keranjang Belanja",
                    style: GoogleFonts.inter(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const Divider(),
                Expanded(
                  child: keranjang.isEmpty
                      ? const Center(child: Text("Keranjang masih kosong"))
                      : ListView(
                          children: keranjang.entries.map((entry) {
                            return ListTile(
                              title: Text(entry.key.nama),
                              subtitle: Text("Rp ${entry.key.harga}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      kurangiDariKeranjang(entry.key);
                                      setModalState(
                                          () {}); // Update tampilan modal
                                      setState(
                                          () {}); // Update tampilan halaman utama
                                    },
                                  ),
                                  Text("${entry.value}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline,
                                        color: Colors.blue),
                                    onPressed: () {
                                      tambahKeKeranjang(entry.key);
                                      setModalState(() {});
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total: Rp ${hitungTotalKeranjang().toInt()}",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    ElevatedButton(
                      onPressed: keranjang.isEmpty
                          ? null
                          : () {
                              Navigator.pop(context); // Tutup modal dulu
                              handleCheckout(); // Proses bayar
                            },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text("Checkout",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // --- APP BAR DENGAN TOMBOL LOGOUT ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Smart Shop",
                style: GoogleFonts.inter(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            Text("Saldo: Rp ${currentUser.saldo.toInt()}",
                style: GoogleFonts.inter(color: Colors.green, fontSize: 12)),
          ],
        ),
        actions: [
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: handleLogout,
            tooltip: "Keluar",
          )
        ],
      ),

      // --- TOMBOL KERANJANG MENGAMBANG (FAB) ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showKeranjangModal,
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
        label: Text("Keranjang (${keranjang.length})",
            style: const TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: daftarProduk.length,
          itemBuilder: (context, index) {
            final produk = daftarProduk[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      produk.urlGambar,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image)),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(produk.nama,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(produk.kategori,
                            style: GoogleFonts.inter(
                                color: Colors.blueAccent, fontSize: 12)),
                        Text("Rp ${produk.harga}",
                            style: GoogleFonts.inter(
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  // Tombol Tambah ke Keranjang
                  ElevatedButton(
                    onPressed: () => tambahKeKeranjang(produk),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10)),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
