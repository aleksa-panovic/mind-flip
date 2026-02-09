import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/game_provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.rows,
    required this.cols,
  });

  final int rows;
  final int cols;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<GameProvider>()
          .startGame(rows: widget.rows, cols: widget.cols);
    });
  }

  void _checkFinish(GameProvider provider) {
    if (provider.gameOver && !_navigated) {
      _navigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/result',
          arguments: provider.result,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, _) {
        _checkFinish(provider);
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6F79E8), Color(0xFF6A5AE0), Color(0xFF6A49C9)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  children: [
                    _TopBar(
                      matched: provider.matches,
                      totalPairs: (provider.rows * provider.cols) ~/ 2,
                      timeLabel: provider.formattedTime,
                    ),
                    const SizedBox(height: 14),
                    _ScoreBar(score: provider.currentScore),
                    const SizedBox(height: 18),
                    Expanded(
                      child: Center(
                        child: _GameGrid(
                          rows: provider.rows,
                          cols: provider.cols,
                          onTap: provider.flipCard,
                          isLocked: provider.isBusy,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _BottomStats(
                      moves: provider.moves,
                      combo: provider.bestCombo,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.matched,
    required this.totalPairs,
    required this.timeLabel,
  });

  final int matched;
  final int totalPairs;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleButton(
          icon: Icons.pause,
          onTap: () => Navigator.pop(context),
        ),
        const Spacer(),
        _Pill(
          icon: Icons.check_circle,
          label: '$matched/$totalPairs',
          color: const Color(0xFF47E6C1),
        ),
        const SizedBox(width: 10),
        _Pill(
          icon: Icons.timer,
          label: timeLabel,
          color: const Color(0xFFF2C94C),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Score',
              style: TextStyle(
                color: Color(0xFFD9D7FF),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              score.toString(),
              style: const TextStyle(
                color: Color(0xFF46E3FF),
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 8,
            color: Colors.white.withOpacity(0.25),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2CE1C3), Color(0xFF4DA3FF)],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GameGrid extends StatelessWidget {
  const _GameGrid({
    required this.rows,
    required this.cols,
    required this.onTap,
    required this.isLocked,
  });

  final int rows;
  final int cols;
  final bool isLocked;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();
    final cards = provider.cards;
    return SizedBox(
      width: 320,
      child: GridView.builder(
        itemCount: cards.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          mainAxisSpacing: rows >= 6 || cols >= 6 ? 8 : 10,
          crossAxisSpacing: rows >= 6 || cols >= 6 ? 8 : 10,
        ),
        itemBuilder: (context, index) {
          final card = cards[index];
          return GestureDetector(
            onTap: isLocked ? null : () => onTap(index),
            child: _GridTile(
              isRevealed: card.isFaceUp || card.isMatched,
              isMatched: card.isMatched,
              icon: card.icon,
            ),
          );
        },
      ),
    );
  }
}

class _GridTile extends StatelessWidget {
  const _GridTile({
    required this.isRevealed,
    required this.isMatched,
    required this.icon,
  });

  final bool isRevealed;
  final bool isMatched;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final bgColor = isRevealed
        ? Colors.white.withOpacity(0.85)
        : Colors.white.withOpacity(0.15);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMatched ? const Color(0xFF37D07A) : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isRevealed
              ? Icon(icon, color: const Color(0xFF6A5AE0), size: 26)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _BottomStats extends StatelessWidget {
  const _BottomStats({required this.moves, required this.combo});

  final int moves;
  final int combo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _StatItem(label: 'Moves', value: moves.toString(), valueColor: Colors.white),
          const _Divider(),
          _StatItem(
            label: 'Combo',
            value: 'x$combo',
            valueColor: const Color(0xFF46E3FF),
          ),
          const _Divider(),
          const _StatItem(label: 'Best', value: '1,850', valueColor: Color(0xFFF4C542)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withOpacity(0.2),
    );
  }
}
