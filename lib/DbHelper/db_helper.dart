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
    return await db.insert("users", data);
  }

  // fetch user for login
  Future<Map<String, dynamic>?> fetchUser(String email, String password) async {
    var db = await getDB();
    var result = await db.query(
      "users",
      where: "email=? and password=?",
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  //fetch user by id
  Future<Map<String, dynamic>?> fetchUserById(int id) async {
    var db = await getDB();
    var result = await db.query("users", where: "id=?", whereArgs: [id]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  //update user
  Future<int> updateUser(
    String name,
    String email,
    String number,
    int id,
  ) async {
    var db = await getDB();
    return await db.update(
      "users",
      {"name": name, "email": email, "number": number},
      where: "id=?",
      whereArgs: [id],
    );
  }

  //add contact
  Future<int> addContact(Map<String, dynamic> data) async {
    var db = await getDB();
    return await db.insert("contacts", data);
  }

  //fetch contacts by user id
  Future<List<Map<String, dynamic>>> fetchContacts(int id) async {
    var db = await getDB();
    List<Map<String, dynamic>> contacts = await db.query(
      "contacts",
      where: "user_id=?",
      whereArgs: [id],
      orderBy: "name asc"
    );
    // List<Map<String, dynamic>> contacts = await db.rawQuery(
    //   "select * from contacts where user_id=$id order by name",
    // );
    return contacts;
  }

  //update contact
  Future<int> updateContact(String name, String number, int id) async {
    var db = await getDB();
    return await db.update(
      "contacts",
      {"name": name, "number": number},
      where: "id=?",
      whereArgs: [id],
    );
  }

  //delete contact
  Future<int> deleteContact(int id) async {
    var db = await getDB();
    return await db.delete("contacts", where: "id=?", whereArgs: [id]);
  }
}
