class ApiConfig {
  static const String baseUrl = "https://mshoni-back-end.onrender.com/api";

  // ==========================================
  // 1. AUTHENTICATION & USER
  // ==========================================
  static String get login => "$baseUrl/users/login/";
  static String get register => "$baseUrl/users/register/";
  static String get googleLogin => "$baseUrl/users/google/";
  static String get profile => "$baseUrl/users/me/";

  // ==========================================
  // 2. MARKETPLACE & DASHBOARD
  // ==========================================
  // ADD THIS: This fixes the 403/404 for your stats dashboard
  static String get marketplaceStats => "$baseUrl/marketplace/stats/";
  static String get tailors => "$baseUrl/marketplace/tailors/";
  static String get orders => "$baseUrl/marketplace/orders/";

  // ==========================================
  // 3. MESSAGING (Mshoni Threads)
  // ==========================================
  static String get chatThreads => "$baseUrl/chat/threads/";
  static String acknowledgeReceipt(int msgId) => "$baseUrl/chat/messages/$msgId/acknowledge_receipt/";
  static String markSeen(int msgId) => "$baseUrl/chat/messages/$msgId/mark_seen/";

  // ==========================================
  // 4. PROJECTS & PAYMENTS
  // ==========================================
  static String get projects => "$baseUrl/projects/";
  static String get stkPush => "$baseUrl/payments/stk-push/";

  // ==========================================
  // 5. INVENTORY
  // ==========================================
  static String get inventoryItems => "$baseUrl/inventory/items/";
}