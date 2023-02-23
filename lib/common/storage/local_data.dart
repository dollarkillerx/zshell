import 'dart:convert';
import 'dart:io';
import 'package:zshell/common/entity/zshell.dart';

class LocalData {
  static Future<String> getFile() async {
    File file = new File(".zshell_conf");
    if (file.existsSync()) {
      return file.readAsString();
    }

    return "";
  }

  static setFile(String data) {
    File file = new File(".zshell_conf");
    file.writeAsStringSync(data, flush: true);
  }

  static Future<String?> getToken() async {
    var zshJSON = await LocalData.getFile();
    if (zshJSON == null) return zshJSON;

    ZShellEntity zShellEntity = ZShellEntity.fromJson(json.decode(zshJSON));
    return zShellEntity.token;
  }

  static setToken(String token) async {
    ZShellEntity zShellEntity;
    var zshJSON = await LocalData.getFile();
    if (zshJSON != null) {
      zShellEntity = ZShellEntity.fromJson(json.decode(zshJSON));
    } else {
      zShellEntity = ZShellEntity();
    }

    zShellEntity.token = token;
    LocalData.setFile(json.encode(zShellEntity));
  }

  static Future<ZShellEntity> getZShellEntity() async {
    ZShellEntity zShellEntity;
    var zshJSON = await LocalData.getFile();

    if (zshJSON != "") {
      zShellEntity = ZShellEntity.fromJson(json.decode(zshJSON));
    } else {
      zShellEntity = ZShellEntity(
        groups: [],
        hosts: [],
        keys: [],
      );
    }

    if (zShellEntity.groups?.length == 0) {
      zShellEntity.groups = [
        Groups(label: "default", groupId: "0", description: "default group"),
      ];
      zShellEntity.keys = [
        Keys(label: "not use", keyId: "0", description: "not use"),
      ];
    }

    return zShellEntity;
  }

  static setZShellEntity(ZShellEntity zShellEntity) async {
    LocalData.setFile(json.encode(zShellEntity));
  }
}
