import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/reward_popup.dart';
import 'split_money_screen.dart';

class SuccessScreen extends StatefulWidget {
  final String amount;
  const SuccessScreen({super.key, required this.amount});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _scaleAnimation;
  late AnimationController _speedController;
  final List<Offset> _speedLines = List.generate(20, (_) => Offset(Random().nextDouble(), Random().nextDouble()));

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnimation = CurvedAnimation(parent: _mainController, curve: Curves.elasticOut);
    
    _speedController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
    
    _mainController.forward();
    
    // Auto transition to Scratch Card Reward modal
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) => const RewardPopup(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _speedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32), // Solid dark green
      body: Stack(
        children: [
          // Speed Lines Animation
          AnimatedBuilder(
            animation: _speedController,
            builder: (context, child) {
              return CustomPaint(
                painter: SpeedLinesPainter(_speedController.value, _speedLines),
                size: Size.infinite,
              );
            },
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, size: 80, color: Color(0xFF2E7D32)),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  appProvider.getText("Payment Successful", "支付成功"),
                  style: const TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  appProvider.getText("Complete", "交易完成"),
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "\$${widget.amount}",
                  style: const TextStyle(
                    fontSize: 56, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                    shadows: [
                      Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                
                // Bottom Action
                FadeTransition(
                  opacity: _mainController,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SplitMoneyScreen(prefillAmount: widget.amount),
                        ),
                      );
                    },
                    icon: const Icon(Icons.call_split, size: 18, color: Colors.white),
                    label: Text(
                      appProvider.getText('Split this bill?', '要分帳嗎？'),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white54, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpeedLinesPainter extends CustomPainter {
  final double progress;
  final List<Offset> points;

  SpeedLinesPainter(this.progress, this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var point in points) {
      final x = point.dx * size.width;
      final startY = ((point.dy + progress) % 1.0) * size.height;
      final endY = startY + 40;
      
      canvas.drawLine(Offset(x, startY), Offset(x, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant SpeedLinesPainter oldDelegate) => true;
}
