import 'package:flutter/material.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/home/home_guest_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

void main() {
  runApp(const MindFlipApp());
}

class MindFlipApp extends StatelessWidget {
  const MindFlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
    );
  }
}
