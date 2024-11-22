import 'dart:io';

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
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/account': (context) => AccountScreen(),
        '/profile': (context) => ProfileScreen(),
        '/devices': (context) => DeviceScreen(),
        '/logout': (context) => LogoutScreen(),
      },
    );
  }
}
class LogoutScreen extends StatefulWidget {
  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  void initState() {
    super.initState();
    _scheduleLogout();
  }

  void _scheduleLogout() {
    // Espera 3 segundos antes de cerrar la aplicación
    Future.delayed(Duration(seconds: 3), () {
      exit(0); // Cierra la aplicación
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF223240),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/logo.png', // Asegúrate de tener el logo en esta ruta
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'See you soon',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}