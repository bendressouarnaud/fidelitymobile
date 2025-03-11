import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "flutterfidelity.db";

  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;


  // Make this a singleton class.
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
      version: _databaseVersion,
      onCreate: _onCreate,
      //onUpgrade: _onUpgrade
    );
  }

  Future _onCreate(Database db, int newVersion) async {
    for (int version = 0; version < newVersion; version++) {
      await _performDbOperationsVersionWise(db, version + 1);
    }
  }

  /*Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (int version = oldVersion; version < newVersion; version++) {
      await _performDbOperationsVersionWise(db, version + 1);
    }
  }*/

  _performDbOperationsVersionWise(Database db, int version) async {
    switch (version) {
      case 1:
        await _createDatabase(db);
        break;
    /*case 2:
        await _addColumnToalertUser(db);
        break;
      case 3:
        await _addStreamChatObject(db);
        break;*/
    }
  }

  Future _createDatabase(Database db) async {
    await db.execute(
        'CREATE TABLE user (id INTEGER PRIMARY KEY,nom TEXT, prenom TEXT, email TEXT,numero TEXT,adresse TEXT,'
            'fcmtoken TEXT,pwd TEXT)');
    await db.execute(
        'CREATE TABLE produit (id INTEGER PRIMARY KEY,libelle TEXT,prime INTEGER)');
    await db.execute(
        'CREATE TABLE points (id INTEGER PRIMARY KEY AUTOINCREMENT,total INTEGER)');
    await db.execute(
        'CREATE TABLE calendrierpaiement (id INTEGER PRIMARY KEY, produitId INTEGER,montant INTEGER,'
            'mois INTEGER,annee INTEGER, paiementEffectue INTEGER)');
  }
}