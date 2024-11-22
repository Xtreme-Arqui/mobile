import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go2climb_app/Screens/httpclient.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final HttpClient _httpClient = HttpClient();

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Por favor, ingrese el correo y la contraseña.");
      return;
    }

    try {
      // Llamamos al método para obtener todos los turistas
      Response response = await _httpClient.getAllTourists();
      if (response.statusCode == 200 && response.data != null) {
        // Buscamos al usuario con el email y la contraseña proporcionados
        List<dynamic> tourists = response.data;
        bool userFound = false;

        for (var tourist in tourists) {
          if (tourist['email'] == email && tourist['password'] == password) {
            userFound = true;
            break;
          }
        }

        if (userFound) {
          // Login exitoso, navega a la pantalla de inicio
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Usuario o contraseña incorrectos
          _showErrorDialog("Usuario o contraseña incorrectos.");
        }
      } else {
        _showErrorDialog("Error al obtener la información de los usuarios.");
      }
    } catch (e) {
      _showErrorDialog("Ha ocurrido un error inesperado. Verifica tu conexión.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Iniciar Sesión"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Correo electrónico"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _login,
              child: Text("Iniciar Sesión"),
            ),
          ],
        ),
      ),
    );
  }
}
