import 'package:flutter/material.dart';
import 'package:go2climb_app/Screens/httpclient.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final HttpClient _httpClient = HttpClient();
  String name = "";
  String surname = "";
  String address = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  Future<void> _getProfile() async {
    try {
      final response = await _httpClient.getRequest('tourists/1'); // Ejemplo de id
      if (response.statusCode == 200) {
        setState(() {
          name = response.data['name'] ?? '';
          surname = response.data['lastName'] ?? '';
          address = response.data['address'] ?? '';
          phone = response.data['phoneNumber'] ?? '';
        });
      }
    } catch (e) {
      print('Error: $e');
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
        title: Row(
          children: [
            Image.asset('lib/assets/logo.png', height: 30),
            SizedBox(width: 10),
          ],
        ),
      ),
      body: Container(
        color: Color(0xFF223240),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
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
                      _buildTextField(label: 'Name', value: name),
                      _buildTextField(label: 'Surname', value: surname),
                      _buildTextField(label: 'Address', value: address),
                      _buildTextField(label: 'Phone', value: phone),
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

  Widget _buildTextField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
