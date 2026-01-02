// lib/presentation/widget/input_widget.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/color_constant.dart';

class InputWidget extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isNumber;
  final bool enabled; // Fitur baru: Kunci input jika false

  const InputWidget({
    super.key,
    required this.hint,
    this.controller,
    this.isPassword = false,
    this.isNumber = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hint,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ColorConstant.textTitle.withOpacity(0.7))),
        const Gap(6),
        Container(
          decoration: BoxDecoration(
            color: enabled ? ColorConstant.background : Colors.grey[200], // Warna abu jika disable
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            enabled: enabled, // Kunci field di sini
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              hintText: 'Masukkan $hint',
              hintStyle: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
            ),
            style: GoogleFonts.inter(
              fontSize: 14, 
              color: enabled ? Colors.black : Colors.grey[600]
            ),
          ),
        ),
      ],
    );
  }
}