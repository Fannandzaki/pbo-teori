// lib/models/produk_model.dart

List<String> daftarKategori = ["Makanan", "Minuman", "Elektronik"];

mixin HasExpiredDate {
  late String expiredDate;
  bool isExpired() => false;
}

abstract class Produk {
  final String id;
  final String nama;
  final int harga; // Harga Jual
  final int hargaModal; // Harga Beli (Baru)
  int stok; // Stok bisa berubah
  final String kategori;
  final String urlGambar;

  Produk({
    required this.id,
    required this.nama,
    required this.harga,
    required this.hargaModal,
    required this.stok,
    required this.kategori,
    required this.urlGambar,
  });
}

class Makanan extends Produk with HasExpiredDate {
  Makanan({
    required super.id,
    required super.nama,
    required super.harga,
    required super.hargaModal,
    required super.stok,
    required super.kategori,
    required super.urlGambar,
    required String expDate,
  }) {
    expiredDate = expDate;
  }
}

class Minuman extends Produk {
  final String ukuran;
  Minuman({
    required super.id,
    required super.nama,
    required super.harga,
    required super.hargaModal,
    required super.stok,
    required super.kategori,
    required super.urlGambar,
    required this.ukuran,
  });
}

class Elektronik extends Produk {
  final String garansi;
  Elektronik({
    required super.id,
    required super.nama,
    required super.harga,
    required super.hargaModal,
    required super.stok,
    required super.kategori,
    required super.urlGambar,
    required this.garansi,
  });
}

// Data Dummy
List<Produk> daftarProduk = [
  Makanan(
      id: "MKN-001",
      nama: "Roti Tawar",
      harga: 15000,
      hargaModal: 12000,
      stok: 20,
      kategori: "Makanan",
      urlGambar:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Korb_mit_Br%C3%B6tchen.JPG/1200px-Korb_mit_Br%C3%B6tchen.JPG",
      expDate: "2025-12-30"),
  Minuman(
      id: "MNM-001",
      nama: "Kopi Botol",
      harga: 5000,
      hargaModal: 3500,
      stok: 50,
      kategori: "Minuman",
      urlGambar:
          "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/6/15/8e025597-9092-4f33-9720-3949f69742a7.jpg",
      ukuran: "250ml"),
];
