import 'package:flutter/material.dart';
import 'item.dart';

class Draw extends StatelessWidget {
  final VoidCallback onSignOut;
  const Draw({
    super.key,
    required this.onSignOut,
  });
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xffCF4520),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: SizedBox(
                  height: 75,
                ),
              ),
              Item(
                icon: Icons.home,
                text: 'H O M E',
                onTap: () {
                  Navigator.of(context).pushNamed('/home');
                },
              ),
              const SizedBox(height: 20),
              Item(
                icon: Icons.edit,
                text: 'M A R K',
                onTap: () {
                  Navigator.of(context).pushNamed('/mark');
                },
              ),
              const SizedBox(height: 20),
              Item(
                icon: Icons.history,
                text: 'H I S T O R Y',
                onTap: () {
                  Navigator.of(context).pushNamed('/history');
                },
              ),
              const SizedBox(height: 20),
              Item(
                icon: Icons.info_outline,
                text: 'I N F O',
                onTap: () {
                  Navigator.of(context).pushNamed('/info');
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Item(
              icon: Icons.logout,
              text: 'L O G O U T',
              onTap: onSignOut,
            ),
          ),
        ],
      ),
    );
  }
}
