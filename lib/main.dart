import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'config/back4app_config.dart';

class DevelopmentHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    if (kDebugMode) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return host == 'parse-production.up.railway.app';
      };
    }

    return client;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    HttpOverrides.global = DevelopmentHttpOverrides();
  }

  await Back4AppConfig.initialize();

  runApp(const TaskManagerApp());
}