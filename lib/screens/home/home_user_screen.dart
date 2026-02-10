import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/action_tile.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/icon_chip.dart';
import '../../providers/skin_provider.dart';
import '../../widgets/fade_slide_in.dart';
import '../../providers/theme_provider.dart';
import '../../services/firebase_db_service.dart';

class HomeUserScreen extends StatelessWidget {
  const HomeUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-guest',
          (route) => false,
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _HeaderSection(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _PlayNowButton(),
                    const SizedBox(height: 18),
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        color: Color(0xFF2F2B3A),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 0),
                      child: ActionTile(
                        icon: Icons.leaderboard,
                        title: 'Ranks',
                        subtitle: 'Global leaderboard',
                        assetPath: 'assets/icons/rank.png',
                        onTap: () {
                          Navigator.pushNamed(context, '/leaderboard');
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 80),
                      child: ActionTile(
                        icon: Icons.shopping_bag,
                        title: 'Shop',
                        subtitle: 'Boosts & cosmetics',
                        assetPath: 'assets/icons/shopping-bag.png',
                        onTap: () {
                          Navigator.pushNamed(context, '/shop');
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 160),
                      child: ActionTile(
                        icon: Icons.inventory_2_outlined,
                        title: 'Inventory',
                        subtitle: 'Your collection',
                        assetPath: 'assets/icons/inventory.png',
                        onTap: () {
                          Navigator.pushNamed(context, '/inventory');
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _DailyGiftCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
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
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.pushNamed(context, '/admin');
                },
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF37E8B6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.sentiment_satisfied_alt,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    final name = auth.currentUser?.username ?? 'Guest';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back!',
                          style: TextStyle(
                            color: Color(0xFFE3E1FF),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              IconChip(
                icon: Icons.person_outline,
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              const SizedBox(width: 10),
              IconChip(
                icon: Icons.settings_outlined,
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
          const SizedBox(height: 18),
          Consumer<SkinProvider>(
            builder: (context, skin, _) {
              return Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Diamonds',
                      value: skin.diamonds.toString(),
                      icon: Icons.diamond,
                      assetPath: 'assets/icons/diamond.png',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Consumer<AuthProvider>(
                      builder: (context, auth, _) {
                        final best = auth.currentUser?.bestScore ?? 0;
                        return StatCard(
                          title: 'Best Score',
                          value: best.toString(),
                          icon: Icons.star,
                          assetPath: 'assets/icons/best_score.png',
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: FirebaseDbService().topLeaderboard(limit: 200),
                      builder: (context, snapshot) {
                        final data = snapshot.data ?? [];
                        final userId =
                            context.read<AuthProvider>().currentUser?.id;
                        final index =
                            data.indexWhere((e) => e['userId'] == userId);
                        final rankLabel =
                            index >= 0 ? '#${index + 1}' : '-';
                        return StatCard(
                          title: 'Rank',
                          value: rankLabel,
                          icon: Icons.emoji_events,
                          assetPath: 'assets/icons/rank.png',
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
            ],
          ),
        );
  }
}



class _PlayNowButton extends StatelessWidget {
  const _PlayNowButton();

  void _showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const _DifficultyDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF25D7E1), Color(0xFF43E47A)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3325D7E1),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => _showDifficultyDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/play.png',
                width: 28,
                height: 28,
              ),
              const SizedBox(width: 10),
              const Text(
                'PLAY NOW',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyDialog extends StatelessWidget {
  const _DifficultyDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 20,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Difficulty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2F2B3A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pick your grid size',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8F8DA6),
              ),
            ),
            const SizedBox(height: 16),
            _DifficultyButton(
              label: 'Easy 4x4',
              color: Color(0xFF3ED27A),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/game-4x4');
              },
            ),
            const SizedBox(height: 10),
            _DifficultyButton(
              label: 'Medium 5x6',
              color: Color(0xFFF4C542),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/game-5x6');
              },
            ),
            const SizedBox(height: 10),
            _DifficultyButton(
              label: 'Hard 6x6',
              color: Color(0xFFF25555),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/game-6x6');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}


class _DailyGiftCard extends StatelessWidget {
  const _DailyGiftCard();

  void _showDailyBonus(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const _DailyBonusDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDailyBonus(context),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7B5CFF), Color(0xFFDA4FFF)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x227B5CFF),
              blurRadius: 16,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/daily gift.png',
                  width: 36,
                  height: 36,
                ),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Gift',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap to claim your reward',
                    style: TextStyle(
                      color: Color(0xFFEADFFF),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _DailyBonusDialog extends StatelessWidget {
  const _DailyBonusDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 20,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F1F7),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Icon(Icons.close, size: 16),
                ),
              ),
            ),
            Image.asset(
              'assets/icons/daily gift.png',
              width: 56,
              height: 56,
            ),
            const SizedBox(height: 10),
            const Text(
              'Daily Bonus!',
              style: TextStyle(
                color: Color(0xFF2F2B3A),
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Claim your reward today',
              style: TextStyle(
                color: Color(0xFF8F8DA6),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2EAFE),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/diamond.png',
                        width: 26,
                        height: 26,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '+250',
                        style: TextStyle(
                          color: Color(0xFF6A5AE0),
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Diamonds',
                    style: TextStyle(
                      color: Color(0xFF8F8DA6),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      final isActive = index < 2;
                      return Container(
                        width: 26,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF37D07A)
                              : const Color(0xFFDDDFE9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Day 1', style: _DayLabel()),
                      Text('Day 2', style: _DayLabel()),
                      Text('Day 3', style: _DayLabel()),
                      Text('Day 4', style: _DayLabel()),
                      Text('Day 5', style: _DayLabel()),
                      Text('Day 6', style: _DayLabel()),
                      Text('Day 7', style: _DayLabel()),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF22D6E0), Color(0xFF4CE27A)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SkinProvider>().addDiamondsRemote(250);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You claimed 250 diamonds!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Claim Reward',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Next bonus in 24 hours',
              style: TextStyle(
                color: Color(0xFFB4B2C5),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayLabel extends TextStyle {
  const _DayLabel()
      : super(
          color: const Color(0xFF8F8DA6),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        );
}
