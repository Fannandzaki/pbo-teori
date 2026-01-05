// lib/models/produk_model.dart

List<String> daftarKategori = ["Makanan", "Minuman", "Elektronik", "Rokok", "Alat Tulis", "Perlengkapan Rumah"];

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

// --- CLASS BARU DITAMBAHKAN ---

class Rokok extends Produk {
  final String pitaCukai; // Atribut khusus Rokok (misal: "2024" atau "Non-Cukai")
  Rokok({
    required super.id,
    required super.nama,
    required super.harga,
    required super.hargaModal,
    required super.stok,
    required super.kategori,
    required super.urlGambar,
    required this.pitaCukai,
  });
}

class AlatTulis extends Produk {
  final String jenis; // Atribut khusus ATK (misal: "Pulpen", "Buku", "Spidol")
  AlatTulis({
    required super.id,
    required super.nama,
    required super.harga,
    required super.hargaModal,
    required super.stok,
    required super.kategori,
    required super.urlGambar,
    required this.jenis,
  });
}

class PerlengkapanRumah extends Produk {
  final String bahan; // Atribut khusus Perlengkapan (misal: "Plastik", "Kayu")
  PerlengkapanRumah({
    required super.id,
    required super.nama,
    required super.harga,
    required super.hargaModal,
    required super.stok,
    required super.kategori,
    required super.urlGambar,
    required this.bahan,
  });
}

// Data Dummy Diperbarui
List<Produk> daftarProduk = [
  Makanan(
      id: "MKN-001",
      nama: "Roti Tawar",
      harga: 15000,
      hargaModal: 12000,
      stok: 20,
      kategori: "Makanan",
      urlGambar:
          "../../assets/RotiTawar.jpg", 
      expDate: "2025-12-30"),
  Minuman(
      id: "MNM-001",
      nama: "Kopi Botol",
      harga: 5000,
      hargaModal: 3500,
      stok: 50,
      kategori: "Minuman",
      urlGambar:
          "../../assets/GoldaCoffee.jpg", // Link Unsplash (Stabil)
      ukuran: "250ml"),
  Rokok(
      id: "RKK-001",
      nama: "Surya 16",
      harga: 32000,
      hargaModal: 29000,
      stok: 100,
      kategori: "Rokok",
      urlGambar: "../../assets/Surya16.jpg", // Ilustrasi Rokok
      pitaCukai: "Cukai 2025"),
  AlatTulis(
      id: "ATK-001",
      nama: "Buku Tulis",
      harga: 5000,
      hargaModal: 3500,
      stok: 200,
      kategori: "Alat Tulis",
      urlGambar: "../../assets/BukuTulis.jpg", // Buku
      jenis: "Buku Tulis"),
  PerlengkapanRumah(
      id: "PRT-001",
      nama: "Sapu Lantai",
      harga: 25000,
      hargaModal: 18000,
      stok: 15,
      kategori: "Perlengkapan Rumah",
      urlGambar: "../../assets/Sapu.jpg", // Alat Kebersihan
      bahan: "Ijuk & Kayu"),
];