import 'dart:convert';

import 'package:attemp_tmc/QrScan.dart';
import 'package:attemp_tmc/TmcDetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class MainScreen extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainScreen>{
  Future<ItemsList> items;
  int userId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final RouteSettings settings = ModalRoute.of(context).settings;
    userId = settings.arguments;
    items = getItemsList(userId);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Мои ТМЦ', style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new QrScan()));
              },
              child: Container(
                child: ClipRRect(
                  child: Image.asset('assets/qr_icon_2.png'),
                ),),
            ),
            InkWell(
              onTap: () {
                Navigator.popAndPushNamed(context, '/main',);
              },
              child: Container(
                child: ClipRRect(
                  child: Image.asset('assets/dor_icon.png'),
                ),),
            ),
          ],
        ),
        body: FutureBuilder<ItemsList>(
            future: items,
            builder: (BuildContext context, AsyncSnapshot<ItemsList> snapshot) {
              if (snapshot.hasData) {
                return _myListViewDynamic(snapshot.data.items);
              }else if(snapshot.hasError){
                return Text('Error');
              }else {
                return Center(child: CircularProgressIndicator());
              }
            }
        )
    );
  }
}


ListView _myListViewDynamic(items){
  return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        var backGround =  index % 2 == 0 ? 0xffe8f2f5 : 0xffffffff;
        return Container(
          color: Color(backGround),
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            title: Text('${items[index].item_name}'),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Container(
                child: Row(
                  children: [
                    Image(image: AssetImage('assets/qr_mini.png'),),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Сер №: ${items[index].name}')),
                  ],
                ),
              ),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){
              //Navigator.push(context, new MaterialPageRoute(builder: (context) => new TmcDetails()));
              Navigator.popAndPushNamed(context, '/tmcDetails', arguments: items[index].item_id);
            },
          ),
        );
      }
  );
}


class ItemsList {
  List<Item> items;
  ItemsList({this.items});

  factory ItemsList.fromJson(Map<String, dynamic> json){
    var itemsJson = json['items'] as List;
    List <Item> itemsList = itemsJson.map((e) => Item.fromJson(e)).toList();

    return ItemsList(
        items: itemsList
    );
  }
}

class Item{
    final String name;
    final String item_name;
    final int item_id;

    Item({this.name, this.item_name, this.item_id});

    factory Item.fromJson(Map<String, dynamic> json){
      return Item(
        name: json['name'] as String,
        item_name: json['item_name'] as String,
        item_id: json['item_id'] as int
      );
    }
}

Future<ItemsList> getItemsList(int userId) async{
  const String url = 'http://3.125.138.157:1882/appMyTmc/handler/getUserTmc';
  String user_id = userId.toString();
  // ignore: always_specify_types
  final Object body = {
    'api_key':'5361061fd3d485112da8a494b13fe39',
    'user_id': user_id
  };
  final http.Response response = await http.post(url, body: body, headers: {});

  if(response.statusCode == 200){
    print(response.body);
    return ItemsList.fromJson(json.decode(response.body));
  }else{
    throw Exception('Error: ${response.reasonPhrase}');
  }

}