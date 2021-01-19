import 'package:flutter/material.dart';
import 'User.dart';

class TmcDetails extends StatefulWidget {

  //StartScreen({Key key, this.title}) : super(key: key);
  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TmcDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Компбютер, АСУС 4 ядра, 12 ГБ оперативной памяти...'),
      ),
      body: _buildBody(),
    );
  }
}

Widget _buildBody(){
  return SingleChildScrollView(
    child: Column(
      children: [
        _headerImage(),
        Divider(),
        _itemDetails(),
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

Container _itemDetails(){
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
                Text('Компьютер АСУС',
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
                Text('ЕР3234234242231231122',
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
                Text('Брось С.А.',
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
                Text('2000.00 грн',
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