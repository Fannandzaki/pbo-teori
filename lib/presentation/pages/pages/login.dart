import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ta_pbo/constants/color_constant.dart';
import 'package:ta_pbo/presentation/pages/pages/discover_page.dart';
import 'package:ta_pbo/presentation/widget/input_widget.dart';
import 'package:ta_pbo/presentation/widget/tombol.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // DATA ANGGOTA & EMAILNYA
  // Format: 'nama lengkap (huruf kecil)': 'emailnya'
  final Map<String, String> dataAnggota = {
    "fannan dzaki": "fannandzaki@indo.com",
    "ridho sinaga": "ridhosinaga@indo.com",
    "videa malika": "videamalika@indo.com",
    "ammar dzaky": "ammardzaky@indo.com",
    "keisya zuleyka": "keisyazuleyka@indo.com",
  };

  void _handleLogin() {
    // Ambil input dan ubah nama ke huruf kecil agar tidak sensitif huruf besar/kecil
    String inputName = nameController.text.trim().toLowerCase();
    String inputEmail = emailController.text.trim();

    // 1. Validasi Input Kosong
    if (inputName.isEmpty || inputEmail.isEmpty) {
      _showSnackBar("Nama dan Email tidak boleh kosong!", Colors.orange);
      return;
    }

    // 2. Cek apakah Nama terdaftar di Map dataAnggota
    if (!dataAnggota.containsKey(inputName)) {
      _showSnackBar("Nama tidak terdaftar sebagai anggota!", Colors.redAccent);
      return;
    }

    // 3. Ambil email asli milik nama tersebut dari Map
    String? correctEmail = dataAnggota[inputName];

    // 4. Cek apakah email yang diketik cocok dengan email aslinya
    if (inputEmail != correctEmail) {
      _showSnackBar(
          "Email salah! Email untuk $inputName seharusnya $correctEmail",
          Colors.redAccent);
      return;
    }

    // Login Berhasil
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const DiscoverPage(),
      ),
    );
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
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
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
                  'Siapa Namamu?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: ColorConstant.textTitle,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(40),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
                        text: 'Login',
                        isFullwidth: true,
                        onPressed: _handleLogin,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
