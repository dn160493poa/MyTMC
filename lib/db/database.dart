import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../User.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  String userDataTable = 'UsersData';
  String columnId = 'id';
  String columnUserId = 'user_id';
  String columnUserAuthRef = 'auth_ref';

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'UserData.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE $userDataTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$columnUserId INTEGER, $columnUserAuthRef TEXT) ');
  }

  //READ
  Future <List<User>> getUsersData() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> usersDataListMap = await db.query(userDataTable);
    final List<User> usersDataList = [];
    usersDataListMap.forEach((userDataMap){
      usersDataList.add(User.fromMap(userDataMap));
    });
    return usersDataList;
  }

  //INSERT
  Future<User> insertUserData(User userData) async{
    Database db = await this.database;
    userData.id = await db.insert(userDataTable, userData.toMap());
    return userData;
  }

  //UPDATE
  Future<int> updateUserData(User userData) async {
    Database db = await this.database;
    return await db.update(
        userDataTable,
        userData.toMap(),
        where: '$columnId = ?',
        whereArgs: [userData.id]
    );
  }

    //DELETE
    Future<int> deleteUserData(int id) async {
      Database db = await this.database;
      return await db.delete(
          userDataTable,
          where: '$columnId =?',
          whereArgs: [id],
      );
    }

}