import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_spacing.dart';

class EmptyState extends StatelessWidget {
  final String svgPath;
  final String title;
  final String? subtitle;
  final double iconSize;

  const EmptyState({
    super.key,
    required this.svgPath,
    required this.title,
    this.subtitle,
    this.iconSize = 200,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.6,
              child: SvgPicture.asset(
                svgPath,
                width: iconSize,
                height: iconSize,
              ),
            ),

            AppSpacing.h16,

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: const Color.fromARGB(255, 81, 84, 86),
              ),
            ),

            if (subtitle != null) ...[
              AppSpacing.h4,
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
