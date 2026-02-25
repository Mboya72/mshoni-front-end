import 'package:flutter/material.dart';

// --- PREMIUM PALETTE ---
const Color scaffoldBg = Color(0xFFF8F9FB); // Lighter background for that clean look
const Color textMain = Color(0xFF1A1D21);
const Color accentBlue = Color(0xFF3B82F6); // Vibrant Blue from the image
const Color lightGrey = Color(0xFFE5E7EB);

class CustomerMessageScreen extends StatefulWidget {
  const CustomerMessageScreen({super.key});

  @override
  State<CustomerMessageScreen> createState() => _CustomerMessageScreenState();
}

class _CustomerMessageScreenState extends State<CustomerMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Messages",
          style: TextStyle(color: textMain, fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: textMain), onPressed: () {}),
          IconButton(icon: const Icon(Icons.sort, color: textMain), onPressed: () {}),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90), // Sits above the CurvedNavBar
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onPressed: () {},
          child: const Icon(Icons.add, color: accentBlue, size: 30),
        ),
      ),
      body: Column(
        children: [
          // --- TAB FILTER SECTION ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTab("All", true, count: 3),
                _buildTab("Unread", false),
                _buildTab("Read", false),
              ],
            ),
          ),
          const Divider(height: 1),

          // --- CHAT LIST ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 110),
              itemCount: 8,
              itemBuilder: (context, index) {
                return _ChatTile(
                  name: index == 0 ? "Aldira Gans" : "Reza Eji",
                  message: index == 0 ? "Why did you do that?" : "Small business, a coffee shop.",
                  time: "15:20 PM",
                  isUnread: index < 2,
                  unreadCount: index + 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isActive, {int? count}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? accentBlue : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: accentBlue, borderRadius: BorderRadius.circular(10)),
                child: Text("$count", style: const TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ]
          ],
        ),
        const SizedBox(height: 8),
        if (isActive)
          Container(height: 2, width: 60, color: accentBlue)
        else
          Container(height: 2, width: 60, color: Colors.transparent),
      ],
    );
  }
}

// --- CHAT TILE COMPONENT ---
class _ChatTile extends StatelessWidget {
  final String name, message, time;
  final bool isUnread;
  final int unreadCount;

  const _ChatTile({required this.name, required this.message, required this.time, required this.isUnread, required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => _DetailChat(name: name))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 26,
        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$name'),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 5),
          if (isUnread)
            CircleAvatar(radius: 10, backgroundColor: accentBlue, child: Text("$unreadCount", style: const TextStyle(color: Colors.white, fontSize: 10)))
          else
            const Icon(Icons.done_all, size: 16, color: accentBlue),
        ],
      ),
    );
  }
}

// --- DETAIL CHAT SCREEN ---
class _DetailChat extends StatelessWidget {
  final String name;
  const _DetailChat({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: accentBlue, size: 20), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$name')),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: textMain, fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("Online", style: TextStyle(color: accentBlue, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam_outlined, color: accentBlue), onPressed: () {}),
          IconButton(icon: const Icon(Icons.phone_outlined, color: accentBlue), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("Today", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _bubble("Fiqrih! How are you? It's been a long time since we last met.", false, "10:58 PM"),
                _bubble("Oh, hi Reza! I have got a new job now and is going great. How about you?", true, "11:06 AM"),
                _bubble("Small business, a coffee shop.", false, "12:09 PM"),
              ],
            ),
          ),
          _inputArea(),
        ],
      ),
    );
  }

  Widget _bubble(String text, bool isMe, String time) {
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: isMe ? accentBlue : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(20).copyWith(
              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(20),
              bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(0),
            ),
          ),
          child: Text(text, style: TextStyle(color: isMe ? Colors.white : textMain, height: 1.4)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 2),
          child: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ),
      ],
    );
  }

  Widget _inputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(24)),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Type a Message...",
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.camera_alt_outlined, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const CircleAvatar(backgroundColor: accentBlue, child: Icon(Icons.mic, color: Colors.white)),
        ],
      ),
    );
  }
}