import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ta_pbo/constants/color_constant.dart'; //
import 'package:ta_pbo/presentation/pages/pages/login.dart'; //
import 'package:ta_pbo/presentation/widget/tombol.dart'; //

class TampilanAwal extends StatelessWidget {
  const TampilanAwal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. Logo Icon: Diganti jadi Inventory/Box agar kesan manajemen stok dapat
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: ColorConstant.primary.withOpacity(0.1),
                        shape: BoxShape.circle),
                    child: Icon(Icons.inventory_2_outlined, // Icon Stok Barang
                        size: 60,
                        color: ColorConstant.primary),
                  ),

                  const Gap(40),

                  // 2. Judul Utama: SMART
                  Text(
                    'SMART',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: ColorConstant
                          .primary, // Pakai warna biru utama biar menonjol
                      fontSize: 42, // Lebih besar
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0, // Sedikit renggang biar elegan
                    ),
                  ),

                  // 3. Kepanjangan: Supermarket Management...
                  Text(
                    'Supermarket Management\n& Reporting Tool',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: ColorConstant.textTitle, // Warna hitam/gelap
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  const Gap(16),

                  // 4. Deskripsi Bahasa Indonesia
                  Text(
                    'Sistem Informasi Manajemen Stok Barang\npada Supermarket',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: ColorConstant.textBody, // Warna abu-abu
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const Gap(50),

                  // 5. Tombol Akses
                  Tombol(
                    text: "Masuk Dashboard", // Bahasanya lebih ke admin
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
