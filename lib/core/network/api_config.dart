class ApiConfig {
  // Use 10.0.2.2 for Android Emulator, 127.0.0.1 for iOS/Physical Device
  static const String baseUrl = "http://127.0.0.1:8000/api";

  // 1️⃣ Auth Endpoints
  static const String register = "$baseUrl/register/";
  static const String login = "$baseUrl/login/"; // This is your SimpleJWT token endpoint
  static const String tokenRefresh = "$baseUrl/token/refresh/";

  // 2️⃣ Profile & User Data
  static const String customerProfile = "$baseUrl/customer-profiles/";
  static const String tailors = "$baseUrl/tailors/"; // To browse available tailors

  // 3️⃣ Tailoring Workflow
  static const String measurements = "$baseUrl/measurements/";
  static const String lookbook = "$baseUrl/lookbook/";
  static const String jobs = "$baseUrl/jobs/";
  static const String projects = "$baseUrl/projects/";

  // 4️⃣ Marketplace (Sellers)
  static const String materials = "$baseUrl/materials/";

  // 5️⃣ Communication
  static const String messages = "$baseUrl/messages/";
  static const String notifications = "$baseUrl/notifications/";

  // Supabase Redirect Scheme (If using for Social Auth)
  static const String redirectUrl = 'io.supabase.flutter://login-callback';
}