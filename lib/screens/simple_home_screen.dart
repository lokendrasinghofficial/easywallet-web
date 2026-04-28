import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/simple_button.dart';
import 'qr_scanner_screen.dart';
import 'simple_settings.dart';

class SimpleHomeScreen extends StatelessWidget {
  const SimpleHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(appProvider.getText("Easy Wallet", "悠遊付"), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 36, color: Colors.blueAccent),
            padding: const EdgeInsets.only(right: 16),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SimpleSettingsScreen()));
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Language Toggle Banner
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.blue[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _langToggle(context, appProvider, "中文", "中文"),
                  _langToggle(context, appProvider, "EN", "English"),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    SimpleButton(
                      icon: Icons.qr_code_scanner, 
                      label: appProvider.getText("Scan &\nPay", "掃碼\n支付"), 
                      color: Colors.blueAccent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const QRScannerScreen()));
                      },
                    ),
                    SimpleButton(
                      icon: Icons.qr_code_2, 
                      label: appProvider.getText("Payment\nCode", "付款\n碼"), 
                      color: Colors.teal,
                      onTap: () {},
                    ),
                    SimpleButton(
                      icon: Icons.call_received, 
                      label: appProvider.getText("Receive\nMoney", "收款"), 
                      color: Colors.amber[700]!,
                      onTap: () {},
                    ),
                    SimpleButton(
                      icon: Icons.account_balance_wallet, 
                      label: appProvider.getText("Check\nBalance", "餘額\n查詢"), 
                      color: Colors.indigo,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            
            // Tourist Utilities
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                      ),
                      icon: const Icon(Icons.directions_subway, color: Colors.black87),
                      label: Text(appProvider.getText("Transport", "交通乘車"), style: const TextStyle(fontSize: 18, color: Colors.black87)),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                      ),
                      icon: const Icon(Icons.location_on, color: Colors.black87),
                      label: Text(appProvider.getText("Stores Map", "通路地圖"), style: const TextStyle(fontSize: 18, color: Colors.black87)),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),

            // Emergency Support
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
              child: SizedBox(
                width: double.infinity,
                height: 80,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.support_agent, size: 36, color: Colors.white),
                  label: Text(appProvider.getText("Help / Support", "幫助 / 客服"), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _langToggle(BuildContext context, AppProvider provider, String code, String label) {
    bool isSelected = provider.language == code;
    return GestureDetector(
      onTap: () => provider.setLanguage(code),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.blueAccent : Colors.grey[300]!)
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87
          ),
        ),
      ),
    );
  }
}
