import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/app_mode.dart';
import 'pin_screen.dart';
import 'success_screen.dart';

class Merchant {
  final String name;
  final String logoUrl;
  Merchant(this.name, this.logoUrl);
}

final List<Merchant> _mockMerchants = [
  Merchant("McDonald's", "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/McDonald%27s_Golden_Arches.svg/512px-McDonald%27s_Golden_Arches.svg.png"),
  Merchant("KFC", "https://upload.wikimedia.org/wikipedia/en/thumb/b/bf/KFC_logo.svg/512px-KFC_logo.svg.png"),
  Merchant("7-Eleven", "https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/7-eleven_logo.svg/512px-7-eleven_logo.svg.png"),
];

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isValid = false;
  late Merchant _merchant;

  @override
  void initState() {
    super.initState();
    _merchant = _mockMerchants[Random().nextInt(_mockMerchants.length)];
    _amountController.addListener(() {
      setState(() {
        _isValid = _amountController.text.isNotEmpty && int.tryParse(_amountController.text) != null;
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Pay to Merchant", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        _merchant.name,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Enter payment amount below",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      child: const Text("Wallet Balance: NT\$ 77", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 24),
                      if ((appProvider.currentMode == AppMode.simple || appProvider.currentMode == AppMode.tourist) && _amountController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            "≈ \$ ${(int.parse(_amountController.text) * 0.031).toStringAsFixed(2)} USD",
                            style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          prefixText: "NT\$ ",
                          prefixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          border: InputBorder.none,
                          hintText: "0",
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isValid ? () {
                            if (appProvider.currentMode == AppMode.simple || appProvider.currentMode == AppMode.tourist) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessScreen(amount: _amountController.text)));
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PinScreen(amount: _amountController.text)));
                            }
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            elevation: 0,
                          ),
                          child: const Text("Proceed to Pay", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
