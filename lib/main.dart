import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const ArFoodMenuApp());

class ArFoodMenuApp extends StatelessWidget {
  const ArFoodMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF6B21A8); // brand purple
    return MaterialApp(
      title: 'AR Food Menu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          primary: seed,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
