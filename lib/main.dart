import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/user_controller.dart';
import 'views/auth/login_screen.dart';
import 'views/splash/splash_screen.dart';
import 'package:sendotp_flutter_sdk/sendotp_flutter_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  OTPWidget.initializeWidget('366472744963323537333733', '509817TtVhJZWi4tna69e49329P1');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => UserController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TotalX Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
