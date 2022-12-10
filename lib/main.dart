import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcode/Scan.dart';

import 'Home.dart';
import 'Splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark
    ));

    return MaterialApp(
      title: "Qr Code",
      routes: <String, WidgetBuilder>{
        "/scan" : (BuildContext context) => ScanCode(),
        "/home" : (BuildContext context) => Home(),
      },
      home: Splash(),
    );
  }
}