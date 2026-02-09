import 'package:flutter/material.dart';

class GradientHeader extends StatelessWidget {
  const GradientHeader({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.bottom,
    this.padding = const EdgeInsets.fromLTRB(20, 16, 20, 20),
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Widget? bottom;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6F79E8), Color(0xFF6A5AE0), Color(0xFF6A49C9)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                leading ?? const SizedBox(width: 40),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                trailing ?? const SizedBox(width: 40),
              ],
            ),
            if (bottom != null) ...[
              const SizedBox(height: 16),
              bottom!,
            ],
          ],
        ),
      ),
    );
  }
}
