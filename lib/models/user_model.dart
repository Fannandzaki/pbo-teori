// lib/models/user_model.dart

abstract class User {
  final String id;
  final String username;
  final String password;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  String getInfo();
}

class Admin extends User {
  final String kodeAdmin;

  Admin({
    required super.id,
    required super.username,
    required super.password,
    required this.kodeAdmin,
  }) : super(role: 'admin');

  @override
  String getInfo() => "Admin: $username ($kodeAdmin)";

  // Method CRUD (Placeholder)
  void tambahProduk() => print("Logika tambah produk");
  void editProduk() => print("Logika edit produk");
  void hapusProduk() => print("Logika hapus produk");
}

class Customer extends User {
  String alamat;
  String noHp;
  double saldo;

  Customer({
    required super.id,
    required super.username,
    required super.password,
    required this.alamat,
    required this.noHp,
    required this.saldo,
  }) : super(role: 'customer');

  @override
  String getInfo() => "Customer: $username | Saldo: Rp $saldo";

  // Method untuk mengurangi saldo saat transaksi
  void kurangiSaldo(double jumlah) {
    if (saldo >= jumlah) {
      saldo -= jumlah;
    } else {
      throw Exception("Saldo tidak cukup!");
    }
  }
}
