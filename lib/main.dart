import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/recommendation_provider.dart';
import 'providers/order_provider.dart';

import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/password_reset_request_screen.dart';
import 'screens/password_reset_confirm_screen.dart';
import 'screens/register_screen.dart';
import 'screens/order_list_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => RecommendationProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _appLinks.uriLinkStream.listen((Uri uri) {
      _handleUri(uri);
    });
    _checkInitialLink();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkAuthStatus();
      setState(() {
        _isAuthenticated = authProvider.isAuthenticated;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkInitialLink() async {
    try {
      final uri = await _appLinks.getInitialAppLink();
      if (uri != null) _handleUri(uri);
    } catch (e) {}
  }

  void _handleUri(Uri uri) {
    if (uri.pathSegments.length >= 4 &&
        uri.pathSegments[0] == 'api' &&
        uri.pathSegments[1] == 'reset-password-confirm') {
      final uid = uri.pathSegments[2];
      final token = uri.pathSegments[3];
      if (navigatorKey.currentContext != null) {
        Navigator.of(navigatorKey.currentContext!).push(
          MaterialPageRoute(
            builder: (_) => PasswordResetConfirmScreen(uid: uid, token: token),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Smart Cart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        primaryColor: const Color(0xFF0A84FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0A84FF),
          secondary: Color(0xFF2C2C2E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C2C2E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A84FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF0A84FF)),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF2C2C2E),
          labelStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF38383A)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF38383A)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0A84FF)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_isAuthenticated ? const MainScreen() : const LoginScreen()),
      routes: {
        'login': (_) => const LoginScreen(),
        'register': (_) => const RegisterScreen(),
        'main': (_) => const MainScreen(),
        'home': (_) => const HomeScreen(),
        'products': (_) => const ProductListScreen(),
        'cart': (_) => const CartScreen(),
        'profile': (_) => const ProfileScreen(),
        'password-reset': (_) => const PasswordResetRequestScreen(),
        'orders': (_) => const OrderListScreen(),
      },
    );
  }
}
