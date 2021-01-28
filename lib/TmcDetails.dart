import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'User.dart';

class TmcDetails extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TmcDetails> {
  Future<ItemDetails> details;
  int itemId;

  @override
  Widget build(BuildContext context) {
    final RouteSettings settings = ModalRoute.of(context).settings;
    itemId = settings.arguments;
    details = getItemsInfo(itemId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Компбютер, АСУС 4 ядра, 12 ГБ оперативной памяти...'),
      ),
      body: FutureBuilder<ItemDetails>(
        future: details,
        builder: (BuildContext context, AsyncSnapshot<ItemDetails> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return _buildBody(snapshot.data);  // Пример snapshot.data.itemName получаем данные через точечку
          } else if(snapshot.hasError){
            return Text('Error');
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      //
    );
  }
}

Widget _buildBody(details){
  return SingleChildScrollView(
    child: Column(
      children: [
        _headerImage(),
        Divider(),
        _itemDetails(details),
        _sendTmc(),
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

TextButton _sendTmc(){
  return TextButton(
    child: Text('Передать',
      style: TextStyle(
          fontSize: 20,
          color: Colors.white),
    ),
    onPressed: () {},
    style: TextButton.styleFrom(
      backgroundColor: Color(0xff4dc7e1),
      //shape: const BeveledRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(5))),
    ),
  );
}

class ItemDetails{
  final String itemName;
  final String serialNumber;
  final String sender;
  final String price;
  final int ownerId;

  // ignore: sort_constructors_first
  ItemDetails({this.itemName, this.serialNumber, this.sender, this.price, this.ownerId});

  factory ItemDetails.fromJson(Map<String, dynamic> json){
    return ItemDetails(
        itemName: json['item_name'] as String,
        serialNumber: json['serial_number'] as String,
        sender: json['sender'] as String,
        price: json['price'] as String,
        ownerId: json['owner_id'] as int
    );
  }
}

Future<ItemDetails> getItemsInfo(int itemId) async{
  const String url = 'http://3.125.138.157:1882/appMyTmc/handler/getUserTmcDetails';
  final String id = itemId.toString();
  // ignore: always_specify_types
  final Object body = {
    'api_key':'5361061fd3d485112da8a494b13fe39',
    'inventory_id': id
  };
  // ignore: always_specify_types
  final http.Response response = await http.post(url, body: body, headers: {});

  if(response.statusCode == 200){
    //print(response.body);
    return ItemDetails.fromJson(json.decode(response.body));
  }else{
    throw Exception('Error: ${response.reasonPhrase}');
  }

}