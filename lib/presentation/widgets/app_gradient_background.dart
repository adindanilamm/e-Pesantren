import 'package:flutter/material.dart';

class AppGradientBackground extends StatelessWidget {
  final Widget child;

  const AppGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE0F2F1), // Very light teal
            Color(0xFFF5F7FA), // White/Gray
          ],
          stops: [0.0, 0.3],
        ),
      ),
      child: child,
    );
  }
}
