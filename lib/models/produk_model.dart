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
    required String id,
    required String nama,
    required int harga,
    required int hargaModal,
    required int stok,
    required String kategori,
    required String urlGambar,
    required String expDate,
  }) : super(
            id: id,
            nama: nama,
            harga: harga,
            hargaModal: hargaModal,
            stok: stok,
            kategori: kategori,
            urlGambar: urlGambar) {
    this.expiredDate = expDate;
  }
}

class Minuman extends Produk {
  final String ukuran;
  Minuman({
    required String id,
    required String nama,
    required int harga,
    required int hargaModal,
    required int stok,
    required String kategori,
    required String urlGambar,
    required this.ukuran,
  }) : super(
            id: id,
            nama: nama,
            harga: harga,
            hargaModal: hargaModal,
            stok: stok,
            kategori: kategori,
            urlGambar: urlGambar);
}

class Elektronik extends Produk {
  final String garansi;
  Elektronik({
    required String id,
    required String nama,
    required int harga,
    required int hargaModal,
    required int stok,
    required String kategori,
    required String urlGambar,
    required this.garansi,
  }) : super(
            id: id,
            nama: nama,
            harga: harga,
            hargaModal: hargaModal,
            stok: stok,
            kategori: kategori,
            urlGambar: urlGambar);
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
