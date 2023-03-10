import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zshell/constants/colors.dart';
import 'package:zshell/pages/hosts/index.dart';
import 'package:zshell/pages/sftp/index.dart';
import '../../widget/ibutton.dart';
import 'controller.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        body: Container(
          color: ZShellColors.kBackground,
          child: Row(
            children: [
              Expanded(child: buildLeftMenu()),
              Expanded(
                  flex: 3,
                  child: Container(
                    color: ZShellColors.kBackground,
                    child: IndexedStack(
                      index: controller.tabIndex.value,
                      children: [
                        HostsPage(),
                        SFTPPage(),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
    });
  }

  Container buildLeftMenu() {
    return Container(
      color: Color(0xff404044),
      padding: EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              IButton(Icons.display_settings_outlined, "Hosts",
                  controller.menuSelectIndex == 0 ? true : false, () {
                controller.menuSelectIndexSet(0);
              }),
              SizedBox(
                height: 15,
              ),
              IButton(Icons.file_copy, "SFTP",
                  controller.menuSelectIndex == 1 ? true : false, () {
                controller.menuSelectIndexSet(1);
              }),
              SizedBox(
                height: 15,
              ),
              IButton(Icons.key_outlined, "SSH Key",
                  controller.menuSelectIndex == 2 ? true : false, () {
                controller.menuSelectIndexSet(1);
              }),
              SizedBox(
                height: 15,
              ),
              IButton(Icons.import_export_outlined, "Port Forwarding",
                  controller.menuSelectIndex == 2 ? true : false, () {
                controller.menuSelectIndexSet(1);
              }),
            ],
          ),
          IButton(Icons.account_balance_outlined, "About", false, () {
            Get.defaultDialog(
                title: "About",
                content: Text("https://github.com/dollarkillerx/zshell"));
          })
        ],
      ),
    );
  }
}
