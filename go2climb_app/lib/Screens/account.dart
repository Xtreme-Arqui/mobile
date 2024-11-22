import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go2climb_app/Screens/httpclient.dart';

import 'login.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final HttpClient _httpClient = HttpClient();
  String email = '';
  String password = '';
  String photoUrl = '';
  bool isPasswordVisible = false;
  bool isEditing = false;
  bool isLoading = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (globalTouristId != null) {
      _fetchAccount(globalTouristId!);
    }
  }

  Future<void> _fetchAccount(int touristId) async {
    try {
      final response = await _httpClient.getRequest('/tourists/$touristId');
      if (response.statusCode == 200) {
        setState(() {
          email = response.data['email'] ?? '';
          password = response.data['password'] ?? '';
          photoUrl = response.data['photo'] ?? '';
          emailController.text = email;
          passwordController.text = password;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _updateAccount() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Realiza la solicitud GET para obtener todos los datos actuales del turista
      final response = await _httpClient.getRequest('/tourists/$globalTouristId');

      if (response.statusCode == 200) {
        final data = response.data;

        // Crear el objeto completo con los datos obtenidos y solo cambiar email y password
        final updatedData = {
          "id": data['id'],
          "name": data['name'],
          "lastName": data['lastName'],
          "email": emailController.text.isNotEmpty ? emailController.text : data['email'],
          "password": passwordController.text.isNotEmpty ? passwordController.text : data['password'],
          "phoneNumber": data['phoneNumber'],
          "address": data['address'],
          "photo": data['photo'],
        };

        // Realiza la solicitud PUT para actualizar la información
        final updateResponse = await _httpClient.putRequest('/tourists/$globalTouristId', updatedData);

        if (updateResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cuenta actualizada exitosamente')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar la cuenta: ${updateResponse.statusCode}')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con el servidor: $e')),
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
      appBar: AppBar(
        backgroundColor: Color(0xFF223240),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Account', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit, color: Colors.white),
            onPressed: () {
              if (isEditing) {
                _updateAccount(); // Save changes
              } else {
                setState(() {
                  isEditing = true; // Enter edit mode
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFF223240),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Photo
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: photoUrl.isNotEmpty
                            ? NetworkImage(photoUrl)
                            : null,
                        child: photoUrl.isEmpty
                            ? Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey,
                        )
                            : null,
                      ),
                      SizedBox(height: 20),
                      // Email
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: isEditing
                                ? TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            )
                                : Text(
                              email,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Password
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Password:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: isEditing
                                ? TextField(
                              controller: passwordController,
                              obscureText: !isPasswordVisible,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            )
                                : Text(
                              isPasswordVisible ? password : '*******',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
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