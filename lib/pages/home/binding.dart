import 'package:get/get.dart';
import 'package:zshell/pages/hosts/binding.dart';
import 'package:zshell/pages/hosts/controller.dart';
import 'package:zshell/pages/hosts/provider.dart';
import 'package:zshell/pages/sftp/binding.dart';
import 'package:zshell/pages/sftp/controller.dart';
import 'package:zshell/pages/sftp/provider.dart';
import 'provider.dart';
import 'controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<HomeProvider>(() => HomeProvider());

    // hosts page
    Get.lazyPut<HostsController>(() => HostsController());
    Get.lazyPut<HostsProvider>(() => HostsProvider());

    // sftp page
    Get.lazyPut<SFTPController>(() => SFTPController());
    Get.lazyPut<SFTPProvider>(() => SFTPProvider());
  }
}