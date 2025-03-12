import '../dao/historique_dao.dart';
import '../models/historique.dart';

class HistoriqueRepository {
  final dao = HistoriqueDao();
  Future<int> insert(Historique data) => dao.insert(data);
  Future<int> update(Historique data) => dao.update(data);
  Future<List<Historique>> findAll() => dao.findAll();
}