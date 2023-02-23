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
  var dropdownAction = "1";

  var dropdownGroupItems = [
    DropdownMenuItem(
      child: Text(
        "default",
      ),
      value: "1",
    )
  ];

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

  void newGroup() async {
    // var zshell = await LocalData.getZShellEntity();
    // zshell.groups?.add(Groups(
    //     label: group.label,
    //     description: group.description,
    //     groupId: generateRandomString(5)));
    //
    // LocalData.setZShellEntity(zshell);
    // group.label = '';
    // group.description = '';
    // group.groupId = '';
  }

  void newSSHKey() async {
    // var zshell = await LocalData.getZShellEntity();
    // zshell.keys?.add(Keys(
    //     label: sshKey.label,
    //     description: sshKey.description,
    //     data: sshKey.data,
    //     keyId: generateRandomString(5)));
    //
    // LocalData.setZShellEntity(zshell);
    // sshKey.label = '';
    // sshKey.description = '';
    // sshKey.keyId = '';
    // sshKey.data = '';
  }

  getGroups() async {
    // print(":aaaaa");
    // var zshell = await LocalData.getZShellEntity();
    // zshell.groups?.map((e) {
    //   dropdownGroupItems.add(DropdownMenuItem(
    //     child: Text(
    //       e.label!,
    //     ),
    //     value: e.groupId,
    //   ));
    //   print(e);
    // });
    //
    // print(dropdownGroupItems.length);
    // print(dropdownGroupItems);
  }
}
