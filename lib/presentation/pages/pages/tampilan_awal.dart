import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ta_pbo/constants/color_constant.dart';
import 'package:ta_pbo/presentation/pages/pages/login.dart';
import 'package:ta_pbo/presentation/widget/tombol.dart';

class TampilanAwal extends StatelessWidget {
  const TampilanAwal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Agar aman di layar kecil
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo (Pastikan file assets/logo.png ada, atau ganti Icon sementara)
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: ColorConstant.primary.withOpacity(0.1),
                        shape: BoxShape.circle),
                    // Jika belum ada gambar, pakai Icon ini:
                    child: Icon(Icons.shopping_bag_outlined,
                        size: 60, color: ColorConstant.primary),
                    // child: Image.asset('assets/logo.png'),
                  ),

                  const Gap(40),

                  Text(
                    'Bukan yang Asli,\nTapi Pas di Hati!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: ColorConstant.textTitle,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),

                  const Gap(16),

                  Text(
                    'Selamat Datang di Indomartku.\nBelanja hemat, dompet selamat.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: ColorConstant.textBody,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const Gap(50),

                  Tombol(
                    text: "Yuk Belanja",
                    isFullwidth: true,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
