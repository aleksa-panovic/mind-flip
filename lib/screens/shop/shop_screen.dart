import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/skin_provider.dart';
import '../../widgets/fade_slide_in.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _TitleBar(),
              SizedBox(height: 18),
              _SectionTitle('Card Skins'),
              SizedBox(height: 12),
              _SkinGrid(),
              SizedBox(height: 20),
              _SectionTitle('Card Back Skins'),
              SizedBox(height: 12),
              _BackSkinGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar();

  @override
  Widget build(BuildContext context) {
    final diamonds = context.watch<SkinProvider>().diamonds;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1F7),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(Icons.chevron_left, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Shop',
          style: TextStyle(
            color: onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Image.asset('assets/icons/diamond.png', width: 18, height: 18),
        const SizedBox(width: 6),
        Text(
          diamonds.toString(),
          style: TextStyle(
            color: onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Text(
      text,
      style: TextStyle(
        color: onSurface,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }
}

class _SkinGrid extends StatelessWidget {
  const _SkinGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.85,
      children: const [
        FadeSlideIn(
          delay: Duration(milliseconds: 0),
          child: _SkinCard(
            title: 'Animal',
            priceLabel: '\$3.99',
            assetPath: 'assets/card_skins/animal_skin/a1.png',
            skinKey: 'animal',
          ),
        ),
        FadeSlideIn(
          delay: Duration(milliseconds: 80),
          child: _SkinCard(
            title: 'Space',
            priceLabel: '\$5.99',
            assetPath: 'assets/card_skins/space_skin/s1.png',
            skinKey: 'space',
          ),
        ),
        FadeSlideIn(
          delay: Duration(milliseconds: 160),
          child: _SkinCard(
            title: 'Sport',
            priceLabel: '\$4.99',
            assetPath: 'assets/card_skins/sport_skin/Sp1.png',
            skinKey: 'sport',
          ),
        ),
      ],
    );
  }
}

class _BackSkinGrid extends StatelessWidget {
  const _BackSkinGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.85,
      children: const [
        FadeSlideIn(
          delay: Duration(milliseconds: 0),
          child: _SkinCard(
            title: 'Galaxy',
            diamondPrice: 1000,
            priceLabel: '1000',
            assetPath: 'assets/back_skins/galaxy_skin.png',
            isDiamond: true,
            skinKey: 'galaxy',
            isBack: true,
          ),
        ),
        FadeSlideIn(
          delay: Duration(milliseconds: 80),
          child: _SkinCard(
            title: 'Nature',
            diamondPrice: 2000,
            priceLabel: '2000',
            assetPath: 'assets/back_skins/nature skin.png',
            isDiamond: true,
            skinKey: 'nature',
            isBack: true,
          ),
        ),
        FadeSlideIn(
          delay: Duration(milliseconds: 160),
          child: _SkinCard(
            title: 'Lava',
            diamondPrice: 5000,
            priceLabel: '5000',
            assetPath: 'assets/back_skins/lava_skin.png',
            isDiamond: true,
            skinKey: 'lava',
            isBack: true,
          ),
        ),
      ],
    );
  }
}

class _SkinCard extends StatelessWidget {
  const _SkinCard({
    required this.title,
    this.priceLabel,
    this.diamondPrice,
    this.icon,
    this.assetPath,
    this.isDiamond = false,
    required this.skinKey,
    this.isBack = false,
  });

  final String title;
  final String? priceLabel;
  final int? diamondPrice;
  final IconData? icon;
  final String? assetPath;
  final bool isDiamond;
  final String skinKey;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    final skin = context.watch<SkinProvider>();
    final owned = isBack
        ? skin.ownedBackSkins.contains(skinKey)
        : skin.ownedFrontSets.contains(skinKey);
    final label = priceLabel ??
        (diamondPrice != null ? diamondPrice.toString() : '');
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 86,
            decoration: BoxDecoration(
              color: const Color(0xFFF2EAFE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: assetPath != null
                  ? Image.asset(assetPath!, width: 52, height: 52)
                  : Icon(icon, color: const Color(0xFF6A5AE0), size: 34),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              if (isDiamond)
                Image.asset(
                  'assets/icons/diamond.png',
                  width: 16,
                  height: 16,
                )
              else
                const Icon(Icons.attach_money,
                    size: 16, color: Color(0xFF3BD27A)),
              Text(
                label,
                style: TextStyle(
                  color: onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _BuyButton(
                label: owned ? 'Owned' : 'Buy',
                color: owned ? const Color(0xFFB8B6C9) : const Color(0xFF3BD27A),
                textColor: Colors.white,
                onTap: () async {
                  if (owned) return;
                  if (!isDiamond) {
                    _showInfo(context, 'Card skins will be purchasable later.');
                    return;
                  }
                  final ok = isBack
                      ? await skin.buyBackRemote(skinKey, diamondPrice ?? 0)
                      : skin.buyFront(skinKey, diamondPrice ?? 0);
                  if (!ok) {
                    _showNotEnoughDiamonds(context);
                  } else {
                    _showBought(context);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _BuyButton extends StatelessWidget {
  const _BuyButton({
    required this.label,
    required this.color,
    required this.textColor,
    this.onTap,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

void _showNotEnoughDiamonds(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF2F2B3A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          Image.asset(
            'assets/icons/diamond.png',
            width: 18,
            height: 18,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Not enough diamonds.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

void _showInfo(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF2F2B3A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
      duration: const Duration(seconds: 2),
    ),
  );
}

void _showBought(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF2F2B3A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: const Text(
        'Purchase successful!',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
