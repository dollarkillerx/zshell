import 'dart:convert';
import 'package:bruno/bruno.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xterm/core.dart';
import 'package:xterm/ui.dart';
import 'package:zshell/common/entity/zshell.dart';
import 'package:dartssh2/dartssh2.dart';
import '../../widget/virtual_keyboard.dart';

class SSHClientWidget extends StatelessWidget {
  final WindowController windowController;
  final Map? args;

  const SSHClientWidget({Key? key, required this.windowController, this.args})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Hosts hosts = Hosts.fromJson(args?["hosts"]);

    return MaterialApp(
      title:
          'ZShell Client ${hosts.label} ${hosts.username} ${hosts.address}:${hosts.port}',
      debugShowCheckedModeBanner: false,
      home: Client(
        hosts: hosts,
        windowController: windowController,
      ),
      // shortcuts: ,
    );
  }
}

class Client extends StatefulWidget {
  final WindowController windowController;
  final Hosts hosts;

  const Client({Key? key, required this.hosts, required this.windowController})
      : super(key: key);

  @override
  State<Client> createState() => _ClientState(hosts, windowController);
}

class _ClientState extends State<Client> {
  final WindowController windowController;
  final Hosts hosts;
  var title;

  _ClientState(this.hosts, this.windowController);

  late final terminal = Terminal(inputHandler: keyboard);

  final keyboard = VirtualKeyboard(defaultInputHandler);

  @override
  void initState() {
    super.initState();
    initTerminal();

    title = hosts.address;
  }

  Future<void> initTerminal() async {
    terminal.write('Connecting...\r\n');

    try {
      final client = SSHClient(
        await SSHSocket.connect(hosts.address!, hosts.port!),
        username: hosts.username!,
        onPasswordRequest: () => hosts.password!,
      );

      terminal.write('Connected\r\n');

      final session = await client.shell(
        pty: SSHPtyConfig(
          width: terminal.viewWidth,
          height: terminal.viewHeight,
        ),
      );

      terminal.buffer.clear();
      terminal.buffer.setCursor(0, 0);

      terminal.onTitleChange = (title) {
        setState(() => this.title = title);
      };

      terminal.onResize = (width, height, pixelWidth, pixelHeight) {
        session.resizeTerminal(width, height, pixelWidth, pixelHeight);
      };

      terminal.onOutput = (data) {
        session.write(utf8.encode(data) as Uint8List);
      };

      session.stdout
          .cast<List<int>>()
          .transform(Utf8Decoder())
          .listen(terminal.write);

      session.stderr
          .cast<List<int>>()
          .transform(Utf8Decoder())
          .listen(terminal.write);
    } catch (e) {
      terminal.write('Connected Error: $e \r\n');
      BrnEnhanceOperationDialog(
        iconType: BrnDialogConstants.iconWarning,
        context: context,
        titleText: "Connected Error",
        descText: "$e",
        mainButtonText: "Yes",
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
            'ZShell Client ${hosts.label} ${hosts.username} ${hosts.address}:${hosts.port}'),
        backgroundColor:
            CupertinoTheme.of(context).barBackgroundColor.withOpacity(0.5),
      ),
      child: TerminalView(terminal),
    );
  }
}
