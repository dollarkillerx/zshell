import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  var menuSelectIndex = 0;
  var tabIndex = 0.obs;

  void menuSelectIndexSet(int index) {
    menuSelectIndex = index;
    tabIndex.value = index;
    update();
  }
}
