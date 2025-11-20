import 'package:flutter/material.dart';

// ============= CREDIT FOOTER WIDGET =============
class CreditFooter extends StatefulWidget {
  const CreditFooter({Key? key}) : super(key: key);

  @override
  State<CreditFooter> createState() => _CreditFooterState();
}

class _CreditFooterState extends State<CreditFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Created by
            Text(
              'Created by',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade400,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            // Credit
            Text(
              '© 2025 Aqshal Mumtaz',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Mobile Developer',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade400,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}