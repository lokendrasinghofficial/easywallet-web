import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/banner_widget.dart';
import '../widgets/action_button.dart';
import '../widgets/grid_item.dart';
import '../widgets/auto_sliding_banners.dart';
import 'qr_scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Soft light background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), // Dark background
        title: Text(
          appProvider.getText("Easy Wallet", "悠遊付"),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {},
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Promo Banner (Carousel style)
              SizedBox(
                height: 140,
                child: AutoSlidingBanners(
                  banners: [
                    BannerWidget(
                      title: appProvider.getText("30% Cashback", "30% 回饋"),
                      subtitle: appProvider.getText("On your first subway ride using Easy Wallet.", "首次搭乘交通工具使用悠遊付即享回饋"),
                      gradientColors: const [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                      icon: Icons.account_balance_wallet,
                    ),
                    BannerWidget(
                      title: appProvider.getText("Invite Friends", "推薦好友"),
                      subtitle: appProvider.getText("Earn \$10 for every friend who signs up.", "每推薦一位好友加入即可獲得獎勵"),
                      gradientColors: const [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                      icon: Icons.people_alt,
                    ),
                    BannerWidget(
                      title: appProvider.getText("Special Offer", "特別優惠"),
                      subtitle: appProvider.getText("Get discounts on next flight ticket.", "領取下次機票購買折扣券"),
                      gradientColors: const [Color(0xFFfceabb), Color(0xFFf8b500)],
                      icon: Icons.flight_takeoff,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Quick Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionButton(
                    icon: Icons.qr_code_scanner,
                    label: appProvider.getText("Scan / Transfer", "掃碼 / 轉帳"),
                    color: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const QRScannerScreen()),
                      );
                    },
                  ),
                  ActionButton(
                    icon: Icons.qr_code_2,
                    label: appProvider.getText("Payment Code", "付款碼"),
                    color: Colors.orangeAccent,
                  ),
                  ActionButton(
                    icon: Icons.call_received,
                    label: appProvider.getText("Receive Money", "收款"),
                    color: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Secondary Banner
              BannerWidget(
                title: appProvider.getText("3% Cashback", "3% 回饋"),
                subtitle: appProvider.getText("On all online dining purchases this week.", "本週線上美食訂購全額享 3% 回饋"),
                gradientColors: const [Color(0xFF2193b0), Color(0xFF6dd5ed)],
                icon: Icons.restaurant,
              ),
              const SizedBox(height: 24),
              
              // Info Strip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.campaign, color: Colors.amber, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        appProvider.getText(
                          "New transport feature added! Tap the center button to try.", 
                          "新版交通乘車功能上線！點擊中心按鈕體驗。"
                        ),
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Features Grid Section
              Text(
                appProvider.getText("App Features", "熱門服務"),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
                children: [
                  // Row 1
                  GridItem(
                    icon: Icons.eco, 
                    label: appProvider.getText("Carbon\nReduction", "減碳存摺")
                  ),
                  GridItem(
                    icon: Icons.directions_transit, 
                    label: appProvider.getText("TPASS\n2.0+", "TPASS\n2.0+")
                  ),
                  GridItem(
                    icon: Icons.monetization_on, 
                    label: appProvider.getText("Cashback", "回饋金")
                  ),
                  GridItem(
                    icon: Icons.flight_takeoff, 
                    label: appProvider.getText("Travel\nOffers", "旅遊優惠")
                  ),
                  // Row 2
                  GridItem(
                    icon: Icons.local_cafe, 
                    label: appProvider.getText("Easy Life", "悠遊生活")
                  ),
                  GridItem(
                    icon: Icons.account_balance, 
                    label: appProvider.getText("Financial\nServices", "金融服務")
                  ),
                  GridItem(
                    icon: Icons.receipt_long, 
                    label: appProvider.getText("Tax\nBenefits", "所得稅")
                  ),
                  GridItem(
                    icon: Icons.payment, 
                    label: appProvider.getText("Bills\nPayment", "生活繳費")
                  ),
                ],
              ),
              const SizedBox(height: 30), // Padding for bottom navbar
            ],
          ),
        ),
      ),
    );
  }
}
