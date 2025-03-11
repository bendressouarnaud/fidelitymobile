import '../dao/points_dao.dart';
import '../models/points.dart';

class PointsRepository {
  final dao = PointsDao();
  Future<int> insert(Points data) => dao.insert(data);
  Future<int> update(Points data) => dao.update(data);
  Future<Points> findById(int id) => dao.findById(id);
}