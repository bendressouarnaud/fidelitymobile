import '../dao/calendrierpaiement_dao.dart';
import '../models/calendrierpaiement.dart';

class CalendrierPaiementRepository {
  final dao = CalendrierPaiementDao();
  Future<int> insert(CalendrierPaiement data) => dao.insert(data);
  Future<int> update(CalendrierPaiement data) => dao.update(data);
  Future<CalendrierPaiement> findById(int id) => dao.findById(id);
  Future<List<CalendrierPaiement>> findByProduitId(int produitId) => dao.findByProduitId(produitId);
}