import 'package:flutter/material.dart';
import 'package:murni_bus_ticket/screens/home_screen.dart';
import 'package:murni_bus_ticket/screens/login_screen.dart';
import 'package:murni_bus_ticket/screens/register_screen.dart';
import 'package:murni_bus_ticket/screens/booking_screen.dart';
import 'package:murni_bus_ticket/models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Murni Bus Ticket',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xFF213230)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) =>
            HomeScreen(user: User(username: '', password: '')),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/booking') {
          final User user = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) {
              return BookingScreen(user: user);
            },
          );
        }
        assert(false, 'Invalid route: ${settings.name}');
        throw Exception('Invalid route: ${settings.name}');
      },
    );
  }
}
