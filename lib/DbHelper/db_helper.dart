import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  //singleton object
  DBHelper._();

  //static instance
  static final DBHelper getInstance = DBHelper._();

  Database? db;

  Future<Database> getDB() async {
    if (db != null) {
      return db!;
    } else {
      db = await openDB();
      return db!;
    }
  }

  Future<Database> openDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "contactDB.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
      create table users(
      id integer primary key autoincrement,
      name text not null,
      email text not null,
      number text not null,
      password text not null
      );
      ''');

        await db.execute('''
      create table contacts(
      id integer primary key autoincrement,
      name text not null,
      number text not null,
      user_id integer,
      foreign key(user_id) references users(id)
      );
      ''');
      },
    );
  }

  //insert user
  Future<int> insertUser(Map<String, dynamic> data) async {
    var db = await getDB();
    return db.insert("users", data);
  }

}
