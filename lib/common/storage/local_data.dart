// import 'dart:convert';
// import 'localstorage.dart';
// import 'package:zshell/common/entity/zshell.dart';
//
// class LocalData {
//   static Future<String?> getToken() async {
//     var zshJSON = await LocalStorage.getString("ZSH");
//     if (zshJSON == null) return zshJSON;
//
//     ZShellEntity zShellEntity = ZShellEntity.fromJson(json.decode(zshJSON));
//     return zShellEntity.token;
//   }
//
//   static setToken(String token) async {
//     ZShellEntity zShellEntity;
//     var zshJSON = await LocalStorage.getString("ZSH");
//     if (zshJSON != null) {
//       zShellEntity = ZShellEntity.fromJson(json.decode(zshJSON));
//     } else {
//       zShellEntity = ZShellEntity();
//     }
//
//     zShellEntity.token = token;
//     LocalStorage.setString("ZSH", json.encode(zShellEntity));
//   }
//
//   static Future<ZShellEntity> getZShellEntity() async {
//     print("aaaaaaaasdsdsdsdsa");
//     ZShellEntity zShellEntity;
//     var zshJSON = await LocalStorage.getString("ZSH");
//
//     print(zshJSON != null);
//     if (zshJSON != null) {
//       print(zshJSON);
//       zShellEntity = ZShellEntity.fromJson(json.decode(zshJSON));
//     } else {
//       zShellEntity = ZShellEntity(
//         groups: [],
//         hosts: [],
//         keys: [],
//       );
//     }
//
//
//     print("aaaaaaaaa");
//
//     if (zShellEntity.groups?.length == 0) {
//       zShellEntity.groups = [
//         Groups(label: "default", groupId: "", description: "default group"),
//       ];
//     }
//
//     return zShellEntity;
//   }
//
//   static setZShellEntity(ZShellEntity zShellEntity) async {
//     LocalStorage.setString("ZSH", json.encode(zShellEntity));
//   }
// }
