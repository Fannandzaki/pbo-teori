import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
// Sesuaikan path ini jika folder constants kamu ada di tempat lain
import '../../constants/color_constant.dart';

class InputWidget extends StatelessWidget {
  // 1. Ganti 'lable' jadi 'hint' agar sesuai dengan panggilan di halaman lain
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;

  // 2. Tambahkan properti ini untuk dukungan input angka (Harga/Stok)
  final bool isNumber;

  const InputWidget({
    super.key,
    required this.hint, // Wajib diisi
    this.controller,
    this.isPassword = false,
    this.isNumber = false, // Default false (teks biasa)
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tampilkan Hint sebagai Label Judul
        Text(hint,
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorConstant.textTitle)),
        const Gap(8),
        Container(
          decoration: BoxDecoration(
            color: ColorConstant.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            // 3. Logika Keyboard: Jika isNumber true, munculkan keyboard angka
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: 'Masukkan $hint',
              hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
            ),
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
