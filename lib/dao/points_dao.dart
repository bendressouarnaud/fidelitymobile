import 'dart:async';
import '../database/database.dart';
import '../models/points.dart';

class PointsDao {
  final dbProvider = DatabaseHelper.instance;

  //Adds new Todo records

  Future<int> insert(Points data) async {
    final db = await dbProvider.database;
    var result = db.insert("points", data.toDatabaseJson());
    return result;
  }

  Future<int> update(Points data) async {
    final db = await dbProvider.database;
    var result = await db.update("points", data.toDatabaseJson(),
        where: "id = ?", whereArgs: [data.id]);
    return result;
  }

  Future<Points> findById(int id) async {
    final db = await dbProvider.database;
    var data = await db.query('points', where: 'id = ?', whereArgs: [id]);
    List<Points> liste = data.isNotEmpty
        ? data.map((c) => Points.fromDatabaseJson(c)).toList()
        : [];
    return liste.first;
  }
}