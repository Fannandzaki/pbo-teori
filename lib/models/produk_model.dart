// lib/models/produk_model.dart

// 1. CLASS INDUK (PARENT)
class Produk {
  String id;
  String nama;
  String deskripsi;
  int harga;
  int stok;
  String kategori; // Makanan, Minuman, Elektronik
  String urlGambar;

  Produk({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.stok,
    required this.kategori,
    required this.urlGambar,
  });
}

// 2. CLASS TURUNAN (CHILDREN) - Inheritance

class Makanan extends Produk {
  String expiredDate;
  Makanan({
    required String id,
    required String nama,
    required String deskripsi,
    required int harga,
    required int stok,
    required String urlGambar,
    required this.expiredDate,
  }) : super(
            id: id,
            nama: nama,
            deskripsi: deskripsi,
            harga: harga,
            stok: stok,
            kategori: 'Makanan',
            urlGambar: urlGambar);
}

class Minuman extends Produk {
  String ukuran;
  Minuman({
    required String id,
    required String nama,
    required String deskripsi,
    required int harga,
    required int stok,
    required String urlGambar,
    required this.ukuran,
  }) : super(
            id: id,
            nama: nama,
            deskripsi: deskripsi,
            harga: harga,
            stok: stok,
            kategori: 'Minuman',
            urlGambar: urlGambar);
}

class Elektronik extends Produk {
  String masaGaransi;
  Elektronik({
    required String id,
    required String nama,
    required String deskripsi,
    required int harga,
    required int stok,
    required String urlGambar,
    required this.masaGaransi,
  }) : super(
            id: id,
            nama: nama,
            deskripsi: deskripsi,
            harga: harga,
            stok: stok,
            kategori: 'Elektronik',
            urlGambar: urlGambar);
}

// 3. DATA DUMMY (Polymorphism)
List<Produk> daftarProduk = [
  Makanan(
    id: 'M01',
    nama: 'Roti Tawar Gandum',
    deskripsi: 'Roti tawar sehat kaya serat.',
    harga: 18000,
    stok: 20,
    urlGambar:
        'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500',
    expiredDate: '20-12-2025',
  ),
  Minuman(
    id: 'D01',
    nama: 'Jus Jeruk Segar',
    deskripsi: 'Jus jeruk murni tanpa gula tambahan.',
    harga: 25000,
    stok: 15,
    urlGambar:
        'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=500',
    ukuran: '500 ml',
  ),
  Elektronik(
    id: 'E01',
    nama: 'Blender Philips',
    deskripsi: 'Blender kuat dengan mata pisau baja.',
    harga: 450000,
    stok: 5,
    urlGambar:
        'https://images.unsplash.com/photo-1570222094114-28a9d88a27e6?w=500',
    masaGaransi: '1 Tahun',
  ),
];
