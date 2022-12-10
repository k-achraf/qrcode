
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path/path.dart';

import 'Settings.dart';

class GenerateCode extends StatefulWidget {
  @override
  _GenerateCodeState createState() => _GenerateCodeState();
}

class _GenerateCodeState extends State<GenerateCode> {

  TextEditingController _textController = new TextEditingController();
  GlobalKey _globalKey = new GlobalKey();
  String _textString = "Example Text";

  AdmobInterstitial interstitialAd = AdmobInterstitial(
    adUnitId: Settings.AdmobInterstitialId,
  );

  @override
  Widget build(BuildContext context) {
    interstitialAd.load();
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.03,
              left: 10.0,
              right: 10.0
            ),
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: AdmobBanner(
                  adUnitId: Settings.AdmobBannerId,
                  adSize: AdmobBannerSize.BANNER,
                ),
              ),
              Text(
                "Enter Text To Generate Qr Code",
                style: TextStyle(
                  color: Settings.colors["primaryColor"],
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.0,),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (v){
                        setState(() {
                          _textString = v;
                        });
                      },
                      controller: _textController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Settings.colors['textColor']
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Settings.colors['primaryColor']
                          )
                        ),
                        hintText: "Enter Text"
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.0,),
              Column(
                children: [
                  Center(
                    child: RepaintBoundary(
                      key: _globalKey,
                      child: QrImage(
                        data: _textString,
                        size: MediaQuery.of(context).size.height * 0.3,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  RaisedButton(
                    padding: EdgeInsets.all(10.0),
                    color: Settings.colors['primaryColor'],
                    onPressed: () async{
                      interstitialAd.load();
                      if(await interstitialAd.isLoaded){
                        interstitialAd.show();
                      }
                      try{
                        if(await Permission.storage.request().isGranted){
                          RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
                          var image = await boundary.toImage();
                          ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
                          Uint8List pngBytes = byteData.buffer.asUint8List();

                          Directory baseDir = await getApplicationDocumentsDirectory();
                          String dirToBeCreated = "/storage/emulated/0/qr code generated";
                          String finalDir = join(baseDir.toString() , dirToBeCreated);

                          var dir = Directory(finalDir);

                          bool dirExists = await dir.exists();
                          if(!dirExists){
                            dir.create();
                          }

                          final tempDir = await getTemporaryDirectory();
                          final file = await File("${dir.path}/${_textString}.png").create();
                          await file.writeAsBytes(pngBytes);

                          Fluttertoast.showToast(
                            msg: "The image was saved to ${finalDir}",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Settings.colors['primaryColor'],
                            textColor: Colors.white,
                            fontSize: 16.0
                          );
                        }
                      }
                      catch(e){
                        print(e.toString());
                      }
                    },
                    child: Text(
                      "Save Image",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
