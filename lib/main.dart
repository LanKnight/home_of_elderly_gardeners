// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'providers/cart_provider.dart';

// Utils
import 'utils/constants.dart';

// Pages
import 'pages/auth/user_type_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/main/main_page.dart';
import 'pages/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            theme: themeProvider.currentTheme,
            initialRoute: AppConstants.routeHome,
            routes: {
              // Startup
              AppConstants.routeHome: (context) => const UserTypePage(),
              AppConstants.routeUserType: (context) => const UserTypePage(),

              // Main app
              AppConstants.routeMain: (context) => const MainPage(),

              // Auth
              AppConstants.routeRegister: (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                final userType = args is String ? args : '用户';
                return RegisterPage(userType: userType);
              },
              AppConstants.routeLogin: (context) => const LoginPage(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}