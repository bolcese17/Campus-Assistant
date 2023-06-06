import 'package:campus_assistant/colors.dart';
import 'package:campus_assistant/users_page.dart';
import 'package:campus_assistant/vendor_detail_menu.dart';
import 'package:campus_assistant/home_page.dart';
import 'package:campus_assistant/navigate.dart';
import 'package:campus_assistant/professor_detail_menu.dart';
import 'package:campus_assistant/register_page.dart';
import 'package:campus_assistant/settings.dart';
import 'package:campus_assistant/shuttle_page.dart';
// import 'package:campus_assistant/home_page.dart';
import 'package:campus_assistant/resource_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_assistant/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyARKCTBlt1LJ_DAkS4T8IpNUr7b6VC21-Q",
            authDomain: "campus-assistant-264b2.firebaseapp.com",
            projectId: "campus-assistant-264b2",
            storageBucket: "campus-assistant-264b2.appspot.com",
            messagingSenderId: "873283657623",
            appId: "1:873283657623:web:db1486e3ea73840b972ed2",
            measurementId: "G-T0NX8SP47K"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/foodVendors': (context) => const VendorDetailMenuState(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/navigate': (context) => const NavigatePage(),
        '/professor': (context) => const ProfessorDetailMenu(),
        '/register': (context) => const RegisterPage(),
        '/settings': (context) => const SettingsPage(),
        '/shuttle': (context) => const ShuttlePage(),
        '/resources': (context) => const ResourcePage(),
        //'/ratings': (context) => const RatingsPage(),
      },
      theme: ThemeData(
          primaryColor: backgroundBlue,
          scaffoldBackgroundColor: backgroundBlue),
      //home: const LoginPage(),
    );
  }
}
