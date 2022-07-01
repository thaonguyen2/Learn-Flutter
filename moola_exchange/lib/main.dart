import 'package:flutter/material.dart';
import 'package:moola_exchange/services/service_locator.dart';
import 'package:moola_exchange/ui/views/calculate_screen.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moola X',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const CalculateCurrencyScreen(),
    );
  }
}
