import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FB),
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
        const Text(
          'Shop',
          style: TextStyle(
            color: Color(0xFF2F2B3A),
            fontSize: 22,
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
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF2F2B3A),
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
        _SkinCard(
          title: 'Animal',
          price: '\$3.99',
          assetPath: 'assets/card_skins/animal_skin/a1.png',
        ),
        _SkinCard(
          title: 'Space',
          price: '\$5.99',
          assetPath: 'assets/card_skins/space_skin/s1.png',
        ),
        _SkinCard(
          title: 'Sport',
          price: '\$4.99',
          assetPath: 'assets/card_skins/sport_skin/Sp1.png',
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
        _SkinCard(
          title: 'Galaxy',
          price: '1000',
          assetPath: 'assets/back_skins/galaxy_skin.png',
          isDiamond: true,
        ),
        _SkinCard(
          title: 'Nature',
          price: '2000',
          assetPath: 'assets/back_skins/nature skin.png',
          isDiamond: true,
        ),
        _SkinCard(
          title: 'Lava',
          price: '5000',
          assetPath: 'assets/back_skins/lava_skin.png',
          isDiamond: true,
        ),
      ],
    );
  }
}

class _SkinCard extends StatelessWidget {
  const _SkinCard({
    required this.title,
    required this.price,
    this.icon,
    this.assetPath,
    this.isDiamond = false,
  });

  final String title;
  final String price;
  final IconData? icon;
  final String? assetPath;
  final bool isDiamond;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
            style: const TextStyle(
              color: Color(0xFF2F2B3A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              isDiamond
                  ? Image.asset(
                      'assets/icons/diamond.png',
                      width: 16,
                      height: 16,
                    )
                  : const Icon(Icons.attach_money,
                      size: 16, color: Color(0xFF3BD27A)),
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xFF2F2B3A),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _BuyButton(
                label: 'Buy',
                color: Color(0xFF3BD27A),
                textColor: Colors.white,
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
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
