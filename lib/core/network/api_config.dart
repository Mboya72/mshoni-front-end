import 'dart:io';

class ApiConfig {
  // Set to false to use the live Render backend
  static const String baseUrl = "https://mshoni-back-end.onrender.com/api";
  // ==========================================
  // 1. AUTHENTICATION & USER
  // ==========================================
  static String get login => "$baseUrl/users/login/";
  static String get register => "$baseUrl/users/register/";
  static String get googleLogin => "$baseUrl/users/google/";
  static String get tokenRefresh => "$baseUrl/users/token/refresh/";
  static String get profile => "$baseUrl/users/me/";
  static String get updateProfile => "$baseUrl/users/profile/update/";

  // ==========================================
  // 2. MARKETPLACE & TAILORS
  // ==========================================
  static String get tailors => "$baseUrl/marketplace/tailors/";
  static String tailorDetails(int id) => "$baseUrl/marketplace/tailors/$id/";
  static String get categories => "$baseUrl/marketplace/categories/";
  static String get searchTailors => "$baseUrl/marketplace/search/";

  // ==========================================
  // 3. PROJECTS & ORDERS (Mshoni Core)
  // ==========================================
  static String get projects => "$baseUrl/projects/";
  static String projectDetails(int id) => "$baseUrl/projects/$id/";
  static String projectMeasurements(int id) => "$baseUrl/projects/$id/measurements/";
  static String projectMilestones(int id) => "$baseUrl/projects/$id/milestones/";

  // ==========================================
  // 4. PAYMENTS (M-Pesa / Daraja)
  // ==========================================
  static String get stkPush => "$baseUrl/payments/stk-push/";
  static String get paymentHistory => "$baseUrl/payments/history/";
  static String get paymentStatus => "$baseUrl/payments/query-status/";

  // ==========================================
  // 5. MEDIA & CLOUDINARY
  // ==========================================
  static String get uploadMedia => "$baseUrl/media/upload/";
  static String get myFiles => "$baseUrl/media/files/";

  // ==========================================
  // 6. MESSAGING & NOTIFICATIONS
  // ==========================================
  static String get chatRooms => "$baseUrl/chat/rooms/";
  static String chatMessages(int roomId) => "$baseUrl/chat/rooms/$roomId/messages/";
  static String get notifications => "$baseUrl/notifications/";

  // ==========================================
  // 7. INVENTORY (For Tailors)
  // ==========================================
  static String get inventoryItems => "$baseUrl/inventory/items/";
  static String inventoryDetails(int id) => "$baseUrl/inventory/items/$id/";
}