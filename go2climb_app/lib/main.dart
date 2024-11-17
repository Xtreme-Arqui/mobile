import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';
import 'dart:math';
void main() {
  runApp(Go2ClimbApp());
}

class Go2ClimbApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go2Climb',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/account': (context) => AccountScreen(),
        '/devices': (context) => DevicesScreen(),
        '/logout': (context) => LogoutScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  // Simulación de los streams que provienen del backend
  final Stream<int> stepsStream = (() {
    return Stream.periodic(Duration(seconds: 2), (count) => 1250 + count * 10); // Actualiza cada 2 segundos
  })();

  final Stream<double> distanceStream = (() {
    return Stream.periodic(Duration(seconds: 2), (count) => 1.5 + count * 0.01); // Actualiza cada 2 segundos
  })();

  // Streams simulados para el valor máximo
  final Stream<int> maxStepsStream = Stream.value(1500); // Máximo de pasos del recorrido (fijo)
  final Stream<double> maxDistanceStream = Stream.value(2.0); // Máxima distancia en km (fijo)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container con fondo azul para la parte superior
            Container(
              padding: EdgeInsets.all(16.0),
              color: Color(0xFF223240), // Aplicando el color de fondo personalizado
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo, título y menú de tres puntos
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
                            'Go2Climb',
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
                  // Device Section
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
                                    Text('Connected'),
                                    SizedBox(width: 10),
                                    Icon(Icons.battery_full, size: 16),
                                    SizedBox(width: 5),
                                    Text('60%'),
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
            // Health Section
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
                      // Steps Card with StreamBuilder for Steps and Max Steps
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
                          child: StreamBuilder<int>(
                            stream: stepsStream,
                            builder: (context, stepsSnapshot) {
                              int steps = stepsSnapshot.data ?? 0;
                              return StreamBuilder<int>(
                                stream: maxStepsStream,
                                builder: (context, maxStepsSnapshot) {
                                  int maxSteps = maxStepsSnapshot.data ?? 5000;
                                  double percent = (steps / maxSteps).clamp(0.0, 1.0); // Progreso normalizado
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 50.0,
                                        lineWidth: 8.0,
                                        percent: percent,
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
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      // Distance Traveled Card with StreamBuilder for Distance and Max Distance
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
                          child: StreamBuilder<double>(
                            stream: distanceStream,
                            builder: (context, distanceSnapshot) {
                              double distance = distanceSnapshot.data ?? 0.0;
                              return StreamBuilder<double>(
                                stream: maxDistanceStream,
                                builder: (context, maxDistanceSnapshot) {
                                  double maxDistance = maxDistanceSnapshot.data ?? 5.0;
                                  double percent = (distance / maxDistance).clamp(0.0, 1.0); // Progreso normalizado
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 50.0,
                                        lineWidth: 8.0,
                                        percent: percent,
                                        center: Icon(Icons.map, size: 30),
                                        progressColor: Colors.green,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${distance.toStringAsFixed(1)} km travels',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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





class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Surname'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Phone'),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Repeat password'),
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }
}

class DevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Devices'),
      ),
      body: Center(
        child: Text('Linked devices:\nBS - 001A1'),
      ),
    );
  }
}

class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('See you soon'),
      ),
    );
  }
}
