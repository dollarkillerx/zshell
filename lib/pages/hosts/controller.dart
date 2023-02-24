import 'dart:io';
import 'package:bruno/bruno.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zshell/common/entity/zshell.dart';
import 'package:zshell/common/library/tools.dart';
import 'package:zshell/common/storage/local_data.dart';

class HostsController extends GetxController {
  var sshKeyFile = "".obs;
  var group = Groups();
  var sshKey = Keys();
  var dropdownAction = "0".obs;
  var dropdownSSHKeyAction = "0".obs;
  var host = Hosts();
  RxList<Groups> groups = <Groups>[].obs;
  Map<String, List<Hosts>> hosts = Map();

  var dropdownGroupItems = [
    DropdownMenuItem(
      child: Text(
        "default",
      ),
      value: "0",
    )
  ];

  var dropdownSSHKeyItems = [
    DropdownMenuItem(
      child: Text(
        "not use",
      ),
      value: "0",
    )
  ];

  @override
  void onInit() async {
    super.onInit();

    // update dropdownGroupItems
    await flushGroups();
    await flushSSHKey();
    await flushHosts();
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    PlatformFile file = result.files.single;
    sshKeyFile.value = file.name;

    try {
      File f = new File(file.path!);
      String cf = await f.readAsString();
      sshKey.data = cf;
    } catch (e) {
      print(e);
      Get.dialog(AlertDialog(
        title: Text("Error"),
        content: Text("error $e"),
      ));
    }
  }

  newGroup() async {
    var zshell = await LocalData.getZShellEntity();
    zshell.groups?.add(Groups(
        label: group.label,
        description: group.description,
        groupId: generateRandomString(5)));

    LocalData.setZShellEntity(zshell);
    group = Groups();

    await flushGroups();
  }

  newSSHKey() async {
    var zshell = await LocalData.getZShellEntity();
    zshell.keys?.add(Keys(
        label: sshKey.label,
        description: sshKey.description,
        data: sshKey.data,
        keyId: generateRandomString(5)));

    LocalData.setZShellEntity(zshell);
    sshKey = Keys();

    await flushSSHKey();
    update();
  }

  flushGroups() async {
    dropdownAction.value = dropdownGroupItems[0].value!;
    var zshell = await LocalData.getZShellEntity();
    dropdownGroupItems.clear();

    groups.clear();
    zshell.groups?.forEach((element) {
      dropdownGroupItems.add(DropdownMenuItem(
        child: Text(
          element.label!,
        ),
        value: element.groupId,
      ));

      groups.add(element);
    });
  }

  flushSSHKey() async {
    dropdownSSHKeyAction.value = dropdownSSHKeyItems[0].value!;
    var zshell = await LocalData.getZShellEntity();
    dropdownSSHKeyItems.clear();

    zshell.keys?.forEach((element) {
      dropdownSSHKeyItems.add(DropdownMenuItem(
        child: Text(
          element.label!,
        ),
        value: element.keyId,
      ));
    });
  }

  groupChange(String? value) {
    dropdownAction.value = value!;
    host.groupId = value;
  }

  sshKeyChange(String? value) {
    dropdownSSHKeyAction.value = value!;
    host.keyId = value;
  }

  newSSH() async {
    var zshell = await LocalData.getZShellEntity();
    if (host.groupId == null) {
      host.groupId = dropdownGroupItems[0].value;
    }
    if (host.keyId == null) {
      host.keyId = dropdownSSHKeyItems[0].value;
    }
    zshell.hosts?.add(Hosts(
        label: host.label,
        description: host.description,
        address: host.address,
        port: host.port,
        username: host.username,
        password: host.password,
        groupId: host.groupId,
        hostId: generateRandomString(5),
        keyId: host.keyId));

    LocalData.setZShellEntity(zshell);

    host.groupId = dropdownGroupItems[0].value;
    dropdownAction.value = dropdownGroupItems[0].value!;
    dropdownSSHKeyAction.value = dropdownSSHKeyItems[0].value!;

    await flushHosts();
    update();
  }

  flushHosts() async {
    var zshell = await LocalData.getZShellEntity();
    hosts.clear();
    zshell.hosts?.forEach((element) {
      if (hosts[element.groupId] == null) {
        hosts[element.groupId!] = [];
      }
      hosts[element.groupId]?.add(element);
    });

    // prixnt("object  ${hosts.length} ${zshell.hosts?.length}");
  }

  modifyGroup(BuildContext context, Groups group) {
    Widget dialog = Container(
      child: Column(
        children: [
          TextField(
            autofocus: true,
            controller: TextEditingController(text: group.label),
            onChanged: (r) {
              group.label = r.trim();
            },
            decoration: InputDecoration(
                labelText: "Label", prefixIcon: Icon(Icons.group_add_outlined)),
          ),
          TextField(
            autofocus: true,
            controller: TextEditingController(text: group.description),
            onChanged: (r) {
              group.description = r.trim();
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
                var zshell = await LocalData.getZShellEntity();
                int? index = zshell.groups?.indexWhere((element) {
                  if (element.groupId == group.groupId) {
                    return true;
                  }
                  return false;
                });
                if (index != null) {
                  zshell.groups?[index] = group;
                }

                LocalData.setZShellEntity(zshell);
                flushGroups();

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
                child: Text("Save"),
              ))
        ],
      ),
    );

    Get.defaultDialog(title: "Modify Group", content: dialog);
  }

  deleteGroup(BuildContext context, Groups groups) {
    BrnDialogManager.showConfirmDialog(context,
        // showIcon: true,
        warningWidget: Icon(
          Icons.warning,
          color: Colors.redAccent,
        ),
        warning: "Delete Group ?",
        confirm: "Yes",
        cancel: "No",
        message:
            "Confirm to delete the ${group.label} group, all machines under the group will be deleted。",
        onConfirm: () async {
      var zshell = await LocalData.getZShellEntity();
      zshell.groups?.removeWhere((element) {
        if (element.groupId == groups.groupId) {
          return true;
        }
        return false;
      });

      zshell.hosts?.removeWhere((element) {
        if (element.groupId == groups.groupId) {
          return true;
        }
        return false;
      });

      LocalData.setZShellEntity(zshell);
      await flushGroups();
      await flushHosts();

      BrnToast.show("successfully deleted", context);
      Get.back();
    }, onCancel: () {
      BrnToast.show("cancel operation", context);
      Get.back();
    });
  }

  deleteHost(BuildContext context, Hosts host) {
    BrnDialogManager.showConfirmDialog(context,
        // showIcon: true,
        warningWidget: Icon(
          Icons.warning,
          color: Colors.redAccent,
        ),
        warning: "Delete Host ?",
        confirm: "Yes",
        cancel: "No",
        message: "Confirm to delete the ${host.label} ${host.address}",
        onConfirm: () async {
      var zshell = await LocalData.getZShellEntity();
      zshell.hosts?.removeWhere((element) {
        if (element.hostId == host.hostId) {
          return true;
        }
        return false;
      });

      LocalData.setZShellEntity(zshell);
      await flushHosts();

      BrnToast.show("successfully deleted", context);
      update();
      Get.back();
    }, onCancel: () {
      BrnToast.show("cancel operation", context);
      Get.back();
    });
  }

  editHost(BuildContext context, Hosts host) async {
    await flushGroups();
    await flushSSHKey();

    var groupId = host.groupId.obs;
    var keyId = host.keyId.obs;

    Widget dialog = Container(
      child: Column(
        children: [
          TextField(
            autofocus: true,
            controller: TextEditingController(text: host.label),
            onChanged: (r) {
              host.label = r.trim();
            },
            decoration: InputDecoration(
                labelText: "Label",
                prefixIcon: Icon(Icons.drive_file_rename_outline)),
          ),
          TextField(
            onChanged: (r) {
              host.address = r.trim();
            },
            controller: TextEditingController(text: host.address),
            decoration: InputDecoration(
              labelText: "Host",
            ),
          ),
          TextField(
            onChanged: (r) {
              host.port = int.parse(r);
            },
            controller: TextEditingController(text: host.port.toString()),
            decoration: InputDecoration(
              labelText: "Port",
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, //数字，只能是整数
            ],
          ),
          TextField(
            onChanged: (r) {
              host.username = r.trim();
            },
            controller: TextEditingController(text: host.username),
            decoration: InputDecoration(
              labelText: "Username",
            ),
          ),
          TextField(
            onChanged: (r) {
              host.password = r.trim();
            },
            controller: TextEditingController(text: host.password),
            decoration: InputDecoration(
              labelText: "Password",
            ),
          ),
          TextField(
            onChanged: (r) {
              host.description = r.trim();
            },
            controller: TextEditingController(text: host.description),
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
                        items: dropdownGroupItems,
                        value: groupId.value,
                        onChanged: (String? value) {
                          groupId.value = value;
                          host.groupId = value;
                          print('host.groupId ${host.groupId}');
                        },
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Use SSHKey: "),
                  Obx(() => DropdownButton(
                        items: dropdownSSHKeyItems,
                        value: keyId.value,
                        onChanged: (String? value) {
                          host.keyId = value;
                          keyId.value = value;
                          print('host.keyId ${host.keyId}');
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
              onPressed: () async {
                var zshell = await LocalData.getZShellEntity();
                var idx = zshell.hosts?.indexWhere((element) {
                  if (element.hostId == host.hostId) {
                    return true;
                  }

                  return false;
                });

                if (idx != null) {
                  zshell.hosts?[idx] = host;
                  LocalData.setZShellEntity(zshell);
                  await flushHosts();
                  update();
                }

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
                child: Text("Save"),
              ))
        ],
      ),
    );

    Get.defaultDialog(title: "Modify Host", content: dialog);
  }
}
