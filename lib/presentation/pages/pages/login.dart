import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/color_constant.dart';
import '../../widget/input_widget.dart';
import '../../widget/tombol.dart';
import 'admin_home.dart';
import 'user_shop.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // --- 1. DATA OWNER (JURAGAN) - Cuma Pantau ---
  final Map<String, String> dataOwner = {
    "juragan": "123",
  };

  // --- 2. DATA GUDANG (Back Office) - Kelola Stok ---
  final Map<String, String> dataGudang = {
    "gudang": "123",
    "admin": "123",
  };

  // --- 3. DATA KASIR (Front Office) - Jualan ---
  final Map<String, String> dataKasir = {
    "kasir": "123",
    "fannan": "123", // Anggap Fannan sedang shift kasir
  };

  void _handleLogin() {
    String inputName = nameController.text.trim().toLowerCase();
    String inputPass = passController.text.trim();

    if (inputName.isEmpty || inputPass.isEmpty) {
      _showSnackBar("Username dan Password harus diisi!", Colors.orange);
      return;
    }

    // A. LOGIN JURAGAN
    if (dataOwner.containsKey(inputName) && dataOwner[inputName] == inputPass) {
      _showSnackBar("Selamat Datang Juragan!", Colors.purple);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const AdminHomePage(role: 'owner')),
      );
      return;
    }

    // B. LOGIN GUDANG
    if (dataGudang.containsKey(inputName) &&
        dataGudang[inputName] == inputPass) {
      _showSnackBar("Login Berhasil: Mode GUDANG", Colors.blue);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const AdminHomePage(role: 'gudang')),
      );
      return;
    }

    // C. LOGIN KASIR (Kirim Nama Kasir ke Halaman Shop)
    if (dataKasir.containsKey(inputName) && dataKasir[inputName] == inputPass) {
      _showSnackBar("Login Berhasil: Mode KASIR", Colors.green);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => UserShopPage(namaKasir: inputName)),
      );
      return;
    }

    _showSnackBar("Username atau Password tidak ditemukan!", Colors.red);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.storefront, size: 80, color: Colors.blue),
                const Gap(20),
                Text(
                  'Sistem POS Warung',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: ColorConstant.textTitle,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Masuk sebagai Juragan, Gudang, atau Kasir',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                ),
                const Gap(40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ]),
                  child: Column(
                    children: [
                      InputWidget(
                        hint: 'Username',
                        controller: nameController,
                      ),
                      const Gap(16),
                      InputWidget(
                        hint: 'Password',
                        controller: passController,
                        isPassword: true,
                      ),
                      const Gap(30),
                      Tombol(
                        text: 'Masuk',
                        isFullwidth: true,
                        onPressed: _handleLogin,
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                const Text(
                  "Hint: gudang/123, kasir/123, atau juragan/123",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
