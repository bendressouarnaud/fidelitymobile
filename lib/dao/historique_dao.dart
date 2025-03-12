import 'dart:async';
import '../database/database.dart';
import '../models/historique.dart';
import '../models/points.dart';

class HistoriqueDao {
  final dbProvider = DatabaseHelper.instance;

  //Adds new Todo records

  Future<int> insert(Historique data) async {
    final db = await dbProvider.database;
    var result = db.insert("historique", data.toDatabaseJson());
    return result;
  }

  Future<int> update(Historique data) async {
    final db = await dbProvider.database;
    var result = await db.update("historique", data.toDatabaseJson(),
        where: "id = ?", whereArgs: [data.id]);
    return result;
  }

  Future<List<Historique>> findAll() async {
    final db = await dbProvider.database;
    var data = await db.query('historique');
    List<Historique> liste = data.isNotEmpty
        ? data.map((c) => Historique.fromDatabaseJson(c)).toList()
        : [];
    return liste;
  }
}