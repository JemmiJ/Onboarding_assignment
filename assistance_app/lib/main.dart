import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/repair_service_screen.dart';
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AssistanceApp());
}

class AssistanceApp extends StatelessWidget {
  const AssistanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '24/7 Assistance',
      theme: appTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/repair') {
          final service = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => RepairServiceScreen(service: service),
          );
        }
        return null;
      },
    );
  }
}
