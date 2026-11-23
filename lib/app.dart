import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'config/back4app_config.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/auth_service.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M.Tech Task Manager',
      theme: AppTheme.light(),
      home: Back4AppConfig.isConfigured ? const AuthGate() : const ConfigurationScreen(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _auth = const AuthService();
  late Future<ParseUser?> _session;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _session = _auth.currentUser();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParseUser?>(
      future: _session,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final user = snapshot.data;
        if (user == null) return LoginScreen(onAuthenticated: _reload);
        return HomeScreen(user: user, onLoggedOut: _reload);
      },
    );
  }
}

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.settings_suggest_outlined, size: 44, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 18),
                      Text('Back4App configuration required', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      const Text(
                        'The application code is ready, but it needs your own Back4App Application ID and Client Key. '
                        'Do not hard-code or commit those values. Use the provided .back4app.env template and scripts/run_ios.sh.',
                      ),
                      const SizedBox(height: 16),
                      const SelectableText('cp .back4app.env.example .back4app.env\n# fill in your keys\nbash scripts/run_ios.sh'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
