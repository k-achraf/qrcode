
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/GenerateCode.dart';
import 'package:qrcode/Scan.dart';
import 'package:qrcode/Settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void initState(){
    super.initState();
    Admob.initialize(Settings.AdmobAppId);
  }

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      children: [
        ScanCode(),
        GenerateCode()
      ],
    );
  }
}
