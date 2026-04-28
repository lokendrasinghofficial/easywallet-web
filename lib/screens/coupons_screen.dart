import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    final coupons = [
      {
        'brand': 'McDonald\'s',
        'title': appProvider.getText('Buy One Get One Free', '買一送一'),
        'desc': appProvider.getText('Big Mac + Large Fries', '大麥克 + 大薯'),
        'expiry': '2026/12/31',
        'image': '/Users/Loki/NTPU/0918.jpg',
        'color': Colors.red[700],
      },
      {
        'brand': 'KFC',
        'title': appProvider.getText('Fried Chicken Super Value', '炸雞超值配'),
        'desc': appProvider.getText('40% Off on selected sets', '指定套餐 6 折起'),
        'expiry': '2026/12/31',
        'image':
            '/Users/Loki/.gemini/antigravity/brain/4bcadd08-1e9f-4cd3-8364-a7dee7a81ab1/kfc_coupon_1777398509557.png',
        'color': Colors.red[900],
      },
      {
        'brand': '7-Eleven',
        'title': appProvider.getText('Selected Items Discount', '指定商品優惠'),
        'desc': appProvider.getText('21% Off for 2 items', '兩件 79 折'),
        'expiry': '2026/11/30',
        'image':
            '/Users/Loki/.gemini/antigravity/brain/4bcadd08-1e9f-4cd3-8364-a7dee7a81ab1/seven_eleven_coupon_1777398534161.png',
        'color': Colors.green[700],
      },
      {
        'brand': 'FamilyMart',
        'title': appProvider.getText('Selected Drinks Half Price', '指定飲品半價'),
        'desc': appProvider.getText('Buy 2nd item for 50% off', '第二件半價'),
        'expiry': '2026/11/21',
        'image':
            '/Users/Loki/.gemini/antigravity/brain/4bcadd08-1e9f-4cd3-8364-a7dee7a81ab1/familymart_coupon_1777398561079.png',
        'color': Colors.blue[600],
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          appProvider.getText('My Coupons', '我的優惠券'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.file(
                      File(coupon['image'] as String),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: coupon['color'] as Color,
                          child: const Icon(
                            Icons.confirmation_num,
                            color: Colors.white,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coupon['brand'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: coupon['color'] as Color,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                coupon['title'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                coupon['desc'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: coupon['color'] as Color,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                appProvider.getText('Use Now', '立即使用'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${appProvider.getText('Expires', '有效期至')} ${coupon['expiry']}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
