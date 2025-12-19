// lib/models/transaksi_model.dart
import 'produk_model.dart';

class Transaksi {
  final String idTransaksi;
  final DateTime tgl;
  final double total;
  // Ubah 'item' tunggal menjadi List of Map agar bisa menampung banyak barang & qty
  final List<Map<String, dynamic>> items;

  Transaksi({
    required this.idTransaksi,
    required this.tgl,
    required this.total,
    required this.items,
  });

  // Fungsi Cetak Struk
  void cetakStruk() {
    print("===============================");
    print("STRUK BELANJA SUPERMARKET");
    print("===============================");
    print("ID Transaksi : $idTransaksi");
    print("Tanggal      : ${tgl.toString().substring(0, 16)}");
    print("-------------------------------");
    for (var i in items) {
      Produk p = i['produk'];
      int qty = i['qty'];
      print("${p.nama} (x$qty) - Rp ${p.harga * qty}");
    }
    print("-------------------------------");
    print("TOTAL BAYAR  : Rp ${total.toInt()}");
    print("===============================");
  }
}
