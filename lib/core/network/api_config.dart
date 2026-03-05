import 'dart:io';

class ApiConfig {
  // Automatically detects if running on Android Emulator or iOS
  static String get baseUrl {
    if (Platform.isAndroid) return "http://10.0.2.2:8000/api";
    return "http://127.0.0.1:8000/api";
  }

  // Auth
  static String get register => "$baseUrl/register/";
  static String get login => "$baseUrl/login/";

  // Marketplace & Profiles
  static String get tailors => "$baseUrl/tailors/";
  static String get customerProfile => "$baseUrl/customer-profiles/";
  static String get projects => "$baseUrl/projects/";
}