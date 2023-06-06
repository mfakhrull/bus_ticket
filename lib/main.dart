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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Murni Bus Ticket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final User user = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) {
              return HomeScreen(user: user);
            },
          );
        } else if (settings.name == '/booking') {
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
