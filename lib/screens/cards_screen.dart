import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'add_card_screen.dart';
import '../widgets/card_widget.dart';
import '../widgets/transaction_item.dart';
import '../widgets/tab_selector.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _selectedTabIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Dark Header Area Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280, // slightly taller so the cards overlap the bottom part of it nicely
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF222222),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Custom Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Singh",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "8486969118",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddCardScreen()),
                          );
                        },
                        icon: const Icon(Icons.add, color: Colors.white, size: 28),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Card Carousel
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CardWidget(index: index, totalCount: 3),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Balance Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            appProvider.getText("Card Balance (Not real-time)", "悠遊卡餘額 (非即時)"),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.info, size: 16, color: Colors.grey[600]),
                          const Spacer(),
                          // Info Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.cancel, size: 14, color: Colors.grey[400]),
                                const SizedBox(width: 4),
                                Text(
                                  appProvider.getText("Not supported for wallet linking", "不支援錢包連結"),
                                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "\$77",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Divider(color: Colors.grey[200], thickness: 1, indent: 24, endIndent: 24),
                const SizedBox(height: 16),

                // Card Actions
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.credit_card, color: Colors.white, size: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      appProvider.getText("EasyCard Registered", "悠遊卡已記名"),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        appProvider.getText("Expiry Date 2037/12/31", "有效期至 2037/12/31"),
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Sheet Custom (Using DraggableScrollableSheet)
          DraggableScrollableSheet(
            initialChildSize: 0.28,
            minChildSize: 0.25,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Handle Bar
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 16),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Tabs
                    TabSelector(
                      tabs: [
                        appProvider.getText("Transactions", "交易紀錄"), 
                        appProvider.getText("Invoice Records", "發票紀錄"), 
                        appProvider.getText("Transport Benefits", "乘車回饋")
                      ],
                      selectedIndex: _selectedTabIndex,
                      onTabChanged: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Content
                    Expanded(
                      child: _buildTabContent(scrollController, appProvider),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(ScrollController scrollController, AppProvider appProvider) {
    if (_selectedTabIndex == 0) {
      // Tab 1: Transactions
      return ListView(
        controller: scrollController,
        padding: const EdgeInsets.only(bottom: 100), // padding for bottom navbar
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  appProvider.getText("Last 1 week", "最近一週"),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const Icon(Icons.arrow_drop_down),
                const Spacer(),
              ],
            ),
          ),
          TransactionItem(
            title: appProvider.getText("YouBike", "YouBike微笑單車"), 
            date: "2026/04/08 14:30", 
            amount: "- \$15"
          ),
          TransactionItem(
            title: appProvider.getText("7-Eleven", "統一超商"), 
            date: "2026/04/07 09:12", 
            amount: "- \$45"
          ),
          TransactionItem(
            title: appProvider.getText("MRT Ride", "台北捷運"), 
            date: "2026/04/06 18:45", 
            amount: "- \$20"
          ),
        ],
      );
    } else if (_selectedTabIndex == 1) {
      // Tab 2: Invoice Records
      return ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: appProvider.getText("Enter invoice verification code", "輸入發票驗證碼"),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              appProvider.getText("Verify", "驗證"), 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(height: 16),
          Text(
            appProvider.getText(
              "Please enter the verification code printed on your receipt to store it digitally.", 
              "請輸入發票上的驗證碼以將其儲存至雲端。"
            ),
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      // Tab 3: Transport Benefits
      return ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  appProvider.getText("Monthly Cashback", "當月累積回饋金"), 
                  style: const TextStyle(color: Colors.black54)
                ),
                const SizedBox(height: 8),
                Text("\$120", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue[800])),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          appProvider.getText("Ride Count", "乘車次數"), 
                          style: const TextStyle(fontSize: 12, color: Colors.black54)
                        ),
                        const SizedBox(height: 4),
                        const Text("45", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(height: 30, width: 1, color: Colors.grey[300]),
                    Column(
                      children: [
                        Text(
                          appProvider.getText("Total Amount", "累計金額"), 
                          style: const TextStyle(fontSize: 12, color: Colors.black54)
                        ),
                        const SizedBox(height: 4),
                        const Text("\$850", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
