import 'package:contacts/home.dart';
import 'package:contacts/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool? isLoggedIn = pref.getBool("isLoggedIn") ?? false;

  runApp(MyApp(token: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool token;

  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: token ? Home() : LoginPage(),
    );
  }
}
