import 'package:flutter_test/flutter_test.dart';
import 'package:mtech_task_manager/utils/validators.dart';

void main() {
  group('Validators', () {
    test('email rejects malformed input', () {
      expect(Validators.email('not-an-email'), isNotNull);
    });

    test('email accepts normal student-style email when no domain is configured', () {
      expect(Validators.email('student@example.edu'), isNull);
    });

    test('password requires minimum strength', () {
      expect(Validators.password('short'), isNotNull);
      expect(Validators.password('StrongPass1'), isNull);
    });

    test('required text rejects whitespace', () {
      expect(Validators.requiredText('   ', label: 'Title'), 'Title is required.');
    });
  });
}
