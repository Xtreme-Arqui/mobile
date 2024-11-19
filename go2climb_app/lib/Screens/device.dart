import 'package:flutter/material.dart';
import 'package:go2climb_app/Screens/httpclient.dart';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final HttpClient _httpClient = HttpClient();
  String _deviceStatus = 'Disconnected';
  String _batteryLevel = 'N/A';
  bool _isLoading = false;

  Future<void> _connectDevice() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _httpClient.postRequest('/api/v1/boots/connect', {
        "touristId": 1, // ejemplo de parámetro
      });

      if (response.statusCode == 200) {
        setState(() {
          _deviceStatus = 'Connected';
          _batteryLevel = response.data['battery'] ?? 'N/A';
        });
      } else {
        setState(() {
          _deviceStatus = 'Failed to Connect';
        });
      }
    } catch (e) {
      setState(() {
        _deviceStatus = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Status: $_deviceStatus',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Battery Level: $_batteryLevel',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _connectDevice,
                    child: Text('Connect'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}