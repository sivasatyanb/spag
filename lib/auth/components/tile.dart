import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const Tile({
    super.key,
    required this.imagePath,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xffCF4520).withOpacity(0.2),
        ),
        child: Image.asset(
          imagePath,
          height: 40,
        ),
      ),
    );
  }
}
