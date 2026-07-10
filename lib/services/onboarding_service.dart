import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingService {
  static const storage = FlutterSecureStorage();

  static const key = "onboarding_completed";

  static Future<void> complete() async {
    await storage.write(
      key: key,
      value: "true",
    );
  }

  static Future<bool> isCompleted() async {
    final value = await storage.read(key: key);
    return value == "true";
  }
}