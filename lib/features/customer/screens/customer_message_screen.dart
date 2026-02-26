import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

// --- PREMIUM PALETTE ---
const Color scaffoldBg = Color(0xFFF1F5F9); // The "darker than white" background
const Color textMain = Color(0xFF1A1D21);
const Color accentBlue = Color(0xFF3B82F6);

class ChatData {
  final String name, message, time;
  final bool isUnread;
  final int unreadCount;

  ChatData({
    required this.name,
    required this.message,
    required this.time,
    required this.isUnread,
    required this.unreadCount,
  });
}

class CustomerMessageScreen extends StatefulWidget {
  const CustomerMessageScreen({super.key});

  @override
  State<CustomerMessageScreen> createState() => _CustomerMessageScreenState();
}

class _CustomerMessageScreenState extends State<CustomerMessageScreen> {
  // 1. ACTIVE TAB STATE
  String activeTab = "All";

  // 2. DATA LIST
  final List<ChatData> allChats = [
    ChatData(name: "Aldira Gans", message: "Why did you do that?", time: "15:20 PM", isUnread: true, unreadCount: 1),
    ChatData(name: "Reza Eji", message: "Small business, a coffee shop.", time: "14:10 PM", isUnread: true, unreadCount: 2),
    ChatData(name: "John Master", message: "Your suit is ready for pickup!", time: "12:00 PM", isUnread: false, unreadCount: 0),
    ChatData(name: "Sarah Stylist", message: "I sent the fabric samples.", time: "Yesterday", isUnread: false, unreadCount: 0),
    ChatData(name: "Ahmad Tailor", message: "Can we move the fitting?", time: "Monday", isUnread: true, unreadCount: 5),
  ];

  // 3. FILTER LOGIC
  List<ChatData> get filteredChats {
    if (activeTab == "Unread") return allChats.where((c) => c.isUnread).toList();
    if (activeTab == "Read") return allChats.where((c) => !c.isUnread).toList();
    return allChats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Entire screen background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: scaffoldBg,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Messages",
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: textMain), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // --- FUNCTIONAL TABS ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildTab("All", allChats.length),
                const SizedBox(width: 24),
                _buildTab("Unread", allChats.where((c) => c.isUnread).length),
                const SizedBox(width: 24),
                _buildTab("Read"),
              ],
            ),
          ),

          // --- CHAT LIST ---
          Expanded(
            child: filteredChats.isEmpty
                ? Center(child: Text("No $activeTab messages", style: const TextStyle(color: Colors.grey)))
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                return _ChatTile(chat: filteredChats[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB BUILDER ---
  Widget _buildTab(String label, [int? count]) {
    bool isActive = activeTab == label;
    return GestureDetector(
      onTap: () => setState(() => activeTab = label),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isActive ? accentBlue : Colors.grey[600],
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              if (count != null && count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive ? accentBlue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "$count",
                    style: TextStyle(
                        color: isActive ? Colors.white : textMain,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(height: 4),
          // Animated indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isActive ? 20 : 0,
            decoration: BoxDecoration(
              color: accentBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

// --- CHAT TILE ---
class _ChatTile extends StatelessWidget {
  final ChatData chat;
  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, // White tile stands out against grey bg
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {}, // Detail navigation
        contentPadding: const EdgeInsets.all(12),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${chat.name}'),
            ),
            if (chat.isUnread)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: accentBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          chat.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            chat.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: chat.isUnread ? textMain : Colors.grey,
              fontWeight: chat.isUnread ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              chat.time,
              style: TextStyle(
                fontSize: 11,
                color: chat.isUnread ? accentBlue : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            if (chat.isUnread)
              CircleAvatar(
                radius: 10,
                backgroundColor: accentBlue,
                child: Text(
                  "${chat.unreadCount}",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
            else
              const Icon(Icons.done_all, size: 18, color: accentBlue),
          ],
        ),
      ),
    );
  }
}