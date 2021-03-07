import 'package:attemp_tmc/MainScreen.dart';
import 'package:flutter/material.dart';
import 'User.dart';

class StartScreen extends StatefulWidget {

  //StartScreen({Key key, this.title}) : super(key: key);
  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
  }

  class _MyHomePageState extends State<StartScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои ТМЦ'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: (){
            //User user = User('Ivan', 34);
            //Route route = MaterialPageRoute(builder: (context) => MainScreen());
            Navigator.pushNamed(context, '/MainScreen', arguments: null);
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}