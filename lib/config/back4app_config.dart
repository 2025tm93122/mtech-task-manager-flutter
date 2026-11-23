import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Back4AppConfig {
  static const appId = String.fromEnvironment('PARSE_APP_ID');

  static const clientKey = String.fromEnvironment(
    'PARSE_CLIENT_KEY',
    defaultValue: '',
  );

  static const serverUrl = String.fromEnvironment(
    'PARSE_SERVER_URL',
    defaultValue: '',
  );

  static const liveQueryUrl = String.fromEnvironment(
    'PARSE_LIVE_QUERY_URL',
    defaultValue: '',
  );

  static const studentEmailDomain = String.fromEnvironment(
    'STUDENT_EMAIL_DOMAIN',
    defaultValue: '',
  );

  static bool get isConfigured =>
      appId.trim().isNotEmpty && serverUrl.trim().isNotEmpty;

  static Future<void> initialize() async {
    if (!isConfigured) return;

    await Parse().initialize(
      appId.trim(),
      serverUrl.trim(),
      clientKey: clientKey.trim().isEmpty ? null : clientKey.trim(),
      liveQueryUrl:
          liveQueryUrl.trim().isEmpty ? null : liveQueryUrl.trim(),
      autoSendSessionId: true,
      debug: true,
    );
  }
}