import 'dart:convert';

import 'package:attemp_tmc/QrScan.dart';
import 'package:attemp_tmc/TmcDetails.dart';
import 'package:attemp_tmc/VerifyCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'StartScreen.dart';
import 'MainScreen.dart';

var success = false;
var ref;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMC ATTEMP 1 ',
      home: MyHomePage(title: 'Мои ТМЦ'),
      routes: {
        '/main': (context) => MyApp(),
        '/startScreen': (context) => StartScreen(),
        '/verifyCode': (context) => VerifyCode(),
        '/mainScreen': (context) => MainScreen(),
        '/tmcDetails': (context) => TmcDetails(),
        '/qrScan': (context) => QrScan(),
      },
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Response> future_res;
  var phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: (future_res == null) ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Авторизация',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              Padding(padding: EdgeInsets.only(left: 80, right: 80, top: 25, bottom: 25),
              child:
              TextField(
                  textAlign: TextAlign.center,
                  cursorColor: Color(0xff4dc7e1),
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Colors.blue, fontSize: 30),
                  decoration: InputDecoration(
                    hintText: '+380',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  onChanged : (value) {
                      phone = value;
                      print(phone);
                  },
                ),
              ),
              ElevatedButton(
                child: Text('Войти', style: TextStyle(fontSize: 20),),
                onPressed: (){
                  setState(() {
                    future_res = sendVerifyCodeResponse(phone, context);
                  });
                },
              ),
            ],
        )
        :
         FutureBuilder<Response>(
          future: future_res,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.error}"); //Модалку сюда
            }
              return CircularProgressIndicator();
            },
        ),
      ),
    );// This trailing comma makes auto-formatting nicer for build methods.
  }
}

//todo падает из--за того что нет обработки ошибки/ Добавить обработку ошибок/
Future<Response> sendVerifyCodeResponse(user_phone, context) async {
  const url = 'http://3.125.138.157:1882/appMyTmc/handler/sendVerifyCode';
  final String api_key = '5361061fd3d485112da8a494b13fe39';
  Response res;
  Validator validPhone = _validatePhoneNumber(user_phone);
  print(validPhone.phone);
  if(validPhone.success == true) {
    var body = {
      "api_key": api_key,
      "user_phone":  validPhone.phone
    };

    final response = await http.post(url, body: body, headers: {},);
    if(response.statusCode == 200){
      res = Response.fromJson(json.decode(response.body));
      success = res.success;
      ref = res.ref;
      Navigator.popAndPushNamed(context, '/verifyCode', arguments: ref);
    }else{
      res = Response(success: false, ref: '');
    }
  }



  return res;
}

class Response {
  final bool success;
  final String ref;

  Response({this.success, this.ref});

  factory Response.fromJson(Map<String, dynamic> json){
    return Response(
        success : json['success'] as bool,
        ref : json['ref'] as String
    );
  }
}

class Validator{
  bool success;
  String phone;

  Validator({this.success, this.phone});
}

Validator _validatePhoneNumber(phone){
  Validator res;
  RegExp regExp =  RegExp(r"(^\+?\d{12,}$)"); // формат тел. 380501234567
  RegExp regReplace = RegExp(r"(/\D/g)");
  phone = phone.trim().replaceAll(regReplace,"");
  if(phone.length == 10 && phone.substring(0,1) == "0"){
    phone = "+38" + phone;
  }else if(phone.length == 11 && phone.substring(0,1) == "8"){
    phone = "+3" + phone;
  }

  var result = regExp.hasMatch(phone) ? true : false;
  res = Validator(success: result, phone: phone);

  return res;
}