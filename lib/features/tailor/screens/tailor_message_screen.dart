import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// --- SKY BLUE PREMIUM PALETTE ---
const Color skyScaffoldBg = Color(0xFFF0F7FF);
const Color skyBluePrimary = Color(0xFF0EA5E9);
const Color skyBlueDark = Color(0xFF0369A1);
const Color textMain = Color(0xFF1A1D21);

// --- MODEL ---
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

// --- MAIN WIDGET ---
class TailorMessageScreen extends StatefulWidget {
  const TailorMessageScreen({super.key});

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

  // API Connection Logic
  Future<List<ChatData>> fetchChats() async {
    try {
      final response = await http.get(
        Uri.parse('https://mshoni-back-end.onrender.com/api/chat/threads/'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer YOUR_TOKEN_HERE', // Add your auth logic here
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((json) => ChatData.fromJson(json)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to Mshoni: $e');
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
        title: const Text("Client Chats", style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 24)),
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
          if (activeTab == "Unread") filteredChats = allChats.where((c) => c.isUnread).toList();
          if (activeTab == "Clients") filteredChats = allChats.where((c) => c.status.contains("Client")).toList();

          return RefreshIndicator(
            onRefresh: () async {
              setState(() { futureChats = fetchChats(); });
            },
            child: Column(
              children: [
                _buildTabRow(allChats),
                Expanded(
                  child: filteredChats.isEmpty
                      ? Center(child: Text("No $activeTab conversations"))
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      onTap: () => setState(() => activeTab = label),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: TextStyle(color: isActive ? skyBluePrimary : Colors.grey[600], fontWeight: FontWeight.bold)),
              if (count != null && count > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: isActive ? skyBluePrimary : Colors.grey[300], shape: BoxShape.circle),
                  child: Text("$count", style: TextStyle(color: isActive ? Colors.white : textMain, fontSize: 10)),
                ),
              ],
            ],
          ),
          Container(height: 3, width: 20, margin: const EdgeInsets.only(top: 4), color: isActive ? skyBluePrimary : Colors.transparent),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(error, textAlign: TextAlign.center),
            TextButton(onPressed: () => setState(() { futureChats = fetchChats(); }), child: const Text("Retry")),
          ],
        ),
      ),
    );
  }
}

// --- TILE COMPONENT ---
class _ClientChatTile extends StatelessWidget {
  final ChatData chat;
  const _ClientChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${chat.id}')),
        title: Text(chat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(chat.message, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(chat.time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            if (chat.isUnread)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: skyBluePrimary, shape: BoxShape.circle),
                child: Text("${chat.unreadCount}", style: const TextStyle(color: Colors.white, fontSize: 10)),
              ),
          ],
        ),
      ),
    );
  }
}