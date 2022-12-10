
import 'package:admob_flutter/admob_flutter.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcode/Settings.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanCode extends StatefulWidget {
  @override
  _ScanCodeState createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {

  AdmobInterstitial interstitialAd = AdmobInterstitial(
    adUnitId: Settings.AdmobInterstitialId,
  );

  String code = "";
  _scan() async{

    try{
      var result = await BarcodeScanner.scan();
      if(isURL(code)){
        if(await canLaunch(code)){
          await launch(code);
        }
      }

      setState((){
        code = result.rawContent;
      });
    }on PlatformException catch(e){
      if(e.code == BarcodeScanner.cameraAccessDenied){
        setState(() {
          code = 'Camera Permission was denied';
        });
      }
      else{
        setState(() {
          code = 'Unknown Error $e';
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    interstitialAd.load();
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: AdmobBanner(
                adUnitId: Settings.AdmobBannerId,
                adSize: AdmobBannerSize.BANNER,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.08,
                bottom: 100.0,
                left: 10.0,
                right: 10.0
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Please, Click Scan Button And Scan Your Code",
                    style: TextStyle(
                      color: Settings.colors["primaryColor"],
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SelectableText(
                    code,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Settings.colors['textColor'],
                      height: 1.6
                    ),
                    textAlign: TextAlign.center,

                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Settings.colors["primaryColor"],
        onPressed: () async{
          interstitialAd.load();
          if(await interstitialAd.isLoaded){
            interstitialAd.show();
          }
//          interstitialAd.dispose();
          _scan();
        },
        label: Text('Scan'),
        icon: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
