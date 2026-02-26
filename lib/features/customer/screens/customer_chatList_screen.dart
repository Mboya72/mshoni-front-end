import 'package:flutter/material.dart';

class CustomerChatListScreen extends StatelessWidget {
  const CustomerChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Your defined palette
    const Color scaffoldBg = Color(0xFFE9EEF5);
    const Color textMain = Color(0xFF1A1D21);
    const Color accentBlue = Color(0xFF4B84F1);
    const Color emeraldGreen = Color(0xFF2ECC71);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: const Text(
          "Messages",
          style: TextStyle(
              color: textMain,
              fontWeight: FontWeight.bold,
              fontSize: 24
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: textMain),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: 5, // Replace with your actual data length
        itemBuilder: (context, index) {
          return _buildChatTile(
            context,
            name: "Service Provider ${index + 1}",
            lastMessage: "Your order has been processed successfully.",
            time: "12:45 PM",
            isUnread: index == 0, // Mocking the first one as unread
            accent: accentBlue,
            textMain: textMain,
            emerald: emeraldGreen,
          );
        },
      ),
    );
  }

  Widget _buildChatTile(
      BuildContext context, {
        required String name,
        required String lastMessage,
        required String time,
        required bool isUnread,
        required Color accent,
        required Color textMain,
        required Color emerald,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          // Navigate to the specific chat details screen
          // Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerMessageScreen()));
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: accent.withValues(alpha: 0.1),
              child: const Icon(Icons.person, color: Color(0xFF4B84F1)),
            ),
            if (isUnread)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: emerald,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          name,
          style: TextStyle(
            color: textMain,
            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textMain.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(
                color: isUnread ? accent : Colors.grey,
                fontSize: 12,
                fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 6),
            if (isUnread)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  "1",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }
}