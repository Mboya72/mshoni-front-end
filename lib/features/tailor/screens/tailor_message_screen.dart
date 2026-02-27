import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- SKY BLUE PREMIUM PALETTE ---
const Color skyScaffoldBg = Color(0xFFF0F7FF);
const Color skyBluePrimary = Color(0xFF0EA5E9);
const Color skyBlueDark = Color(0xFF0369A1);
const Color textMain = Color(0xFF1A1D21);

class ChatData {
  final String name, message, time, status;
  final bool isUnread;
  final int unreadCount;

  ChatData({
    required this.name,
    required this.message,
    required this.time,
    required this.status,
    required this.isUnread,
    required this.unreadCount,
  });
}

class TailorMessageScreen extends StatefulWidget {
  const TailorMessageScreen({super.key});

  @override
  State<TailorMessageScreen> createState() => _TailorMessageScreenState();
}

class _TailorMessageScreenState extends State<TailorMessageScreen> {
  String activeTab = "All";

  final List<ChatData> allChats = [
    ChatData(name: "James Omari", message: "Is the tuxedo ready for fitting?", time: "10:30 AM", status: "Active Client", isUnread: true, unreadCount: 1),
    ChatData(name: "Sarah W.", message: "Sent the KSh 5,000 deposit via M-Pesa.", time: "09:15 AM", status: "New Inquiry", isUnread: true, unreadCount: 2),
    ChatData(name: "David K.", message: "The waist is a bit tight on the blue suit.", time: "Yesterday", status: "Fitting Feedback", isUnread: false, unreadCount: 0),
    ChatData(name: "Mercy J.", message: "Can you make a dress by Saturday?", time: "Monday", status: "Urgent", isUnread: false, unreadCount: 0),
    ChatData(name: "Ahmad Tailor", message: "Fabric supplier is here.", time: "Monday", status: "Supplier", isUnread: true, unreadCount: 5),
  ];

  List<ChatData> get filteredChats {
    if (activeTab == "Unread") return allChats.where((c) => c.isUnread).toList();
    if (activeTab == "Clients") return allChats.where((c) => c.status == "Active Client").toList();
    return allChats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        title: const Text(
          "Client Chats",
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: textMain), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // --- FUNCTIONAL SKY TABS ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildTab("All", allChats.length),
                const SizedBox(width: 24),
                _buildTab("Unread", allChats.where((c) => c.isUnread).length),
                const SizedBox(width: 24),
                _buildTab("Clients"),
              ],
            ),
          ),

          // --- CHAT LIST ---
          Expanded(
            child: filteredChats.isEmpty
                ? Center(child: Text("No $activeTab conversations", style: const TextStyle(color: Colors.grey)))
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemCount: filteredChats.length,
              itemBuilder: (context, index) {
                return _ClientChatTile(chat: filteredChats[index]);
              },
            ),
          ),
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
              Text(
                label,
                style: TextStyle(
                  color: isActive ? skyBluePrimary : Colors.grey[600],
                  fontWeight: isActive ? FontWeight.bold : FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              if (count != null && count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive ? skyBluePrimary : Colors.grey[300],
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isActive ? 24 : 0,
            decoration: BoxDecoration(
              color: skyBluePrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
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
            Text(chat.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                fontWeight: chat.isUnread ? FontWeight.bold : FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // --- THE STATUS TAG ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: skyBluePrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                chat.status,
                style: const TextStyle(
                  color: skyBlueDark,
                  fontSize: 10,
                  fontWeight: FontWeight.w900, // Extra bold for the tag
                ),
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
                child: Text(
                  "${chat.unreadCount}",
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              )
            else
              const Icon(Icons.done_all, size: 18, color: skyBluePrimary),
            const SizedBox(height: 15),
            const Icon(Icons.chevron_right, color: Colors.black12, size: 18),
          ],
        ),
      ),
    );
  }
}