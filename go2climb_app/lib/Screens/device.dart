import 'package:flutter/material.dart';
import 'package:go2climb_app/Screens/httpclient.dart';

import 'login.dart';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final HttpClient _httpClient = HttpClient();
  bool _isLoading = false;
  String deviceCode = "N/A";
  String state = "Disconnected";
  int batteryLevel = 0;
  int steps = 0;
  double distance = 0.0;
  int heartRate = 0;
  double temperature = 0.0;

  @override
  void initState() {
    super.initState();
    if (globalTouristId != null) {
      _fetchDeviceData(globalTouristId!);
    }
  }

  Future<void> _fetchDeviceData(int bootId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _httpClient.getRequest('/boots/$bootId');
      if (response.statusCode == 200) {
        var data = response.data;

        setState(() {
          deviceCode = data['code'].toString();
          state = data['state'] ?? 'Disconnected';
          batteryLevel = data['batery'] ?? 0;
          steps = data['steps'] ?? 0;
          distance = (data['distance'] as num).toDouble();
          heartRate = data['heartRate'] ?? 0;
          temperature = (data['temperature'] as num).toDouble();
          _isLoading = false;
        });
      } else {
        setState(() {
          state = 'Failed to fetch device data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        state = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF223240),
        title: Text('Device Screen', style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.code, color: Colors.blue),
                title: Text('Device Code'),
                subtitle: Text(deviceCode),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.info, color: Colors.green),
                title: Text('State'),
                subtitle: Text(state),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.battery_full, color: Colors.yellow),
                title: Text('Battery Level'),
                subtitle: Text('$batteryLevel%'),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.directions_walk, color: Colors.purple),
                title: Text('Steps'),
                subtitle: Text(steps.toString()),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.map, color: Colors.red),
                title: Text('Distance Traveled'),
                subtitle: Text('${distance.toStringAsFixed(3)} km'),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.favorite, color: Colors.pink),
                title: Text('Heart Rate'),
                subtitle: Text('$heartRate BPM'),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                leading: Icon(Icons.thermostat, color: Colors.orange),
                title: Text('Temperature'),
                subtitle: Text('${temperature.toStringAsFixed(1)} °C'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}