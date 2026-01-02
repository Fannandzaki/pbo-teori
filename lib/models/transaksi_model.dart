// lib/models/transaksi_model.dart
import 'produk_model.dart';

List<Transaksi> riwayatTransaksi = [];

class Transaksi {
  final String idTransaksi;
  final DateTime tgl; // Tanggal transaksi (bisa diinput mundur oleh kasir)
  final double total;
  final List<Map<String, dynamic>> items; // [{'produk': Produk, 'qty': int}]

  Transaksi({
    required this.idTransaksi,
    required this.tgl,
    required this.total,
    required this.items,
  });

  // Hitung profit bersih dari transaksi ini
  double hitungProfit() {
    double profit = 0;
    for (var item in items) {
      Produk p = item['produk'];
      int qty = item['qty'] as int;
      profit += (p.harga - p.hargaModal) * qty;
    }
    return profit;
  }
}