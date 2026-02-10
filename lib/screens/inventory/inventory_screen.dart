import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/skin_provider.dart';
import '../../widgets/gradient_header.dart';
import '../../widgets/fade_slide_in.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: const [
          _Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Card Skins',
                    action: 'View All',
                  ),
                  SizedBox(height: 12),
                  _CardSkinGrid(),
                  SizedBox(height: 22),
                  _SectionHeader(
                    title: 'Card Back Skins',
                    action: 'View All',
                  ),
                  SizedBox(height: 12),
                  _BackSkinGrid(),
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
    return Container(
      child: GradientHeader(
        title: 'My Collection',
        leading: _HeaderIcon(
          icon: Icons.chevron_left,
          onTap: () => Navigator.pop(context),
        ),
        trailing: const SizedBox(width: 40),
        bottom: const _Tabs(),
      ),
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
          Expanded(child: _TabChip(label: 'All', isActive: true)),
          Expanded(child: _TabChip(label: 'Cards', isActive: false)),
          Expanded(child: _TabChip(label: 'Themes', isActive: false)),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          action,
          style: const TextStyle(
            color: Color(0xFF9B7BFF),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _CardSkinGrid extends StatelessWidget {
  const _CardSkinGrid();

  @override
  Widget build(BuildContext context) {
    final skin = context.watch<SkinProvider>();
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.9,
      children: [
        if (skin.ownedFrontSets.contains('emoji'))
          FadeSlideIn(
            delay: const Duration(milliseconds: 0),
            child: _SkinTile(
              title: 'Emoji (Default)',
              assetPath: 'assets/card_skins/emoji_skin/e1.png',
              isSelected: skin.currentFrontSet == 'emoji',
              onTap: () => skin.setFrontRemote('emoji'),
            ),
          ),
        if (skin.ownedFrontSets.contains('animal'))
          FadeSlideIn(
            delay: const Duration(milliseconds: 80),
            child: _SkinTile(
              title: 'Animal',
              assetPath: 'assets/card_skins/animal_skin/a1.png',
              isSelected: skin.currentFrontSet == 'animal',
              onTap: () => skin.setFrontRemote('animal'),
            ),
          ),
        if (skin.ownedFrontSets.contains('space'))
          FadeSlideIn(
            delay: const Duration(milliseconds: 160),
            child: _SkinTile(
              title: 'Space',
              assetPath: 'assets/card_skins/space_skin/s1.png',
              isSelected: skin.currentFrontSet == 'space',
              onTap: () => skin.setFrontRemote('space'),
            ),
          ),
        if (skin.ownedFrontSets.contains('sport'))
          FadeSlideIn(
            delay: const Duration(milliseconds: 240),
            child: _SkinTile(
              title: 'Sport',
              assetPath: 'assets/card_skins/sport_skin/Sp1.png',
              isSelected: skin.currentFrontSet == 'sport',
              onTap: () => skin.setFrontRemote('sport'),
            ),
          ),
      ],
    );
  }
}

class _SkinTile extends StatelessWidget {
  const _SkinTile({
    required this.title,
    this.icon,
    this.assetPath,
    this.isSelected = false,
    this.onTap,
  });

  final String title;
  final IconData? icon;
  final String? assetPath;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF37D07A) : Colors.transparent,
            width: 1.4,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 12,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EAFE),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: assetPath != null
                        ? Image.asset(assetPath!, width: 36, height: 36)
                        : Icon(icon, color: const Color(0xFF6A5AE0), size: 28),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.only(top: 6, right: 6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF37D07A),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.check, color: Colors.white, size: 12),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackSkinGrid extends StatelessWidget {
  const _BackSkinGrid();

  @override
  Widget build(BuildContext context) {
    final skin = context.watch<SkinProvider>();
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.05,
      children: [
        if (skin.ownedBackSkins.contains('default'))
          FadeSlideIn(
            delay: const Duration(milliseconds: 0),
            child: _BackSkinTile(
              title: 'Default',
              assetPath: 'assets/back_skins/default_skin.png',
              isEquipped: skin.currentBackSkin == 'default',
              onTap: () => skin.setBackRemote('default'),
            ),
          ),
        if (skin.ownedBackSkins.contains('galaxy'))
          FadeSlideIn(
            delay: const Duration(milliseconds: 80),
            child: _BackSkinTile(
              title: 'Galaxy',
              assetPath: 'assets/back_skins/galaxy_skin.png',
              isEquipped: skin.currentBackSkin == 'galaxy',
              onTap: () => skin.setBackRemote('galaxy'),
            ),
          ),
        if (skin.ownedBackSkins.contains('nature'))
          FadeSlideIn(
            delay: const Duration(milliseconds: 160),
            child: _BackSkinTile(
              title: 'Nature',
              assetPath: 'assets/back_skins/nature skin.png',
              isEquipped: skin.currentBackSkin == 'nature',
              onTap: () => skin.setBackRemote('nature'),
            ),
          ),
        if (skin.ownedBackSkins.contains('lava'))
          FadeSlideIn(
            delay: const Duration(milliseconds: 240),
            child: _BackSkinTile(
              title: 'Lava',
              assetPath: 'assets/back_skins/lava_skin.png',
              isEquipped: skin.currentBackSkin == 'lava',
              onTap: () => skin.setBackRemote('lava'),
            ),
          ),
      ],
    );
  }
}

class _BackSkinTile extends StatelessWidget {
  const _BackSkinTile({
    required this.title,
    required this.assetPath,
    this.isEquipped = false,
    this.onTap,
  });

  final String title;
  final String assetPath;
  final bool isEquipped;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isEquipped ? const Color(0xFF37D07A) : Colors.transparent,
            width: 1.4,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 12,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFF2EAFE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(assetPath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            if (isEquipped) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF37D07A),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'EQUIPPED',
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
      ),
    );
  }
}
