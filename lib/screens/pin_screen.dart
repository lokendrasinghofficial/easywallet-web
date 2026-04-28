import 'package:flutter/material.dart';
import 'success_screen.dart';

class PinScreen extends StatefulWidget {
  final String amount;
  const PinScreen({super.key, required this.amount});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = "";

  void _onKeypadTap(String value) {
    if (_pin.length < 4) {
      setState(() => _pin += value);
      if (_pin.length == 4) {
        _simulatePaymentProcess();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  void _simulatePaymentProcess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pop(context); // close dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen(amount: widget.amount)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Enter PIN", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Text("Enter your 4-digit payment PIN", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              bool isFilled = index < _pin.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled ? Colors.blueAccent : Colors.grey[300],
                ),
              );
            }),
          ),
          const Spacer(),
          _buildKeypad(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_calcButton('1'), _calcButton('2'), _calcButton('3')]),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_calcButton('4'), _calcButton('5'), _calcButton('6')]),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_calcButton('7'), _calcButton('8'), _calcButton('9')]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 70), // Empty space
              _calcButton('0'),
              GestureDetector(
                onTap: _onBackspace,
                child: Container(
                  width: 70,
                  height: 70,
                  alignment: Alignment.center,
                  child: const Icon(Icons.backspace_outlined, size: 28),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _calcButton(String number) {
    return GestureDetector(
      onTap: () => _onKeypadTap(number),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(number, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.normal)),
      ),
    );
  }
}
