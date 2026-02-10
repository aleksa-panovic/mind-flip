import 'package:flutter/material.dart';

import '../../services/firebase_db_service.dart';
import '../../widgets/gradient_header.dart';
import 'admin_shop_items_screen.dart';
import 'admin_users_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: const [
          _Header(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 26, 20, 20),
              child: Column(
                children: [
                  _AdminUsersTile(),
                  SizedBox(height: 16),
                  _AdminShopTile(),
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
        title: 'Admin',
        leading: const SizedBox(width: 40),
        trailing: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _AdminUsersTile extends StatelessWidget {
  const _AdminUsersTile();

  @override
  Widget build(BuildContext context) {
    final db = FirebaseDbService();
    return StreamBuilder(
      stream: db.users().snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length ?? 0;
        return _AdminTile(
          icon: Icons.people,
          title: 'Users',
          subtitle: '$count total',
          colors: const [Color(0xFF35E2C0), Color(0xFF29B7D8)],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminUsersScreen(),
              ),
            );
          },
        );
      },
    );
  }
}

class _AdminShopTile extends StatelessWidget {
  const _AdminShopTile();

  @override
  Widget build(BuildContext context) {
    final db = FirebaseDbService();
    return StreamBuilder(
      stream: db.shopItems().snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length ?? 0;
        return _AdminTile(
          icon: Icons.shopping_bag,
          title: 'Shop Items',
          subtitle: '$count items',
          colors: const [Color(0xFFB068FF), Color(0xFFFF6CB2)],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminShopItemsScreen(),
              ),
            );
          },
        );
      },
    );
  }
}

class _AdminTile extends StatelessWidget {
  const _AdminTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manage',
                    style: TextStyle(
                      color: Color(0xFF8F8DA6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF8F8DA6),
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
      ),
    );
  }
}
