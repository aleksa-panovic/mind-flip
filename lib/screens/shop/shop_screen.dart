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
              _SectionTitle('Themes'),
              SizedBox(height: 12),
              _ThemeGrid(),
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
      children: const [
        Text(
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
          title: 'Classic',
          price: '\$2.99',
          icon: Icons.crop_portrait,
        ),
        _SkinCard(
          title: 'Ocean',
          price: '\$2.99',
          icon: Icons.water_drop,
        ),
        _SkinCard(
          title: 'Fire',
          price: '\$2.99',
          icon: Icons.local_fire_department,
        ),
        _SkinCard(
          title: 'Ice',
          price: '\$2.99',
          icon: Icons.ac_unit,
        ),
        _SkinCard(
          title: 'Rainbow',
          price: '\$4.99',
          icon: Icons.color_lens,
        ),
        _SkinCard(
          title: 'Neon',
          price: '\$4.99',
          icon: Icons.palette,
        ),
      ],
    );
  }
}

class _SkinCard extends StatelessWidget {
  const _SkinCard({
    required this.title,
    required this.price,
    required this.icon,
  });

  final String title;
  final String price;
  final IconData icon;

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
              child: Icon(icon, color: const Color(0xFF6A5AE0), size: 34),
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
              const Icon(Icons.attach_money, size: 16, color: Color(0xFF3BD27A)),
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

class _ThemeGrid extends StatelessWidget {
  const _ThemeGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.9,
      children: const [
        _ThemeCard(
          title: 'Galaxy',
          price: '500',
          icon: Icons.nights_stay,
          gradient: [Color(0xFF7B5CFF), Color(0xFF5C6CFF)],
        ),
        _ThemeCard(
          title: 'Forest',
          price: '450',
          icon: Icons.park,
          gradient: [Color(0xFF39D98A), Color(0xFF2BB673)],
        ),
        _ThemeCard(
          title: 'Beach',
          price: '500',
          icon: Icons.beach_access,
          gradient: [Color(0xFF54A8FF), Color(0xFF3C89E0)],
        ),
        _ThemeCard(
          title: 'Neon City',
          price: '550',
          icon: Icons.bolt,
          gradient: [Color(0xFFB45CFF), Color(0xFF8B4BE3)],
        ),
        _ThemeCard(
          title: 'Winter',
          price: '450',
          icon: Icons.ac_unit,
          gradient: [Color(0xFF5AC8FA), Color(0xFF4A78FF)],
        ),
        _ThemeCard(
          title: 'Cherry Blossom',
          price: '500',
          icon: Icons.local_florist,
          gradient: [Color(0xFFFF7EB3), Color(0xFFFF4D7E)],
        ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.title,
    required this.price,
    required this.icon,
    required this.gradient,
  });

  final String title;
  final String price;
  final IconData icon;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Center(
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF2F2B3A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.diamond, size: 16, color: Color(0xFF49E3FF)),
                    const SizedBox(width: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        color: Color(0xFF2F2B3A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    const _BuyButton(
                      label: 'Buy',
                      color: Color(0xFFB15CFF),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
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
