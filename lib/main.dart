import 'package:flutter/material.dart';
import 'package:ta_pbo/presentation/pages/pages/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMART Supermarket',
      theme: ThemeData(useMaterial3: true),
      home: const Login(),
    );
  }
}
