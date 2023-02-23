import 'package:get/get.dart';
import 'provider.dart';
import 'controller.dart';

class HostsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HostsController>(() => HostsController());
    Get.lazyPut<HostsProvider>(() => HostsProvider());
  }
}