import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/home/home_guest_screen.dart';
import 'screens/home/home_user_screen.dart';
import 'screens/game/game_4x4_screen.dart';
import 'screens/game/game_5x6_screen.dart';
import 'screens/game/game_6x6_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/result/result_screen.dart';
import 'screens/leaderboard/leaderboard_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/shop/shop_screen.dart';
import 'screens/inventory/inventory_screen.dart';
import 'screens/admin/admin_screen.dart';
import 'services/auth_service.dart';
import 'services/game_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/game_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/game_provider.dart';

void main() {
  runApp(const MindFlipApp());
}

class MindFlipApp extends StatelessWidget {
  const MindFlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => AuthRepository(AuthService())),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
        Provider<GameRepository>(create: (_) => GameRepository(GameService())),
        ChangeNotifierProvider<GameProvider>(
          create: (context) => GameProvider(context.read<GameRepository>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MindFlip',

        theme: ThemeData(
          primaryColor: const Color(0xFF6A5AE0),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Poppins',
        ),

        initialRoute: '/',

        routes: {
          '/': (context) => const SplashScreen(),

          '/login': (context) => const LoginScreen(),

          '/register': (context) => const RegisterScreen(),

          '/home-guest': (context) => const HomeGuestScreen(),
          '/home-user': (context) => const HomeUserScreen(),
          '/game-4x4': (context) => const Game4x4Screen(),
          '/game-5x6': (context) => const Game5x6Screen(),
          '/game-6x6': (context) => const Game6x6Screen(),
          '/result': (context) => const ResultScreen(),
          '/leaderboard': (context) => const LeaderboardScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/shop': (context) => const ShopScreen(),
          '/inventory': (context) => const InventoryScreen(),
          '/admin': (context) => const AdminScreen(),
        },
      ),
    );
  }
}
