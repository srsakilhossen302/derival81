import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'View/Screen/Auth/login/view/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Derival81',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A227F)),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
