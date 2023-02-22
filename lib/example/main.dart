// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:dartssh2/dartssh2.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:xterm/xterm.dart';
// import 'package:zshell/widget/virtual_keyboard.dart';
//
// const host = '127.0.0.1';
// const port = 22;
// const username = 'root';
// const password = 'root';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoApp(
//       title: 'xterm.dart demo',
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late final terminal = Terminal(inputHandler: keyboard);
//
//   final keyboard = VirtualKeyboard(defaultInputHandler);
//
//   var title = host;
//
//   @override
//   void initState() {
//     super.initState();
//     initTerminal();
//   }
//
//   Future<void> initTerminal() async {
//     terminal.write('Connecting...\r\n');
//
//     final client = SSHClient(
//       await SSHSocket.connect(host, port),
//       username: username,
//       onPasswordRequest: () => password,
//     );
//
//     terminal.write('Connected\r\n');
//
//     final session = await client.shell(
//       pty: SSHPtyConfig(
//         width: terminal.viewWidth,
//         height: terminal.viewHeight,
//       ),
//     );
//
//     terminal.buffer.clear();
//     terminal.buffer.setCursor(0, 0);
//
//     terminal.onTitleChange = (title) {
//       setState(() => this.title = title);
//     };
//
//     terminal.onResize = (width, height, pixelWidth, pixelHeight) {
//       session.resizeTerminal(width, height, pixelWidth, pixelHeight);
//     };
//
//     terminal.onOutput = (data) {
//       session.write(utf8.encode(data) as Uint8List);
//     };
//
//     session.stdout
//         .cast<List<int>>()
//         .transform(Utf8Decoder())
//         .listen(terminal.write);
//
//     session.stderr
//         .cast<List<int>>()
//         .transform(Utf8Decoder())
//         .listen(terminal.write);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         middle: Text(title),
//         backgroundColor:
//         CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.5),
//       ),
//       child: Column(
//         children: [
//           Expanded(
//             child: TerminalView(terminal),
//           ),
//           VirtualKeyboardView(keyboard),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pty/flutter_pty.dart';
import 'package:xterm/xterm.dart';
import 'package:zshell/widget/platform_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xterm.dart demo',
      debugShowCheckedModeBanner: false,
      home: AppPlatformMenu(child: Home()),
      // shortcuts: ,
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final terminal = Terminal(
    maxLines: 10000,
  );

  final terminalController = TerminalController();

  late final Pty pty;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) _startPty();
      },
    );
  }

  void _startPty() {
    pty = Pty.start(
      shell,
      columns: terminal.viewWidth,
      rows: terminal.viewHeight,
    );

    final client = SSHClient(
      await SSHSocket.connect(host, port),
      username: username,
      onPasswordRequest: () => password,
    );

    pty.output
        .cast<List<int>>()
        .transform(Utf8Decoder())
        .listen(terminal.write);

    pty.exitCode.then((code) {
      terminal.write('the process exited with exit code $code');
    });

    terminal.onOutput = (data) {
      pty.write(const Utf8Encoder().convert(data));
    };

    terminal.onResize = (w, h, pw, ph) {
      pty.resize(h, w);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: TerminalView(
          terminal,
          controller: terminalController,
          autofocus: true,
          backgroundOpacity: 0.7,
          onSecondaryTapDown: (details, offset) async {
            final selection = terminalController.selection;
            if (selection != null) {
              final text = terminal.buffer.getText(selection);
              terminalController.clearSelection();
              await Clipboard.setData(ClipboardData(text: text));
            } else {
              final data = await Clipboard.getData('text/plain');
              final text = data?.text;
              if (text != null) {
                terminal.paste(text);
              }
            }
          },
        ),
      ),
    );
  }
}

String get shell {
  if (Platform.isMacOS || Platform.isLinux) {
    return Platform.environment['SHELL'] ?? 'bash';
  }

  if (Platform.isWindows) {
    return 'cmd.exe';
  }

  return 'sh';
}
