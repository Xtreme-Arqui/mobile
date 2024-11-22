import 'package:flutter/material.dart';
import 'Screens/home.dart'; // Importa la pantalla Home
import 'Screens/account.dart';
import 'Screens/device.dart';
import 'Screens/profile.dart';
import 'Screens/login.dart';
void main() {
  runApp(Go2ClimbApp());
}

class Go2ClimbApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go2Climb App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(), // Usa la nueva HomeScreen importada
        '/home': (context) => HomeScreen(),
        '/account': (context) => AccountScreen(),
        '/profile': (context) => ProfileScreen(),
        '/devices': (context) => DeviceScreen(),
      },
    );
  }
}
