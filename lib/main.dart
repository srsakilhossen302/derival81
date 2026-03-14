import 'package:derival81/View/Screen/Auth/login/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'View/Screen/Auth/forgot_password/view/forgot_password_screen.dart';
import 'View/Screen/Auth/otp/view/otp_screen.dart';
import 'View/Screen/Home/view/home_screen.dart';

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
      // home: SignUpScreen(),
      home: LoginScreen(),
      getPages: [
        GetPage(name: '/forgot-password', page: () => ForgotPasswordScreen()),
        GetPage(name: '/otp', page: () => OtpScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
      ],
    );
  }
}
