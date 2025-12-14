import 'package:flutter/material.dart';
import 'package:ta_pbo/presentation/pages/pages/tampilan_awal.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TampilanAwal(),
    );
  }
}
