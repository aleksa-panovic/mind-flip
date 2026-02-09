import 'package:flutter/material.dart';

import '../../widgets/gradient_header.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FB),
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
                    title: 'Card Skins (8/24)',
                    action: 'View All',
                  ),
                  SizedBox(height: 12),
                  _CardSkinGrid(),
                  SizedBox(height: 22),
                  _SectionHeader(
                    title: 'Themes (3/12)',
                    action: 'View All',
                  ),
                  SizedBox(height: 12),
                  _ThemeGrid(),
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
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2F2B3A),
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
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.9,
      children: const [
        _SkinTile(
          title: 'Classic',
          icon: Icons.crop_portrait,
          isSelected: true,
        ),
        _SkinTile(title: 'Ocean', icon: Icons.water_drop),
        _SkinTile(title: 'Fire', icon: Icons.local_fire_department),
        _SkinTile(title: 'Ice', icon: Icons.ac_unit),
        _SkinTile(title: 'Rainbow', icon: Icons.color_lens),
        _SkinTile(title: 'Neon', icon: Icons.palette),
      ],
    );
  }
}

class _SkinTile extends StatelessWidget {
  const _SkinTile({
    required this.title,
    required this.icon,
    this.isSelected = false,
  });

  final String title;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  child: Icon(icon, color: const Color(0xFF6A5AE0), size: 28),
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
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2F2B3A),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
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
      childAspectRatio: 1.05,
      children: const [
        _ThemeTile(
          title: 'Galaxy',
          icon: Icons.nights_stay,
          isEquipped: true,
        ),
        _ThemeTile(title: 'Forest', icon: Icons.park),
        _ThemeTile(title: 'Beach', icon: Icons.beach_access),
      ],
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.title,
    required this.icon,
    this.isEquipped = false,
  });

  final String title;
  final IconData icon;
  final bool isEquipped;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
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
            child: Center(
              child: Icon(icon, color: const Color(0xFF6A5AE0), size: 30),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2F2B3A),
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
    );
  }
}
