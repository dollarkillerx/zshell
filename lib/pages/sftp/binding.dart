import 'package:get/get.dart';
import 'provider.dart';
import 'controller.dart';

class SFTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SFTPController>(() => SFTPController());
    Get.lazyPut<SFTPProvider>(() => SFTPProvider());
  }
}