import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/game_result.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_provider.dart';
import '../../widgets/primary_gradient_button.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, this.result});

  final GameResult? result;

  @override
  Widget build(BuildContext context) {
    final routeResult =
        ModalRoute.of(context)?.settings.arguments as GameResult?;
    final data = result ?? routeResult;
    final score = data?.score ?? 1850;
    final timeSeconds = data?.timeSeconds ?? 154;
    final moves = data?.moves ?? 24;
    final combo = data?.bestCombo ?? 5;
    final coins = data?.coinsEarned ?? 250;
    final timeLabel =
        '${(timeSeconds ~/ 60)}:${(timeSeconds % 60).toString().padLeft(2, '0')}';
    return Scaffold(
      body: Stack(
        children: [
          const _ResultBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
              child: _ResultContent(
                score: score,
                timeLabel: timeLabel,
                moves: moves,
                combo: combo,
                coins: coins,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultBackground extends StatelessWidget {
  const _ResultBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6F79E8), Color(0xFF6A5AE0), Color(0xFF6A49C9)],
        ),
      ),
      child: Stack(
        children: const [
          _Sparkle(alignment: Alignment(-0.8, 0.1)),
          _Sparkle(alignment: Alignment(0.85, -0.1)),
          _Sparkle(alignment: Alignment(-0.3, -0.5)),
          _Sparkle(alignment: Alignment(0.25, 0.45)),
          _Sparkle(alignment: Alignment(-0.1, 0.85)),
        ],
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Icon(
        Icons.auto_awesome,
        size: 26,
        color: Colors.white.withOpacity(0.12),
      ),
    );
  }
}

class _ResultContent extends StatelessWidget {
  const _ResultContent({
    required this.score,
    required this.timeLabel,
    required this.moves,
    required this.combo,
    required this.coins,
  });

  final int score;
  final String timeLabel;
  final int moves;
  final int combo;
  final int coins;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        _IconBadge(
          child: const Icon(
            Icons.celebration,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'VICTORY!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'New Personal Best!',
          style: TextStyle(
            color: Color(0xFF9FF3FF),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 22),
        _ScoreCard(
          score: score,
          timeLabel: timeLabel,
          moves: moves,
          combo: combo,
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.diamond, color: Color(0xFF49E3FF)),
            const SizedBox(width: 8),
            Text(
              '+$coins Coins Earned!',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const Spacer(),
        PrimaryGradientButton(
          label: 'Play Again',
          onPressed: () {
            final rows = context.read<GameProvider>().lastRows;
            final cols = context.read<GameProvider>().lastCols;
            final route = (rows == 6 && cols == 6)
                ? '/game-6x6'
                : (rows == 6 && cols == 5)
                    ? '/game-5x6'
                    : '/game-4x4';
            Navigator.pushReplacementNamed(context, route);
          },
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            final user = context.read<AuthProvider>().currentUser;
            final route = user == null || user.role == UserRole.guest
                ? '/home-guest'
                : '/home-user';
            Navigator.pushReplacementNamed(context, route);
          },
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFD9D7FF),
          ),
          child: const Text(
            'Back to Home',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(child: child),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.score,
    required this.timeLabel,
    required this.moves,
    required this.combo,
  });

  final int score;
  final String timeLabel;
  final int moves;
  final int combo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _Star(),
              SizedBox(width: 8),
              _Star(),
              SizedBox(width: 8),
              _Star(),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Final Score',
            style: TextStyle(
              color: Color(0xFFD9D7FF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            score.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0x33FFFFFF)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(label: 'Time', value: timeLabel),
              _StatItem(label: 'Moves', value: moves.toString()),
              _StatItem(
                label: 'Combo',
                value: 'x$combo',
                valueColor: const Color(0xFF6FF3FF),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Star extends StatelessWidget {
  const _Star();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.star, color: Color(0xFFF9D34E), size: 24);
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFD9D7FF),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
