import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class RewardPopup extends StatefulWidget {
  const RewardPopup({super.key});

  @override
  State<RewardPopup> createState() => _RewardPopupState();
}

class _RewardPopupState extends State<RewardPopup> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  final GlobalKey<ScratcherState> scratchKey = GlobalKey<ScratcherState>();
  bool _isScratched = false;
  late String _randomReward;

  final List<String> _rewards = [
    "McDonald's Coupon 🍔",
    "KFC Coupon 🍗",
    "7-Eleven Coupon 🏪",
    "FamilyMart Coupon 🛒",
    "Better Luck Next Time 😅",
  ];

  @override
  void initState() {
    super.initState();
    _randomReward = _rewards[Random().nextInt(_rewards.length)];

    _controller = AnimationController(
       vsync: this,
       duration: const Duration(milliseconds: 700),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // play the entry animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closePopup() async {
    await _controller.reverse();
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Overlay
          FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: _closePopup,
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          
          // Foreground Content
          SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75, // ~70-75% width
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Scratch for a Reward!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // Scratcher Window
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 5))
                            ]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Scratcher(
                              key: scratchKey,
                              brushSize: 40,
                              threshold: 50,
                              color: Colors.grey[400]!,
                              onThreshold: () {
                                setState(() {
                                  _isScratched = true;
                                });
                                scratchKey.currentState?.reveal(duration: const Duration(milliseconds: 500));
                              },
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    _isScratched ? "You won\n$_randomReward" : "?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: _isScratched ? 20 : 60,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        AnimatedOpacity(
                          opacity: _isScratched ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isScratched ? _closePopup : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              ),
                              child: const Text(
                                "Claim Reward",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
