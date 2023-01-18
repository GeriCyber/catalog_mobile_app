import 'package:flutter/material.dart';
import 'package:login_design/screens/screens.dart';

void main() => runApp(const LoginDesign());

class LoginDesign extends StatelessWidget {
  const LoginDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey.shade300
      ),
      debugShowCheckedModeBanner: false,
      title: 'Login Design',
      initialRoute: 'login',
      routes: {
        'login': (_) => const LoginScreen(),
        'home': (_) => const HomeScreen(),
      }
    );
  }
}