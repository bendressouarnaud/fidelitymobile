import 'dart:async';
import '../database/database.dart';
import '../models/calendrierpaiement.dart';

class CalendrierPaiementDao {
  final dbProvider = DatabaseHelper.instance;

  //Adds new Todo records

  Future<int> insert(CalendrierPaiement data) async {
    final db = await dbProvider.database;
    var result = db.insert("calendrierpaiement", data.toDatabaseJson());
    return result;
  }

  Future<int> update(CalendrierPaiement data) async {
    final db = await dbProvider.database;
    var result = await db.update("calendrierpaiement", data.toDatabaseJson(),
        where: "id = ?", whereArgs: [data.id]);
    return result;
  }

  Future<CalendrierPaiement> findById(int id) async {
    final db = await dbProvider.database;
    var data = await db.query('calendrierpaiement', where: 'id = ?', whereArgs: [id]);
    List<CalendrierPaiement> liste = data.isNotEmpty
        ? data.map((c) => CalendrierPaiement.fromDatabaseJson(c)).toList()
        : [];
    return liste.first;
  }

  Future<List<CalendrierPaiement>> findByProduitId(int produitId) async {
    final db = await dbProvider.database;
    var data = await db.query('calendrierpaiement', where: 'produitId = ?', whereArgs: [produitId]);
    return data.isNotEmpty ? data.map((c) => CalendrierPaiement.fromDatabaseJson(c)).toList() : [];
  }
}