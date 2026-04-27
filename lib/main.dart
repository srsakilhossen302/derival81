import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // Added Stripe import

import 'View/Screen/Splash/view/splash_screen.dart';
import 'View/Screen/Language/controller/language_controller.dart';
import 'Utils/Translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Stripe
  Stripe.publishableKey = 'pk_test_51PMl7aA8YgpuhNcIUjpXyNGiSUtjWHVMnPiPDiPYsSsy2cUH4O9hKRWvD8nHLw26nsSEfH6vr4r4UoLOdpCTwIow00pDm3FDpn'; // Replace with your actual publishable key
  
  // Initialize LanguageController early to apply locale
  final languageController = Get.put(LanguageController());
  await languageController.loadLanguage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(377, 940),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        final languageController = Get.find<LanguageController>();
        return GetMaterialApp(
          title: 'Derival81',
          debugShowCheckedModeBanner: false,
          translations: AppTranslations(),
          locale: languageController.currentLocale.value,
          fallbackLocale: const Locale('en', 'US'),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1A227F),
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
