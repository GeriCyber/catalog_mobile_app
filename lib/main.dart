import 'package:catalog_design/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:catalog_design/screens/screens.dart';
import 'package:catalog_design/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ItemsService()),
      ],
      child: LoginDesign(),
    );
  }
}

class LoginDesign extends StatelessWidget {
  const LoginDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey.shade300,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.deepPurple
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          elevation: 0
        )
      ),
      debugShowCheckedModeBanner: false,
      title: 'Catalog Design',
      initialRoute: 'login',
      routes: {
        'login': (_) => const LoginScreen(),
        'register': (_) => const RegisterScreen(),
        'home': (_) => const HomeScreen(),
        'item': (_) => const ItemScreen(),
        'checking': (_) => const CheckAuthScreen(),
      }
    );
  }
}