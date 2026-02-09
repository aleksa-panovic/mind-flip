import 'package:flutter/material.dart';

class HomeGuestScreen extends StatefulWidget {
  const HomeGuestScreen({super.key});

  @override
  State<HomeGuestScreen> createState() => _HomeGuestScreenState();
}

class _HomeGuestScreenState extends State<HomeGuestScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4600),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              _Background(progress: _controller.value),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(
                        onSignIn: () {
                          Navigator.of(context).pushNamed('/login');
                        },
                      ),
                      const SizedBox(height: 24),
                      const Spacer(),
                      _LogoCard(offset: _floatAnim.value),
                      const SizedBox(height: 18),
                      const _TitleBlock(),
                      const SizedBox(height: 24),
                      _PlayButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/game-4x4');
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Sign in to save progress & compete!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFC9C7FF),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const _ChampionCard(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final t = progress;
    final drift = (t - 0.5) * 0.25;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1 + drift, -1 - drift),
          end: Alignment(1 - drift, 1 + drift),
          colors: const [
            Color(0xFF6F79E8),
            Color(0xFF6A5AE0),
            Color(0xFF6A49C9),
          ],
        ),
      ),
      child: Stack(
        children: [
          _GlowBlob(
            alignment: Alignment(-0.8 + drift, -0.6 - drift),
            color: const Color(0x332AD7FF),
            size: 190,
          ),
          _GlowBlob(
            alignment: Alignment(0.9 - drift, 0.25 + drift),
            color: const Color(0x332AFF9E),
            size: 170,
          ),
          _GlowBlob(
            alignment: Alignment(-0.15 - drift, 0.85 - drift),
            color: const Color(0x332A9BFF),
            size: 230,
          ),
          _GlowBlob(
            alignment: Alignment(0.2 + drift, -0.2),
            color: const Color(0x2200B3FF),
            size: 240,
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({
    required this.alignment,
    required this.color,
    required this.size,
  });

  final Alignment alignment;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome!',
                style: TextStyle(
                  color: Color(0xFFD9D7FF),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Guest Player',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onSignIn,
          style: TextButton.styleFrom(
            backgroundColor: const Color(0x66FFFFFF),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: const StadiumBorder(),
          ),
          child: const Text(
            'Sign In',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _LogoCard extends StatelessWidget {
  const _LogoCard({required this.offset});

  final double offset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: Offset(0, offset),
        child: Image.asset(
          'assets/images/logo.png',
          width: 260,
          height: 260,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'MindFlip',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Train Your Brain',
          style: TextStyle(
            color: Color(0xFF54E5FF),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF22D6E0), Color(0xFF4CE27A)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x5522D6E0),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          icon: const Icon(Icons.sports_esports, color: Colors.white),
          label: const Text(
            'Play as Guest',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChampionCard extends StatelessWidget {
  const _ChampionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0x3BFFFFFF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC930),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.emoji_events, color: Colors.white),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Champion",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ProGamer99 • 2,450 pts',
                  style: TextStyle(
                    color: Color(0xFFD9D7FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white70),
        ],
      ),
    );
  }
}
