import 'package:flutter/material.dart';

class TileWidget extends StatelessWidget {
  final bool isBlack;
  final VoidCallback onTap;

  const TileWidget({super.key, required this.isBlack, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(1.0),
        color: isBlack ? Colors.black : Colors.white,
      ),
    );
  }
}