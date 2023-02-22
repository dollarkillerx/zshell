import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        body: Container(
          child: Row(
            children: [
              Expanded(
                  child: Container(
                color: Colors.black45,
              )),
              Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      );
    });
  }
}
