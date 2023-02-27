import 'dart:convert';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zshell/pages/ssh_client/ssh_client.dart';

import 'common/library/tools.dart';
import 'common/routers/app_pages.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  if (args.length >= 1 && args.elementAt(0) == 'multi_window') {
    print('执行了窗口：$args');
    final windowId = int.parse(args[1]);
    print('窗口ID$windowId');
    final arguments = args[2].isEmpty
        ? const {}
        : jsonDecode(args[2]) as Map<String, dynamic>;
    print('arguments: $arguments');
    /// 通过打开窗口的参数来选择创建的窗口，这里类似咱们使用的路由，小伙伴们可以抽离出去
    Map windows = {
      "client": SSHClientWidget(
        windowController: WindowController.fromWindowId(windowId),
        args: arguments,
      ),
    };
    // print('窗口名：${arguments["name]}');

    runApp(windows[arguments["name"]]);
  } else {
    runApp(MyApp());
  }

  doWhenWindowReady(() {
    const initialSize = Size(820, 600);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "ZShell";
    appWindow.show();
  });
}

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      title: "About",
      home: Scaffold(
        body: Center(
          child: Text("this is about"),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Zshell",
      initialRoute: AppPages.InitRoute,
      // 默认路由
      getPages: AppPages.routers,
      // 页面表
      unknownRoute: AppPages.unknownRoute,
      // 404路由
      // 基础配置
      debugShowCheckedModeBanner: false,
      // 不显示debug
      color: Colors.transparent,
    );
  }
}
