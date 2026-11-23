import '../config/back4app_config.dart';

class Validators {
  static String? email(String? value) {
    final email = value?.trim().toLowerCase() ?? '';
    if (email.isEmpty) return 'Student email is required.';

    final valid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    if (!valid) return 'Enter a valid email address.';

    final domain = Back4AppConfig.studentEmailDomain.trim().toLowerCase();
    if (domain.isNotEmpty && !email.endsWith('@$domain')) {
      return 'Use your @$domain student email.';
    }
    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required.';
    if (password.length < 8) return 'Use at least 8 characters.';
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Include at least one uppercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Include at least one number.';
    }
    return null;
  }

  static String? requiredText(String? value, {String label = 'Value'}) {
    if ((value ?? '').trim().isEmpty) return '$label is required.';
    return null;
  }
}
