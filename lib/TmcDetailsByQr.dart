import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TmcDetailsByQr extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TmcDetailsByQr> {
  Future<ItemDetails> details;
  String itemQr;
  int userId = 52;

  @override
  Widget build(BuildContext context) {
    final RouteSettings settings = ModalRoute.of(context).settings;
    itemQr = settings.arguments;
    details = getItemsInfoByQr(itemQr);
    return WillPopScope(
      onWillPop: () => null, //() => Navigator.popAndPushNamed(context, '/mainScreen', arguments: 52),  не работает
      child: Scaffold(
        appBar: AppBar(
          title: Text('Компбютер, АСУС 4 ядра, 12 ГБ оперативной памяти...'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.popAndPushNamed(context, '/mainScreen', arguments: 52),
          ),
        ),
        body: FutureBuilder<ItemDetails>(
          future: details,
          builder: (BuildContext context, AsyncSnapshot<ItemDetails> snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              //print(snapshot.data.inventoryId);
              return _buildBody(snapshot.data, snapshot.data.inventoryId, context, snapshot.data.ownerId, userId.toString());  // Пример snapshot.data.itemName получаем данные через точечку
            }else if(snapshot.hasError){
              print(snapshot.error);
              return Text('Error');
            }else{
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

Widget _buildBody(details, inventoryId, context, ownerId, userId){
  return SingleChildScrollView(
    child: Column(
      children: [
        _headerImage(),
        Divider(),
        _itemDetails(details),
        _sendOrAcceptTmc(inventoryId, context, ownerId, userId),
      ],
    ),
  );
}

Image _headerImage(){
  return Image(
    image: NetworkImage('https://img.moyo.ua/img/categories/3314/3314_1473862784_39.jpg'),
    fit: BoxFit.cover,
  );
}

Container _itemDetails(details){
  return Container(
    padding: EdgeInsets.only(left: 20),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Наименование',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54),
                  textAlign: TextAlign.left,
                ),
                Text('${details.itemName}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                  softWrap : true,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Идентификатор',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54),
                  textAlign: TextAlign.left,
                ),
                Text('434112',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                  softWrap : true,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Серийный номер',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54),
                  textAlign: TextAlign.left,
                ),
                Text('${details.serialNumber}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                  softWrap : true,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Получен от сотрудника',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54),
                  textAlign: TextAlign.left,
                ),
                Text('${details.sender}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                  softWrap : true,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Стоимость',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54),
                  textAlign: TextAlign.left,
                ),
                Text('${details.price}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                  softWrap : true,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Center _sendOrAcceptTmc(inventoryId, context, ownerId, userId){
  return Center(
    child: (ownerId == userId) ?
      TextButton(
        child: Text('Передать',
          style: TextStyle(
              fontSize: 20,
              color: Colors.white),
        ),
        onPressed: () {
          //Future<PermissionTransfer> future = transferTmc(inventoryId, context);
          transferTmc(inventoryId, context);
        },
        style: TextButton.styleFrom(
          backgroundColor: Color(0xff4dc7e1),
          //shape: const BeveledRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5))),
        ),
      )
        :
      TextButton(
        child: Text('Принять',
          style: TextStyle(
              fontSize: 20,
              color: Colors.white),
        ),
        onPressed: () {
          //Future<PermissionTransfer> future = transferTmc(inventoryId, context);
          acceptTmc(inventoryId, userId, context);
        },
        style: TextButton.styleFrom(
          backgroundColor: Color(0xff4dc7e1),
          //shape: const BeveledRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5))),
        ),
      )
    );



}

class ItemDetails{
  final String inventoryId;
  final String itemName;
  final String serialNumber;
  final String sender;
  final String price;
  final int ownerId;

  // ignore: sort_constructors_first
  ItemDetails({this.itemName, this.serialNumber, this.sender, this.price, this.ownerId, this.inventoryId});

  factory ItemDetails.fromJson(Map<String, dynamic> json){
    return ItemDetails(
        inventoryId: json['inventoryId'] as String,
        itemName: json['itemName'] as String,
        serialNumber: json['serialNumber'] as String,
        sender: json['sender'] as String,
        price: json['price'] as String,
        ownerId: json['ownerId'] as int
    );
  }
}

Future<ItemDetails> getItemsInfoByQr(String itemQr) async{
  const String url = 'http://3.125.138.157:1882/appMyTmc/handler/getUserTmcDetailsbyQr';
  // ignore: always_specify_types
  final Object body = {
    'api_key':'5361061fd3d485112da8a494b13fe39',
    'inventory_qr': itemQr
  };
  // ignore: always_specify_types
  final http.Response response = await http.post(url, body: body, headers: {});

  if(response.statusCode == 200){
    print(response.body);
    return ItemDetails.fromJson(json.decode(response.body));
  }else{
    throw Exception('Error: ${response.reasonPhrase}');
  }

}


Future<PermissionTransfer> transferTmc(String inventoryId, context) async{
  const String url = 'http://3.125.138.157:1882/appMyTmc/handler/transferTmcPermission';
  // ignore: always_specify_types
  final Object body = {
    'api_key':'5361061fd3d485112da8a494b13fe39',
    'inventory_id': inventoryId
  };
  print(inventoryId);
  // ignore: always_specify_types
  final http.Response response = await http.post(url, body: body, headers: {});

  if(response.statusCode == 200){
    //print(response.body);
    //return PermissionTransfer.fromJson(json.decode(response.body));
    //PermissionTransfer data = PermissionTransfer.fromJson(json.decode(response.body));
    //print(data);

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
              'Готово! Теперь сотруднику принимающему ТМЦ необходимо отсканировать QR-код.'
          ),
          actions: [
            FlatButton(
              child: Text('Ок'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        )
    );
  }else{
    throw Exception('Error: ${response.reasonPhrase}');
  }
}

// ignore: camel_case_types
class PermissionTransfer{
  final bool result;

  // ignore: sort_constructors_first
  PermissionTransfer({this.result});

  factory PermissionTransfer.fromJson(Map<String, dynamic> json){
    return PermissionTransfer(
        result: json['success'] as bool
    );
  }
}

Future<PermissionTransfer> acceptTmc(String inventoryId, String userId, context) async{
  const String url = 'http://3.125.138.157:1882/appMyTmc/handler/accepTmc';
  // ignore: always_specify_types
  final Object body = {
    'api_key':'5361061fd3d485112da8a494b13fe39',
    'inventory_id': inventoryId,
    'new_owner_id': userId
  };
  //print(inventoryId);
  // ignore: always_specify_types
  final http.Response response = await http.post(url, body: body, headers: {});

  if(response.statusCode == 200){
    //print(response.body);
    //return PermissionTransfer.fromJson(json.decode(response.body));
    //PermissionTransfer data = PermissionTransfer.fromJson(json.decode(response.body));
    //print(data);

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
              'Готово! Теперь сотруднику принимающему ТМЦ необходимо отсканировать QR-код.'
          ),
          actions: [
            FlatButton(
              child: Text('Ок'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        )
    );
  }else{
    throw Exception('Error: ${response.reasonPhrase}');
  }

}