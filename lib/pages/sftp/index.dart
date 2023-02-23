import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class SFTPPage extends GetView<SFTPController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SFTPController>(builder: (controller) {
      return Scaffold(
        body: Center(
          child: Text("SFTP Page"),
        ),
      );
    });
  }
}
