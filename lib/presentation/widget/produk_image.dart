// lib/presentation/widget/product_image.dart
import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Jika path kosong / null
    if (imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }

    // 2. Jika path adalah Asset (lokal project)
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (ctx, _, __) => _buildError(),
      );
    }

    // 3. Jika path adalah URL Internet (HTTP/HTTPS)
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (ctx, _, __) => _buildError(),
      );
    }

    // 4. Jika path adalah File Lokal (dari Galeri HP)
    // Cek kIsWeb agar tidak error jika dijalankan di Chrome
    if (kIsWeb) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (ctx, _, __) => _buildError(),
      );
    } else {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (ctx, _, __) => _buildError(),
      );
    }
  }

  Widget _buildError() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: Colors.grey),
          Text("Img Error", style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}