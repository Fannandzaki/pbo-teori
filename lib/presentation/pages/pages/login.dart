import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ta_pbo/constants/color_constant.dart';
import 'package:ta_pbo/presentation/widget/input_widget.dart';
import 'package:ta_pbo/presentation/widget/tombol.dart';
// Import halaman tujuan
import 'package:ta_pbo/presentation/pages/pages/admin_home.dart';
import 'package:ta_pbo/presentation/pages/pages/user_shop.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // 1. DATA ADMIN (Anggota Kelompok)
  // Orang-orang ini akan masuk ke Admin Dashboard (Bisa Tambah/Edit Barang)
  final Map<String, String> dataAdmin = {
    "fannan dzaki": "fannandzaki@indo.com",
    "ridho sinaga": "ridhosinaga@indo.com",
    "videa malika": "videamalika@indo.com",
    "ammar dzaky": "ammardzaky@indo.com",
    "keisya zuleyka": "keisyazuleyka@indo.com",
  };

  // 2. DATA USER BIASA (Pelanggan)
  // Orang-orang ini akan masuk ke Halaman Belanja (Hanya bisa Beli)
  final Map<String, String> dataUser = {
    "user": "user@indo.com", // Akun tester untuk User
    "budi santoso": "budi@gmail.com",
  };

  void _handleLogin() {
    // Normalisasi input (huruf kecil & hapus spasi ujung)
    String inputName = nameController.text.trim().toLowerCase();
    String inputEmail = emailController.text.trim();

    // Validasi Kosong
    if (inputName.isEmpty || inputEmail.isEmpty) {
      _showSnackBar("Nama dan Email tidak boleh kosong!", Colors.orange);
      return;
    }

    // --- LOGIKA CEK ADMIN ---
    if (dataAdmin.containsKey(inputName)) {
      // Jika nama ada di daftar Admin, cek emailnya
      if (dataAdmin[inputName] == inputEmail) {
        // Sukses -> Masuk Halaman Admin
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AdminHomePage()));
        return;
      } else {
        _showSnackBar(
            "Email salah! Cek email untuk admin $inputName", Colors.redAccent);
        return;
      }
    }

    // --- LOGIKA CEK USER BIASA ---
    if (dataUser.containsKey(inputName)) {
      // Jika nama ada di daftar User, cek emailnya
      if (dataUser[inputName] == inputEmail) {
        // Sukses -> Masuk Halaman Belanja
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const UserShopPage()));
        return;
      } else {
        _showSnackBar("Email user salah!", Colors.redAccent);
        return;
      }
    }

    // Jika tidak ada di kedua daftar
    _showSnackBar("Akun tidak terdaftar di sistem!", Colors.red);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
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
                Text(
                  'SMART Login',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: ColorConstant.textTitle,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(40),

                // Form Container
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
                        lable: 'Nama Lengkap',
                        controller: nameController,
                      ),
                      const Gap(16),
                      InputWidget(
                        lable: 'Alamat Email',
                        controller: emailController,
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
                // Petunjuk Kecil (Opsional, biar gampang tes)
                const Text(
                  "Hint: Login nama anggota kelompok untuk mode Admin,\natau 'user' untuk mode Belanja.",
                  textAlign: TextAlign.center,
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
