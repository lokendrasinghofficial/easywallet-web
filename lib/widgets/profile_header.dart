import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 20, right: 8, bottom: 90),
      decoration: const BoxDecoration(
        color: Color(0xFF222222),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Icon(Icons.sync, color: Colors.blue[300], size: 30),
            ),
          ),
          const SizedBox(width: 12),

          // User Details — fills remaining space, truncates if needed
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Singh",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // ← Flexible so the account number clips and never overflows
                    Flexible(
                      child: Text(
                        "${appProvider.getText('Account', '帳號')} 2202511214944496",
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.qr_code, color: Colors.grey[400], size: 14),
                    const SizedBox(width: 2),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 10),
                  ],
                ),
              ],
            ),
          ),

          // Settings
          IconButton(
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
