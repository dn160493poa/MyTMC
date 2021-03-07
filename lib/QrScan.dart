import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:qrscan/qrscan.dart' as scanner;

class QrScan extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<QrScan> {
  String barcode = '';
  Uint8List bytes = Uint8List(200);

  @override
  initState() {
    super.initState();
    _scan();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Starting scan'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   width: 200,
              //   height: 200,
              //   child: Image.memory(bytes),
              // ),

              //Text('RESULT  $barcode'),
              //RaisedButton(onPressed: _scan, child: Text("Scan")),
              //RaisedButton(onPressed: _scanPhoto, child: Text("Scan Photo")),
            ],
          ),
        ),
      ),
    );
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this.barcode = barcode);
    Navigator.popAndPushNamed(context, '/tmcDetailsByQr', arguments: barcode);
  }

  Future _scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    setState(() => this.barcode = barcode);
  }

}