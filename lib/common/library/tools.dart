import 'dart:io';
import 'dart:math';

String get shell {
  if (Platform.isMacOS || Platform.isLinux) {
    return Platform.environment['SHELL'] ?? 'bash';
  }

  if (Platform.isWindows) {
    return 'cmd.exe';
  }

  return 'sh';
}

// Define a reusable function
String generateRandomString(int length) {
  final _random = Random();
  const _availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString = List.generate(length,
          (index) => _availableChars[_random.nextInt(_availableChars.length)])
      .join();

  return randomString;
}