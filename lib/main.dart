import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'models/app_mode.dart';
import 'screens/main_screen.dart';
import 'screens/simple_home_screen.dart';
import 'screens/tourist_home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const EasyWalletApp(),
    ),
  );
}

class EasyWalletApp extends StatelessWidget {
  const EasyWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        Widget homeScreen;
        switch (appProvider.currentMode) {
          case AppMode.tourist:
            homeScreen = const TouristHomeScreen();
            break;
          case AppMode.simple:
            homeScreen = const SimpleHomeScreen();
            break;
          case AppMode.normal:
            homeScreen = const MainScreen();
            break;
        }

        return MaterialApp(
          title: 'Easy Wallet',
          debugShowCheckedModeBanner: false,
          themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: Colors.grey[50],
            cardColor: Colors.white,
            useMaterial3: true,
            fontFamily: 'Roboto',
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            useMaterial3: true,
            fontFamily: 'Roboto',
          ),
          home: homeScreen,
        );
      },
    );
  }
}
