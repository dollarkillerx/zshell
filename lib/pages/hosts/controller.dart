import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  List<Groups> groups = [];
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

    await flushSSHKey();
    update();
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

    flushHosts();
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
}
