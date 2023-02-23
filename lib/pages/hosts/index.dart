import 'dart:io';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zshell/common/entity/zshell.dart';
import 'controller.dart';

class HostsPage extends GetView<HostsController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HostsController>(builder: (controller) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildSelect(context),
              Obx(() => Column(
                    children: controller.groups.map((e) {
                      return buildCard(e);
                    }).toList(),
                  ))
            ],
          ),
        ),
      );
    });
  }

  Container buildCard(Groups groups) {
    // if (groups.groupId == "0") {
    //   return Container();
    // }

    List<Hosts> hosts = [];

    controller.hosts.forEach((key, value) {
      if (key == groups.groupId) {
        value.forEach((element) {
          hosts.add(element);
        });
      }
    });

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Group: ${groups.label}"),
              Text("${groups.description ?? ""}"),
              Row(
                children: [
                  Container(
                    height: 25,
                    child: CircleAvatar(
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 25,
                    child: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          Divider(),
          ...hosts.map((e) {
            return Container(
              height: 100,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/tux.png",
                            fit: BoxFit.fill,
                            height: 80,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Label: ${e.label}"),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Address: ${e.address}"),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Description: ${e.description ?? ""}",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                        ],
                      ),
                      CircleAvatar(
                        child: Icon(Icons.cable),
                      ),
                      CircleAvatar(
                        child: Icon(Icons.edit),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child: Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          })
        ],
      ),
    );
  }

  BrnTextButtonPanel buildSelect(context) {
    return BrnTextButtonPanel(
      nameList: ['Import SSH Key', 'New Group', 'New Host'],
      popDirection: BrnPopupDirection.bottom,
      onTap: (index) {
        // BrnToast.show('第$index个操作', context);
        switch (index) {
          case 1:
            Get.defaultDialog(title: "New Group", content: buildNewGroup());
            break;
          case 2:
            Get.defaultDialog(title: "New Host", content: buildNewHost());
            break;
          case 0:
            Get.defaultDialog(title: "Import SSH Key", content: buildNewSSH());
            controller.sshKeyFile.value = "";
            break;
        }
      },
    );
  }

  Container buildNewSSH() {
    return Container(
      child: Column(
        children: [
          TextField(
            autofocus: true,
            onChanged: (r) {
              controller.sshKey.label = r.trim();
            },
            decoration: InputDecoration(
                labelText: "Label",
                prefixIcon: Icon(Icons.drive_file_rename_outline)),
          ),
          TextField(
            onChanged: (r) {
              controller.sshKey.description = r.trim();
            },
            decoration: InputDecoration(
              labelText: "Description",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                controller.pickFile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text("Set a Key"),
              )),
          SizedBox(
            height: 5,
          ),
          Obx(() {
            return controller.sshKeyFile.value == ""
                ? SizedBox()
                : Text("SSH Key: ${controller.sshKeyFile.value}");
          }),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                controller.newSSHKey();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text("Add"),
              ))
        ],
      ),
    );
  }

  Container buildNewHost() {
    controller.flushGroups();
    sleep(Duration(microseconds: 80));
    return Container(
      child: Column(
        children: [
          TextField(
            autofocus: true,
            onChanged: (r) {
              controller.host.label = r.trim();
            },
            decoration: InputDecoration(
                labelText: "Label",
                prefixIcon: Icon(Icons.drive_file_rename_outline)),
          ),
          TextField(
            onChanged: (r) {
              controller.host.address = r.trim();
            },
            decoration: InputDecoration(
              labelText: "Host",
            ),
          ),
          TextField(
            onChanged: (r) {
              controller.host.port = int.parse(r);
            },
            decoration: InputDecoration(
              labelText: "Port",
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, //数字，只能是整数
              // LengthLimitingTextInputFormatter(15), //限制长度
              // FilteringTextInputFormatter.allow(RegExp("[0-9.]")),//数字包括小数
              // FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),//只允许输入字母
            ],
          ),
          TextField(
            onChanged: (r) {
              controller.host.username = r.trim();
            },
            decoration: InputDecoration(
              labelText: "Username",
            ),
          ),
          TextField(
            onChanged: (r) {
              controller.host.password = r.trim();
            },
            decoration: InputDecoration(
              labelText: "Password",
            ),
          ),
          TextField(
            onChanged: (r) {
              controller.host.description = r.trim();
            },
            decoration: InputDecoration(
              labelText: "Description",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("Group: "),
                  Obx(() => DropdownButton(
                        items: controller.dropdownGroupItems,
                        value: controller.dropdownAction.value,
                        onChanged: (String? value) {
                          controller.groupChange(value);
                        },
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Use SSHKey: "),
                  Obx(() => DropdownButton(
                        items: controller.dropdownSSHKeyItems,
                        value: controller.dropdownSSHKeyAction.value,
                        onChanged: (String? value) {
                          controller.sshKeyChange(value);
                        },
                      )),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () {
                controller.newSSH();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text("Add"),
              ))
        ],
      ),
    );
  }

  Container buildNewGroup() {
    return Container(
      child: Column(
        children: [
          TextField(
            autofocus: true,
            onChanged: (r) {
              controller.group.label = r.trim();
            },
            decoration: InputDecoration(
                labelText: "Label", prefixIcon: Icon(Icons.group_add_outlined)),
          ),
          TextField(
            autofocus: true,
            onChanged: (r) {
              controller.group.description = r.trim();
            },
            decoration: InputDecoration(
              labelText: "Description",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                await controller.newGroup();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text("Add"),
              ))
        ],
      ),
    );
  }
}
