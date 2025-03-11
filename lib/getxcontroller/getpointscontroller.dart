
import 'package:fidelite/models/points.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../repositories/points_repository.dart';


class PointsGetController extends GetxController {

  // A t t r i b u t e s  :
  var data = <Points>[].obs;
  final _repository = PointsRepository();


  // M E T H O D S :
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async{
    data.add(await _repository.findById(1));
    update();
  }

  void updateData(Points points) async {
    //
    await _repository.update(points);
    // Update
    data[0] = points;
    // Set timer to
    Future.delayed(const Duration(milliseconds: 700),
            () {
          update();
        }
    );
  }
}