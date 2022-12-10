
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Settings.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  void initState(){
    super.initState();
    Future.delayed(
      Duration(seconds: 4),
      (){
        Navigator.of(context).pushReplacementNamed("/home");
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Center(
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
              bottom: MediaQuery.of(context).size.height * 0.1
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/qrcode.png",
                  width: 300.0,
                  height: 300.0,
                ),
                SizedBox(height: 10.0,),
                SpinKitCubeGrid(
                  color: Settings.colors["primaryColor"],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
