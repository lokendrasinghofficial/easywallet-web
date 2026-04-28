import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final int index;
  final int totalCount;

  const CardWidget({
    super.key,
    required this.index,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Abstract Colorful background (Simulated using containers or CustomPaint)
            Positioned(
              left: -30,
              top: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: Color(0xFFD6A033), // Yellow abstract shape
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: -50,
              child: Container(
                width: 120,
                height: 180,
                decoration: const BoxDecoration(
                  color: Color(0xFF1D70B8), // Blue abstract shape
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  color: Color(0xFFC8106D), // Magenta abstract shape
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -20,
              bottom: 20,
              child: Container(
                width: 130,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF269D3B), // Green abstract shape
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
            
            // Edit icon
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            
            // Indicator
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${index + 1}/$totalCount",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
