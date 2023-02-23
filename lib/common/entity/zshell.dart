class ZShellEntity {
  String? token;
  List<Groups>? groups;
  List<Hosts>? hosts;
  List<Keys>? keys;

  ZShellEntity({this.token, this.groups, this.hosts, this.keys});

  ZShellEntity.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['groups'] != null) {
      groups = <Groups>[];
      json['groups'].forEach((v) {
        groups!.add(new Groups.fromJson(v));
      });
    }
    if (json['hosts'] != null) {
      hosts = <Hosts>[];
      json['hosts'].forEach((v) {
        hosts!.add(new Hosts.fromJson(v));
      });
    }
    if (json['keys'] != null) {
      keys = <Keys>[];
      json['keys'].forEach((v) {
        keys!.add(new Keys.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.groups != null) {
      data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    }
    if (this.hosts != null) {
      data['hosts'] = this.hosts!.map((v) => v.toJson()).toList();
    }
    if (this.keys != null) {
      data['keys'] = this.keys!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Groups {
  String? label;
  String? groupId;
  String? description;

  Groups({this.label, this.groupId, this.description});

  Groups.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    groupId = json['groupId'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['groupId'] = this.groupId;
    data['description'] = this.description;
    return data;
  }
}

class Hosts {
  String? label;
  String? groupId;
  String? address;
  int? port;
  String? username;
  String? password;
  String? keyId;
  String? description;

  Hosts(
      {this.label,
        this.groupId,
        this.address,
        this.port,
        this.username,
        this.password,
        this.keyId,
        this.description});

  Hosts.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    groupId = json['groupId'];
    address = json['address'];
    port = json['port'];
    username = json['username'];
    password = json['password'];
    keyId = json['keyId'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['groupId'] = this.groupId;
    data['address'] = this.address;
    data['port'] = this.port;
    data['username'] = this.username;
    data['password'] = this.password;
    data['keyId'] = this.keyId;
    data['description'] = this.description;
    return data;
  }
}

class Keys {
  String? label;
  String? keyId;
  String? data;
  String? description;

  Keys({this.label, this.keyId, this.data, this.description});

  Keys.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    keyId = json['keyId'];
    data = json['data'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['keyId'] = this.keyId;
    data['data'] = this.data;
    data['description'] = this.description;
    return data;
  }
}


/**
    {
    "token": "",
    "groups": [
    {
    "label": "",
    "groupId": "",
    "description": ""
    }
    ],
    "hosts": [
    {
    "label": "",
    "groupId": "",
    "address": "",
    "port": 80,
    "username": "",
    "password": "",
    "keyId": "",
    "description": ""
    }
    ],
    "keys": [
    {
    "label": "",
    "keyId": "",
    "data": "",
    "description": ""
    }
    ]
    }
 */