import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../Home/view/home_screen.dart';
import '../../Auth/login/view/login_screen.dart';
import '../../Language/controller/language_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LanguageController _languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Show splash for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    String? token = await PrefsHelper.getString(PrefsHelper.token);

    if (token != null && token.isNotEmpty) {
      Get.offAll(() => HomeScreen());
    } else {
      Get.offAll(() =>  LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/Apps-Logo.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
