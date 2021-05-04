import 'package:flutter_app/main.dart';
import 'package:flutter_app/model/Dog.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteHelper{

 static Future<Database> dataBase;
 SQLiteHelper();

 Future<void> insertDog(Dog dog) async {
   final Database db = await getDatabase();

   await db.insert(
     'dogs',
     dog.toMap(),
     conflictAlgorithm: ConflictAlgorithm.replace,
   );
 }

 Future<List<Dog>> dogs() async {
   final Database db = await getDatabase();
   final List<Map<String, dynamic>> maps = await db.query('dogs');

   return List.generate(maps.length, (i) {
     return Dog(
       id: maps[i]['id'],
       name: maps[i]['name'],
       age: maps[i]['age'],
     );
   });
 }

 Future<void> updateDog(Dog dog) async {

   final db = await getDatabase();
   await db.update(
     'dogs',
     dog.toMap(),
     where: "id = ?",
     whereArgs: [dog.id],
   );
 }

 Future<void> deleteDog(int id) async {

   final db = await getDatabase();
   await db.delete(
     'dogs',
     where: "id = ?",
     whereArgs: [id],
   );
 }
}


