import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ta_pbo/constants/color_constant.dart';

class InputWidget extends StatelessWidget {
  final String lable;
  final TextEditingController? controller; // Tambahan untuk logika
  final bool isPassword; // Tambahan opsi password

  const InputWidget({
    super.key,
    required this.lable,
    this.controller,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lable,
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorConstant.textTitle)),
        const Gap(8),
        Container(
          decoration: BoxDecoration(
            color: ColorConstant.background, // Background abu muda
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none, // Hilangkan garis border default
              ),
              hintText: 'Masukkan $lable',
              hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
            ),
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ),
        const Gap(20),
      ],
    );
  }
}
