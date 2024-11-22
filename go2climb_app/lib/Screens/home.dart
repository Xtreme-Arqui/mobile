import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:go2climb_app/Screens/httpclient.dart';
import 'login.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final HttpClient _httpClient = HttpClient();
  int steps = 0;
  double distance = 0.0;
  int heartRate = 0;
  String state = 'Disconnected';
  int batteryLevel = 0;
  bool isLoading = true;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat();

    if (globalTouristId != null) {
      _fetchBootData(globalTouristId!); // Usamos el touristId guardado
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateAnimationSpeed(int bpm) {
    int duration = max(300, (60000 / bpm).round());
    _controller.duration = Duration(milliseconds: duration);
    _controller.repeat();
  }

  Future<void> _fetchBootData(int bootId) async {
    try {
      final response = await _httpClient.getRequest('/boots/$bootId');
      if (response.statusCode == 200) {
        var bootData = response.data;
        setState(() {
          steps = bootData['steps'] ?? 0;
          distance = (bootData['distance'] as num).toDouble();
          heartRate = bootData['heartRate'] ?? 0;
          state = bootData['state'] ?? 'Disconnected';
          batteryLevel = bootData['batery'] ?? 0;
          isLoading = false;
        });
        updateAnimationSpeed(heartRate);
      } else {
        setState(() {
          state = 'Failed to fetch boot data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        state = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              color: Color(0xFF223240),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'lib/assets/logo.png',
                            height: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'TravelSync',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          switch (value) {
                            case 'Profile':
                              Navigator.pushNamed(context, '/profile');
                              break;
                            case 'Account':
                              Navigator.pushNamed(context, '/account');
                              break;
                            case 'Devices':
                              Navigator.pushNamed(context, '/devices');
                              break;
                            case 'Log Out':
                              Navigator.pushNamed(context, '/logout');
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              value: 'Profile',
                              child: Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(width: 10),
                                  Text('Profile'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'Account',
                              child: Row(
                                children: [
                                  Icon(Icons.account_circle),
                                  SizedBox(width: 10),
                                  Text('Account'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'Devices',
                              child: Row(
                                children: [
                                  Icon(Icons.devices),
                                  SizedBox(width: 10),
                                  Text('Devices'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'Log Out',
                              child: Row(
                                children: [
                                  Icon(Icons.logout),
                                  SizedBox(width: 10),
                                  Text('Log Out'),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Device',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Image.asset(
                              'lib/assets/boots.png',
                              height: 70,
                            ),
                            SizedBox(width: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'G2C Boots Smart BS - 001A1',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.bluetooth, size: 16),
                                    SizedBox(width: 5),
                                    Text(state),
                                    SizedBox(width: 10),
                                    Icon(Icons.battery_full, size: 16),
                                    SizedBox(width: 5),
                                    Text('$batteryLevel%'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Health',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                          height: 140,
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularPercentIndicator(
                                radius: 50.0,
                                lineWidth: 8.0,
                                percent: (steps / 5000).clamp(0.0, 1.0),
                                center: Icon(Icons.directions_walk, size: 30),
                                progressColor: Colors.green,
                              ),
                              SizedBox(height: 5),
                              Text(
                                '$steps steps',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 140,
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularPercentIndicator(
                                radius: 50.0,
                                lineWidth: 8.0,
                                percent: (distance / 5.0).clamp(0.0, 1.0),
                                center: Icon(Icons.map, size: 30),
                                progressColor: Colors.green,
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${distance.toStringAsFixed(3)} km traveled',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
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
                        Text(
                          'Heart Rate',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 100,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: HeartbeatPainter(_controller, heartRate),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '$heartRate BPM',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeartbeatPainter extends CustomPainter {
  final Animation<double> animation;
  final int bpm;

  HeartbeatPainter(this.animation, this.bpm) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    Path path = Path();
    double centerY = size.height / 2;

    path.moveTo(0, centerY);
    for (double x = 0; x < size.width; x += 1) {
      double y = centerY + sin((x + animation.value * size.width) * 0.05) * 20;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
