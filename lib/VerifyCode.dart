import 'dart:convert';

import 'package:attemp_tmc/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';

class VerifyCode extends StatefulWidget {

  //StartScreen({Key key, this.title}) : super(key: key);
  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<VerifyCode> {
  var auth_ref;
  var field1, field2, field3, field4;

  @override
  Widget build(BuildContext context) {
    RouteSettings settings = ModalRoute.of(context).settings;
    auth_ref = settings.arguments;
    if(auth_ref == null){
      //Navigator.pushNamed(context, '/startScreen');
      Navigator.popAndPushNamed(context, '/startScreen');
    }
    //print(auth_ref);
    return Scaffold(
      appBar: AppBar(
        title: Text('navbar title'),
      ),
      body: Center(
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(left: 80, right: 80, top: 25, bottom: 25),
                child:
                PinCodeFields(
                  length: 4,
                  fieldBorderStyle: FieldBorderStyle.Square,
                  fieldHeight: 50,
                  fieldWidth: 60,
                  activeBorderColor: Colors.indigo,
                  borderRadius: BorderRadius.circular(8.0),
                  keyboardType: TextInputType.number,
                  autoHideKeyboard: false,
                  borderColor: Colors.lightBlue,
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  //fieldBorderStyle: FieldBorderStyle.TopBottom,
                  onComplete: (output) {
                    // Your logic with pin code
                    verifyCode(output, auth_ref, context);
                    //print(output);
                  },
                ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     SizedBox(
                  //       child:
                  //         TextField(
                  //           inputFormatters: [
                  //             LengthLimitingTextInputFormatter(1),
                  //           ],
                  //           textAlign: TextAlign.center,
                  //           cursorColor: Color(0xff4dc7e1),
                  //           keyboardType: TextInputType.phone,
                  //           style: TextStyle(color: Colors.blue, fontSize: 30,),
                  //           decoration: InputDecoration(
                  //             hintStyle: TextStyle(color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),
                  //           ),
                  //         onChanged : (value) {
                  //             field1 = value;
                  //             //print(value);
                  //         },
                  //       ),
                  //       width: 25,
                  //     ),
                  //     SizedBox(
                  //       child:
                  //       TextField(
                  //         inputFormatters: [
                  //           LengthLimitingTextInputFormatter(1),
                  //         ],
                  //         textAlign: TextAlign.center,
                  //         cursorColor: Color(0xff4dc7e1),
                  //         keyboardType: TextInputType.phone,
                  //         style: TextStyle(color: Colors.blue, fontSize: 30,),
                  //         decoration: InputDecoration(
                  //           hintStyle: TextStyle(color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),
                  //         ),
                  //         onChanged : (value) {
                  //           field2 = value;
                  //         },
                  //       ),
                  //       width: 25,
                  //     ),
                  //     SizedBox(
                  //       child:
                  //       TextField(
                  //         inputFormatters: [
                  //           LengthLimitingTextInputFormatter(1),
                  //         ],
                  //         textAlign: TextAlign.center,
                  //         cursorColor: Color(0xff4dc7e1),
                  //         keyboardType: TextInputType.phone,
                  //         style: TextStyle(color: Colors.blue, fontSize: 30,),
                  //         decoration: InputDecoration(
                  //           hintStyle: TextStyle(color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),
                  //         ),
                  //         onChanged : (value) {
                  //           field3 = value;
                  //         },
                  //       ),
                  //       width: 25,
                  //     ),
                  //     SizedBox(
                  //       child:
                  //       TextField(
                  //         inputFormatters: [
                  //           LengthLimitingTextInputFormatter(1),
                  //         ],
                  //         textAlign: TextAlign.center,
                  //         cursorColor: Color(0xff4dc7e1),
                  //         keyboardType: TextInputType.phone,
                  //         style: TextStyle(color: Colors.blue, fontSize: 30,),
                  //         decoration: InputDecoration(
                  //           hintStyle: TextStyle(color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),
                  //         ),
                  //         onChanged : (value) {
                  //           field4 = value;
                  //           //print(value);
                  //         },
                  //       ),
                  //       width: 25,
                  //     ),
                  //   ],
                  // ),
              ),
            // RaisedButton(
            //     child: Text(
            //       'Click'
            //     ),
            //     onPressed: (){
            //       //var code = _getEnterdCode(int.parse(field1), int.parse(field2), int.parse(field3), int.parse(field4));
            //       var code = field1 + field2 + field3 + field4;
            //       verifyCode(code, auth_ref, context);
            //     },
            //   ),
            ],
          ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<Response> verifyCode(sms_code, auth_ref, context) async {
  const url = 'http://3.125.138.157:1882/appMyTmc/handler/verifCode';
  final String api_key = '5361061fd3d485112da8a494b13fe39';
  final Object body = {
    "api_key": api_key,
    "code": sms_code,
    "ref": auth_ref
  };

  Response res;

  final response = await http.post(url, body: body, headers: {},);
  if(response.statusCode == 200){
    res = Response.fromJson(json.decode(response.body));
    var success = res.success;
    if(success) {
      Navigator.popAndPushNamed(context, '/mainScreen', arguments: res.user_id);
    }else{

    }
  }else{
    res = Response(success: false, user_id: 0);
  }
  return res;
}

class Response {
  final bool success;
  final int user_id;

  Response({this.success, this.user_id});

  factory Response.fromJson(Map<String, dynamic> json){
    return Response(
        success : json['success'] as bool,
        user_id : json['user_id'] as int
    );
  }
}

int _getEnterdCode(field1, field2, field3, field4){
  return field1+field2+field3+field4;
}