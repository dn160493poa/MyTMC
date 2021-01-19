import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendVerifyCode{
  var url = 'http://3.125.138.157:1882/appMyTmc/handler/sendVerifyCode';
  final String api_key = '5361061fd3d485112da8a494b13fe39';
  var user_phone;

  SendVerifyCode({this.user_phone});


  Future<List<Responce>> fetchCode(http.Client client) async {
    var body = {
      "api_key": api_key,
      "user_phone": user_phone
    };

    final response = await http.post(url, body: body, headers: {},);

    // Use the compute function to run parsePhotos in a separate isolate.
    return compute(parsePhotos, response.body);
  }


// A function that converts a response body into a List<Photo>.
  List<Responce> parsePhotos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Responce>((json) => Responce.fromJson(json)).toList();
  }
}

class Responce {
  final bool success;
  final String ref;

  Responce({this.success, this.ref});

  factory Responce.fromJson(Map<String, dynamic> json) {
    return Responce(
      success: json['success'] as bool,
      ref: json['ref'] as String
    );
  }
}


//
// class SendVerifyCode<List<Responce>>  {
// uture: fetchPhotos(http.Client()),
// builder: (context, snapshot) {
// if (snapshot.hasError) print(snapshot.error);
//
// return snapshot.hasData
// ? PhotosList(photos: snapshot.data)
//     : Center(child: CircularProgressIndicator());
// },
// ),
// }
// f

