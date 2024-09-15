import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;

  const Item({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          size: 50,
          color: Colors.white,
        ),
        title: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
