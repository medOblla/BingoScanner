import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = '0.0';
  double totalPurchase = 0.0;
  @override
  void initState() {
    super.initState();
  }

  Future<String> getData(String barCode) async {
    http.Response response = await http.get(
        Uri.encodeFull("http://192.168.1.6:8000/api/sale/$barCode"),
        headers: {"Accept": "application/json"});
    String data = response.body;
    return data;
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted || barcodeScanRes == "Failed to get platform version.") return;
    totalPurchase += double.parse(await getData(barcodeScanRes));
    setState(() {
      _scanBarcode = totalPurchase.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Color(0XFF191919),
      body: Container(
        width: double.infinity,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Image.network(
                  "https://cdn.discordapp.com/attachments/671407027871940609/675722336691027978/logo.png"),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: Text(
                      "\$ " + _scanBarcode,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ButtonTheme(
                    minWidth: 180.0,
                    height: 50.0,
                    child: RaisedButton(
                        onPressed: () => scanBarcodeNormal(),
                        color: Colors.amber,
                        child: Text(
                          "Scan Barcode",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
