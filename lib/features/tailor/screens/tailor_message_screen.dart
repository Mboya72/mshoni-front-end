import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// --- SKY BLUE PREMIUM PALETTE ---
const Color skyScaffoldBg = Color(0xFFF0F7FF);
const Color skyBluePrimary = Color(0xFF0EA5E9);
const Color skyBlueDark = Color(0xFF0369A1);
const Color textMain = Color(0xFF1A1D21);

class ChatData {
  final int id;
  final String name, message, time, status;
  final bool isUnread;
  final int unreadCount;

  ChatData({
    required this.id, required this.name, required this.message,
    required this.time, required this.status, required this.isUnread, required this.unreadCount,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      id: json['id'] ?? 0,
      name: json['other_user_name'] ?? 'Unknown',
      message: json['last_message'] ?? 'No messages yet',
      time: json['timestamp_formatted'] ?? '',
      status: json['user_role'] ?? 'Client',
      isUnread: (json['unread_count'] ?? 0) > 0,
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}

class TailorMessageScreen extends StatefulWidget {
  // 1. ADD THIS: Accept the token from the previous screen
  final String authToken;
  const TailorMessageScreen({super.key, required this.authToken});

  @override
  State<TailorMessageScreen> createState() => _TailorMessageScreenState();
}

class _TailorMessageScreenState extends State<TailorMessageScreen> {
  String activeTab = "All";
  late Future<List<ChatData>> futureChats;

  @override
  void initState() {
    super.initState();
    futureChats = fetchChats();
  }

  Future<List<ChatData>> fetchChats() async {
    try {
      final response = await http.get(
        Uri.parse('https://mshoni-back-end.onrender.com/api/chat/threads/'),
        headers: {
          'Content-Type': 'application/json',
          // 2. FIX: Use widget.authToken to get the real token
          'Authorization': 'Bearer ${widget.authToken}',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((json) => ChatData.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        // Log this to see if the token is actually being sent correctly
        debugPrint("Access Denied for token: ${widget.authToken}");
        throw Exception('Session Expired: Please log in again.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: skyScaffoldBg,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
            "Messages",
            style: TextStyle(color: textMain, fontWeight: FontWeight.w900, fontSize: 26)
        ),
      ),
      body: FutureBuilder<List<ChatData>>(
        future: futureChats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: skyBluePrimary));
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          final allChats = snapshot.data ?? [];

          List<ChatData> filteredChats = allChats;
          if (activeTab == "Unread") {
            filteredChats = allChats.where((c) => c.isUnread).toList();
          } else if (activeTab == "Clients") {
            filteredChats = allChats.where((c) => c.status.toLowerCase().contains("client")).toList();
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() { futureChats = fetchChats(); });
            },
            child: Column(
              children: [
                _buildTabRow(allChats),
                Expanded(
                  child: filteredChats.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredChats.length,
                    itemBuilder: (context, index) => _ClientChatTile(chat: filteredChats[index]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabRow(List<ChatData> all) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _buildTab("All", all.length),
          const SizedBox(width: 24),
          _buildTab("Unread", all.where((c) => c.isUnread).length),
          const SizedBox(width: 24),
          _buildTab("Clients"),
        ],
      ),
    );
  }

  Widget _buildTab(String label, [int? count]) {
    bool isActive = activeTab == label;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => activeTab = label);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label,
                  style: TextStyle(
                      color: isActive ? skyBluePrimary : Colors.grey[500],
                      fontWeight: FontWeight.w800,
                      fontSize: 15
                  )
              ),
              if (count != null && count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: isActive ? skyBluePrimary : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text("$count", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isActive ? 20 : 0,
            decoration: BoxDecoration(color: skyBluePrimary, borderRadius: BorderRadius.circular(2)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text("No $activeTab chats found", style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
          const SizedBox(height: 10),
          Text(error.contains("403") ? "Session Expired" : "Connection Error"),
          TextButton(onPressed: () => setState(() { futureChats = fetchChats(); }), child: const Text("Retry")),
        ],
      ),
    );
  }
}

class _ClientChatTile extends StatelessWidget {
  final ChatData chat;
  const _ClientChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: skyBluePrimary.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {},
        contentPadding: const EdgeInsets.all(12),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: skyBluePrimary.withOpacity(0.1),
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${chat.id}'),
            ),
            if (chat.isUnread)
              Positioned(
                right: 0, bottom: 0,
                child: Container(
                  width: 14, height: 14,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(chat.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textMain)),
            Text(chat.time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              chat.message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: chat.isUnread ? textMain : Colors.black45,
                fontWeight: chat.isUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: skyBluePrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                chat.status,
                style: const TextStyle(color: skyBlueDark, fontSize: 10, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (chat.isUnread)
              CircleAvatar(
                radius: 10,
                backgroundColor: skyBluePrimary,
                child: Text("${chat.unreadCount}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            else
              const Icon(Icons.done_all, size: 18, color: skyBluePrimary),
            const SizedBox(height: 4),
            const Icon(Icons.chevron_right, color: Colors.black12, size: 18),
          ],
        ),
      ),
    );
  }
}