import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            ],
          ),
        ),
      );
    });
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
            controller.sshKeyFile.value = "";
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
              controller.sshKey.label = r;
            },
            decoration: InputDecoration(
                labelText: "Label",
                prefixIcon: Icon(Icons.drive_file_rename_outline)),
          ),
          TextField(
            onChanged: (r) {
              controller.sshKey.description = r;
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
    return Container(
      child: Column(
        children: [
          TextField(
            autofocus: true,
            onChanged: (r) {
              print(r);
            },
            decoration: InputDecoration(
                labelText: "Label",
                prefixIcon: Icon(Icons.drive_file_rename_outline)),
          ),
          TextField(
            onChanged: (r) {
              print(r);
            },
            decoration: InputDecoration(
              labelText: "Host",
            ),
          ),
          TextField(
            onChanged: (r) {
              print(r);
            },
            decoration: InputDecoration(
              labelText: "Port",
            ),
          ),
          TextField(
            onChanged: (r) {
              print(r);
            },
            decoration: InputDecoration(
              labelText: "Username",
            ),
          ),
          TextField(
            onChanged: (r) {
              print(r);
            },
            decoration: InputDecoration(
              labelText: "Password",
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
                  DropdownButton(
                    items: controller.dropdownGroupItems,
                    value: controller.dropdownAction,
                    onChanged: (String? value) {
                      controller.dropdownAction = value!;
                    },
                    onTap: () {
                      controller.getGroups();
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Use SSHKey: "),
                  DropdownButton(
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "1111",
                          style: TextStyle(
                              color: controller.dropdownAction == "1"
                                  ? Colors.red
                                  : Colors.grey),
                        ),
                        value: "1",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "2222",
                          style: TextStyle(
                              color: controller.dropdownAction == "2"
                                  ? Colors.red
                                  : Colors.grey),
                        ),
                        value: "2",
                      ),
                    ],
                    value: controller.dropdownAction,
                    onChanged: (String? value) {
                      controller.dropdownAction = value!;
                    },
                  ),
                ],
              ),
            ],
          ),
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
              controller.group.label = r;
            },
            decoration: InputDecoration(
                labelText: "Label", prefixIcon: Icon(Icons.group_add_outlined)),
          ),
          TextField(
            autofocus: true,
            onChanged: (r) {
              controller.group.description = r;
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
                controller.newGroup();
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
