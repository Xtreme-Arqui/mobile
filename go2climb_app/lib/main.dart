import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
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
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
// Simulación de los streams que provienen del backend
final Stream<int> stepsStream = (() {
  return Stream.periodic(Duration(seconds: 2), (count) => 1250 + count * 10); // Actualiza cada 2 segundos
})();

final Stream<double> distanceStream = (() {
  return Stream.periodic(Duration(seconds: 2), (count) => 1.5 + count * 0.01); // Actualiza cada 2 segundos
})();

final Stream<int> bpmStream = (() {
  return Stream.periodic(Duration(seconds: 2), (count) => 60 + Random().nextInt(80)); // BPM entre 60 y 140
})();

// Streams simulados para el valor máximo
final Stream<int> maxStepsStream = Stream.value(1500); // Máximo de pasos del recorrido (fijo)
final Stream<double> maxDistanceStream = Stream.value(2.0); // Máxima distancia en km (fijo)

late AnimationController _controller;

@override
void initState() {
  super.initState();

  // Inicialización del AnimationController
  _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 1000), // Duración inicial (modificable)
  )..repeat(); // Repite indefinidamente
}

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

void updateAnimationSpeed(int bpm) {
  // Calcula la duración de la animación basada en los BPM (mayor BPM, menor duración)
  int duration = max(300, (60000 / bpm).round());
  _controller.duration = Duration(milliseconds: duration);
  _controller.repeat();
}

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
                SizedBox(height: 20),
                // Heart Rate Section
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
                  child: StreamBuilder<int>(
                    stream: bpmStream,
                    builder: (context, snapshot) {
                      int bpm = snapshot.data ?? 90;
                      updateAnimationSpeed(bpm); // Actualiza la velocidad de la animación según los BPM

                      return Column(
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
                              painter: HeartbeatPainter(_controller, bpm),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '$bpm BPM',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
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

    // Dibuja una señal de latido que oscila en el centro
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

class DevicesScreen extends StatefulWidget {
  @override
  _DevicesScreenState createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  List<String> linkedDevices = ['BS - 001A1'];
  List<String> availableDevices = ['BS - 001A2', 'BS - 001A3'];
  bool isSearching = false;

  void startSearching() {
    setState(() {
      isSearching = true;
    });

    // Simulación de búsqueda de dispositivos
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isSearching = false;
        availableDevices.add('BS - 001A4'); // Añadir un dispositivo simulado tras la búsqueda
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF223240),
        title: Row(
          children: [
            Image.asset(
              'lib/assets/logo.png',
              height: 30,
            ),
            SizedBox(width: 10),
            Text('Devices'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // More options action
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                startSearching();
              },
              icon: Icon(Icons.search),
              label: Text(isSearching ? 'Searching...' : 'Search for devices'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF223240),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Linked devices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: linkedDevices.map((device) {
                    return ListTile(
                      leading: Icon(Icons.bluetooth_connected, color: Colors.green),
                      title: Text(device),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Lógica de desconexión
                        },
                        child: Text('Disconnect'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Available devices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: availableDevices.map((device) {
                    return ListTile(
                      leading: Icon(Icons.bluetooth, color: Colors.blue),
                      title: Text(device),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Lógica de conexión
                          setState(() {
                            linkedDevices.add(device);
                            availableDevices.remove(device);
                          });
                        },
                        child: Text('Connect'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
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
