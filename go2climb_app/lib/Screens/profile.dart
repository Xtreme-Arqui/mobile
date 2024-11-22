import 'package:flutter/material.dart';
import 'package:go2climb_app/Screens/httpclient.dart';
import 'login.dart';


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
    if (globalTouristId != null) {
      _getProfile(globalTouristId!);
    }
  }

  Future<void> _getProfile(int touristId) async {
    try {
      final response = await _httpClient.getRequest('/tourists/$touristId'); // Usando el touristId global
      if (response.statusCode == 200) {
        setState(() {
          name = response.data['name'] ?? '';
          surname = response.data['lastName'] ?? '';
          address = response.data['address'] ?? '';
          phone = response.data['phoneNumber']?.toString() ?? '';
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
        title: Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Color(0xFF223240),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileDetail('Name:', name),
                      _buildProfileDetail('Surname:', surname),
                      _buildProfileDetail('Address:', address),
                      _buildProfileDetail('Phone:', phone),
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

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.all(12.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
