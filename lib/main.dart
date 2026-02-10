import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
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
import 'screens/settings/settings_screen.dart';
import 'services/auth_service.dart';
import 'services/game_service.dart';
import 'services/firebase_auth_service.dart';
import 'services/firebase_db_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/game_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/game_provider.dart';
import 'providers/skin_provider.dart';
import 'providers/theme_provider.dart';
import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MindFlipApp());
}

class MindFlipApp extends StatelessWidget {
  const MindFlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => AuthRepository(
            AuthService(),
            firebaseAuth: FirebaseAuthService(),
            firebaseDb: FirebaseDbService(),
          ),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
        StreamProvider<UserModel?>(
          initialData: null,
          create: (_) => FirebaseAuthService().authStateChanges.asyncExpand(
                (u) {
                  if (u == null) return Stream.value(null);
                  return FirebaseDbService().userStream(u.uid).map((data) {
                    if (data == null) return null;
                    final ownedFront =
                        _readStringList(data['ownedFrontSets'], const ['emoji']);
                    final ownedBack =
                        _readStringList(data['ownedBackSkins'], const ['default']);
                    final currentFront =
                        _readString(data['currentFrontSet'], 'emoji');
                    final currentBack =
                        _readString(data['currentBackSkin'], 'default');
                    return UserModel(
                      id: u.uid,
                      username: data['username'] ?? 'User',
                      email: data['email'] ?? '',
                      diamonds: _readInt(data['diamonds'], 0),
                      bestScore: _readInt(data['bestScore'], 0),
                      lastScore: _readInt(data['lastScore'], 0),
                      ownedFrontSets: ownedFront,
                      ownedBackSkins: ownedBack,
                      currentFrontSet: currentFront,
                      currentBackSkin: currentBack,
                      role: data['role'] == 'admin'
                          ? UserRole.admin
                          : UserRole.user,
                    );
                  });
                },
              ),
        ),
        Provider<GameRepository>(
          create: (_) => GameRepository(
            GameService(),
            firebaseDb: FirebaseDbService(),
            firebaseAuth: FirebaseAuthService(),
          ),
        ),
        ChangeNotifierProvider<GameProvider>(
          create: (context) => GameProvider(context.read<GameRepository>()),
        ),
        ChangeNotifierProvider<SkinProvider>(
          create: (_) => SkinProvider(
            firebaseDb: FirebaseDbService(),
            firebaseAuth: FirebaseAuthService(),
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final fbUser = context.watch<UserModel?>();
          final auth = context.read<AuthProvider>();
          final skin = context.read<SkinProvider>();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (auth.currentUser?.id != fbUser?.id) {
              auth.setUser(fbUser);
            }
            if (fbUser != null) {
              skin.syncFromUser(fbUser);
            } else {
              skin.resetToDefaults();
            }
          });
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MindFlip',

            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF6A5AE0),
              ),
              primaryColor: const Color(0xFF6A5AE0),
              scaffoldBackgroundColor: Colors.white,
              cardColor: Colors.white,
              fontFamily: 'Poppins',
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF6A5AE0),
                brightness: Brightness.dark,
              ),
              primaryColor: const Color(0xFF6A5AE0),
              scaffoldBackgroundColor: const Color(0xFF0F1115),
              cardColor: const Color(0xFF1C1F26),
              fontFamily: 'Poppins',
            ),
            themeMode: context.watch<ThemeProvider>().mode,

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
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}

int _readInt(dynamic value, int fallback) {
  if (value is num) return value.toInt();
  return fallback;
}

String _readString(dynamic value, String fallback) {
  if (value is String && value.isNotEmpty) return value;
  return fallback;
}

List<String> _readStringList(dynamic value, List<String> fallback) {
  if (value is Iterable) {
    return value.whereType<String>().toList();
  }
  return fallback;
}
