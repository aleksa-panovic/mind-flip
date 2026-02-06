import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double progress = 0;
  Timer? timer;

  late final AnimationController _logoController;
  late final Animation<double> _logoOffset;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _logoOffset = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    timer = Timer.periodic(const Duration(milliseconds: 60), (t) {
      setState(() {
        progress += 0.01;
        if (progress > 1) progress = 1;
      });

      if (progress >= 1) {
        t.cancel();
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final barWidth = (screenW * 0.9).clamp(260.0, 420.0);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6A5AE0), Color(0xFF7C4DFF)],
              ),
            ),
          ),
          Positioned(top: 60, left: 30, child: _bubble(80, 0.10)),
          Positioned(top: 120, right: 40, child: _bubble(120, 0.08)),
          Positioned(bottom: 140, left: 50, child: _bubble(90, 0.07)),
          Positioned(bottom: 70, right: 30, child: _bubble(70, 0.06)),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _logoOffset.value),
                          child: child,
                        );
                      },
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 500,
                        height: 500,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'MindFlip',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Train Your Brain',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2CE1C3),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _GradientProgressBar(
                      width: barWidth,
                      height: 8,
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.22),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF4DA3FF), Color(0xFF2CE1C3)],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _GradientProgressBar extends StatelessWidget {
  final double width;
  final double height;
  final double value;
  final Color backgroundColor;
  final LinearGradient gradient;

  const _GradientProgressBar({
    required this.width,
    required this.height,
    required this.value,
    required this.backgroundColor,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    final fillWidth = width * v;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: backgroundColor)),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                curve: Curves.linear,
                width: fillWidth,
                decoration: BoxDecoration(gradient: gradient),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
