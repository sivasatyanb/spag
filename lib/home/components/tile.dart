import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Icon icon;
  final String text;
  final void Function()? onTap;
  const Tile({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xffCF4520).withOpacity(0.2),
            ),
            child: icon,
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
