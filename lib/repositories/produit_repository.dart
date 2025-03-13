import 'package:fidelite/dao/produit_dao.dart';
import '../models/produit.dart';

class ProduitRepository {
  final dao = ProduitDao();
  Future<int> insert(Produit produit) => dao.insert(produit);
  Future<int> update(Produit produit) => dao.update(produit);
  Future<Produit> findById(int id) => dao.findById(id);
  Future<Produit> findByNumpolice(String numPolice) => dao.findByNumpolice(numPolice);
  Future<List<Produit>> findAll() => dao.findAll();
}