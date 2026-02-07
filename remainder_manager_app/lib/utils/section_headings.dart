import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  final String title;

  const SectionHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: const Color.fromARGB(221, 59, 55, 55),
            ),
      ),
    );
  }
}
