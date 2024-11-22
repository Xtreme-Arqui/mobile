import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go2climb_app/Screens/httpclient.dart'; // Importa el httpclient centralizado

// Variable global para guardar el touristId
dynamic globalTouristId;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final HttpClient httpClient = HttpClient();

  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await httpClient.getRequest('/tourists');

      if (response.statusCode == 200) {
        // Asegúrate de acceder a la lista dentro del campo "content"
        final data = response.data;
        final List<dynamic> tourists = data['content'] ?? [];

        // Busca el usuario en la lista
        final user = tourists.firstWhere(
              (tourist) =>
          tourist['email'] == emailController.text &&
              tourist['password'] == passwordController.text,
          orElse: () => null,
        );

        if (user != null) {
          // Guarda el touristId en la variable global
          globalTouristId = user['id'];
          // Si el usuario es válido, navega a la pantalla principal
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Muestra un mensaje de error si las credenciales no coinciden
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Correo o contraseña inválidos. Intenta nuevamente.')),
          );
        }
      } else {
        // Manejo de error si el servidor no devuelve un código 200
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar sesión. Código: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Manejo de excepciones generales
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con el servidor: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF223240), // Fondo del color del proyecto
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo de la aplicación
                Image.asset(
                  'lib/assets/logo.png',
                  height: 100,
                ),
                SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 30),
                isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
