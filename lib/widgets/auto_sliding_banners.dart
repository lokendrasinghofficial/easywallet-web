import 'dart:async';
import 'package:flutter/material.dart';

class AutoSlidingBanners extends StatefulWidget {
  final List<Widget> banners;
  final Duration autoScrollDuration;

  const AutoSlidingBanners({
    super.key,
    required this.banners,
    this.autoScrollDuration = const Duration(seconds: 3),
  });

  @override
  State<AutoSlidingBanners> createState() => _AutoSlidingBannersState();
}

class _AutoSlidingBannersState extends State<AutoSlidingBanners> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.95);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.autoScrollDuration, (Timer timer) {
      if (_currentPage < widget.banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        if (_currentPage == 0) {
          // Jump immediately to 0 to mimic continuous loop if needed, or animate back
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
          );
        } else {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (int page) {
        setState(() {
          _currentPage = page;
        });
      },
      itemCount: widget.banners.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: widget.banners[index],
        );
      },
    );
  }
}
