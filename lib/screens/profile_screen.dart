import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/wallet_card.dart';
import '../widgets/action_button.dart';
import '../widgets/list_item.dart';
import 'split_money_screen.dart';
import 'coupons_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header and Overlapping Card
            const Stack(
              clipBehavior: Clip.none,
              children: [
                ProfileHeader(),
                Positioned(
                  top: 130, // Adjust overlap based on header height
                  left: 0,
                  right: 0,
                  child: WalletCard(),
                ),
              ],
            ),

            // Padding to account for the overlapping WalletCard
            const SizedBox(height: 190), // Tuned to card height
            // Quick Actions Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionButton(
                    icon: Icons.attach_money,
                    label: appProvider.getText("Add Money", "加值"),
                    color: Colors.green,
                  ),
                  ActionButton(
                    icon: Icons.currency_exchange,
                    label: appProvider.getText("Auto Reload", "自動加值"),
                    color: Colors.blueAccent,
                  ),
                  ActionButton(
                    icon: Icons.file_upload_outlined,
                    label: appProvider.getText("Withdraw", "提領"),
                    color: Colors.orangeAccent,
                  ),
                  ActionButton(
                    icon: Icons.swap_horiz,
                    label: appProvider.getText("Transfer", "轉帳"),
                    color: Colors.pinkAccent,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Options List
            ListItem(
              icon: Icons.call_split,
              title: appProvider.getText("Split Money", "分帳"),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appProvider.getText('NEW', '新功能'),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SplitMoneyScreen()),
                );
              },
            ),
            ListItem(
              icon: Icons.receipt_long,
              title: appProvider.getText("Transaction Records", "交易紀錄"),
            ),
            ListItem(
              icon: Icons.security, 
              title: appProvider.getText("Security Settings", "安全設定")
            ),
            ListItem(
              icon: Icons.credit_card, 
              title: appProvider.getText("Payment Methods", "支付工具管理")
            ),
            ListItem(
              icon: Icons.confirmation_num_outlined,
              title: appProvider.getText("My Coupons", "我的優惠券"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      appProvider.getText("New", "新"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "4",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CouponsScreen()),
                );
              },
            ),
            ListItem(
              icon: Icons.card_giftcard,
              title: appProvider.getText("My Referral Code", "我的推薦碼"),
            ),
            ListItem(
              icon: Icons.link, 
              title: appProvider.getText("Linked Accounts", "銀行帳戶連結")
            ),

            const SizedBox(height: 100), // Bottom padding for navbar
          ],
        ),
      ),
    );
  }
}
