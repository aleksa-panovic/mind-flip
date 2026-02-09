import 'package:flutter/material.dart';

import '../../widgets/gradient_header.dart';
import '../../widgets/fade_slide_in.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: const [
          _Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                children: [
                  _TopThree(),
                  SizedBox(height: 18),
                  _LeaderboardList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return GradientHeader(
      title: 'Leaderboard',
      leading: _HeaderIcon(
        icon: Icons.chevron_left,
        onTap: () => Navigator.pop(context),
      ),
      trailing: _HeaderIcon(
        icon: Icons.filter_alt_outlined,
        onTap: () {},
      ),
      bottom: const _Tabs(),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: const [
          Expanded(
            child: _TabChip(
              label: 'Daily',
              isActive: true,
            ),
          ),
          Expanded(
            child: _TabChip(
              label: 'Weekly',
              isActive: false,
            ),
          ),
          Expanded(
            child: _TabChip(
              label: 'All Time',
              isActive: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF6A5AE0) : Colors.white70,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _TopThree extends StatelessWidget {
  const _TopThree();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const FadeSlideIn(
          delay: Duration(milliseconds: 0),
          child: _PodiumCard(
            rank: 2,
            name: 'GameQueen',
            score: '2,340',
            ringColor: Color(0xFFB9C1D9),
            medalColor: Color(0xFFE3E6F2),
            trophyAsset: 'assets/icons/second_place.png',
          ),
        ),
        const FadeSlideIn(
          delay: Duration(milliseconds: 80),
          child: _PodiumCard(
            rank: 1,
            name: 'ProGamer99',
            score: '2,450',
            ringColor: Color(0xFFF2C94C),
            medalColor: Color(0xFFF2C94C),
            isWinner: true,
            trophyAsset: 'assets/icons/first_place.png',
          ),
        ),
        const FadeSlideIn(
          delay: Duration(milliseconds: 160),
          child: _PodiumCard(
            rank: 3,
            name: 'MemoryKing',
            score: '2,280',
            ringColor: Color(0xFFFFA36C),
            medalColor: Color(0xFFFFA36C),
            trophyAsset: 'assets/icons/third_place.png',
          ),
        ),
      ],
    );
  }
}

class _PodiumCard extends StatelessWidget {
  const _PodiumCard({
    required this.rank,
    required this.name,
    required this.score,
    required this.ringColor,
    required this.medalColor,
    this.isWinner = false,
    this.trophyAsset,
  });

  final int rank;
  final String name;
  final String score;
  final Color ringColor;
  final Color medalColor;
  final bool isWinner;
  final String? trophyAsset;

  @override
  Widget build(BuildContext context) {
    final size = isWinner ? 84.0 : 64.0;
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ringColor.withOpacity(0.2),
            border: Border.all(color: ringColor, width: 3),
          ),
          child: Center(
            child: trophyAsset == null
                ? Icon(Icons.emoji_events, color: medalColor, size: 28)
                : Image.asset(
                    trophyAsset!,
                    width: isWinner ? 44 : 36,
                    height: isWinner ? 44 : 36,
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xFF2F2B3A),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          score,
          style: TextStyle(
            color: isWinner ? const Color(0xFF6A5AE0) : const Color(0xFF8F8DA6),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '#$rank',
          style: const TextStyle(
            color: Color(0xFFB8B6C9),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  const _LeaderboardList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        FadeSlideIn(
          delay: Duration(milliseconds: 0),
          child: _LeaderRow(
            rank: 4,
            name: 'FlipMaster',
            score: 'Best: 2,150',
            icon: Icons.sentiment_satisfied_alt,
          ),
        ),
        SizedBox(height: 12),
        FadeSlideIn(
          delay: Duration(milliseconds: 80),
          child: _LeaderRow(
            rank: 5,
            name: 'BrainWave',
            score: 'Best: 2,080',
            icon: Icons.psychology_alt,
          ),
        ),
        SizedBox(height: 12),
        FadeSlideIn(
          delay: Duration(milliseconds: 160),
          child: _LeaderRow(
            rank: 42,
            name: 'Alex_Pro',
            score: 'Best: 1,850',
            icon: Icons.sentiment_satisfied_alt,
            isYou: true,
          ),
        ),
        SizedBox(height: 12),
        FadeSlideIn(
          delay: Duration(milliseconds: 240),
          child: _LeaderRow(
            rank: 43,
            name: 'CardShark',
            score: 'Best: 1,820',
            icon: Icons.catching_pokemon,
          ),
        ),
        SizedBox(height: 12),
        FadeSlideIn(
          delay: Duration(milliseconds: 320),
          child: _LeaderRow(
            rank: 44,
            name: 'QuickMind',
            score: 'Best: 1,790',
            icon: Icons.flash_on,
          ),
        ),
      ],
    );
  }
}

class _LeaderRow extends StatelessWidget {
  const _LeaderRow({
    required this.rank,
    required this.name,
    required this.score,
    required this.icon,
    this.isYou = false,
  });

  final int rank;
  final String name;
  final String score;
  final IconData icon;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: isYou
            ? const Color(0xFFF2EAFE)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isYou ? const Color(0xFFB08CFF) : Colors.transparent,
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              '#$rank',
              style: TextStyle(
                color: isYou ? const Color(0xFF6A5AE0) : const Color(0xFF9AA0B4),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF6A5AE0)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: onSurface,
                      ),
                    ),
                    if (isYou) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A5AE0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'YOU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  score,
                  style: TextStyle(
                    color: onSurface.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFB8B6C9)),
        ],
      ),
    );
  }
}
