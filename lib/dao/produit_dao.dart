import 'dart:async';
import '../database/database.dart';
import '../models/produit.dart';

class ProduitDao {
  final dbProvider = DatabaseHelper.instance;

  //Adds new Todo records

  Future<int> insert(Produit data) async {
    final db = await dbProvider.database;
    var result = db.insert("produit", data.toDatabaseJson());
    return result;
  }

  Future<int> update(Produit data) async {
    final db = await dbProvider.database;
    var result = await db.update("produit", data.toDatabaseJson(),
        where: "id = ?", whereArgs: [data.id]);
    return result;
  }

  Future<Produit> findById(int id) async {
    final db = await dbProvider.database;
    var data = await db.query('produit', where: 'id = ?', whereArgs: [id]);
    List<Produit> liste = data.isNotEmpty
        ? data.map((c) => Produit.fromDatabaseJson(c)).toList()
        : [];
    return liste.first;
  }

  Future<Produit> findByNumpolice(String numPolice) async {
    final db = await dbProvider.database;
    var data = await db.query('produit', where: 'numPolice = ?', whereArgs: [numPolice]);
    List<Produit> liste = data.isNotEmpty
        ? data.map((c) => Produit.fromDatabaseJson(c)).toList()
        : [];
    return liste.first;
  }

  Future<List<Produit>> findAll() async {
    final db = await dbProvider.database;
    var results = await db.query('produit');
    List<Produit> liste = results.isNotEmpty
        ? results.map((c) => Produit.fromDatabaseJson(c)).toList()
        : [];
    return liste;
  }

  Future<int> deleteAllProduits() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      "produit",
    );
    return result;
  }
}