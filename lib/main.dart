import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pilight/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garage Edificio Ramos',
      theme: ThemeData.dark(),
      home: FlutterEasyLoading(
        child: LoginScreen(title: 'Garage Edificio Ramos'),
      ),
    );
  }
}
