import 'package:flutter/material.dart';
import 'package:ppkd_absensi/pages/dashboard.dart';
import 'package:ppkd_absensi/pages/history_absen.dart';
import 'package:ppkd_absensi/pages/profile_screen.dart';

class BottomNavWidget extends StatefulWidget {
  final int initialIndex;

  const BottomNavWidget({super.key, this.initialIndex = 0});

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> with TickerProviderStateMixin {
  late int _currentIndex;
  late AnimationController _animationController;
  late List<AnimationController> _iconControllers;

  final List<Widget> _pages = const [
    DashboardScreen(),
    HistoryAbsensiScreen(),
    ProfileScreenWidget(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _iconControllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _iconControllers[_currentIndex].forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      _iconControllers[_currentIndex].reverse();
      _iconControllers[index].forward();
      
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.02, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: IndexedStack(
          key: ValueKey<int>(_currentIndex),
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.dashboard_rounded,
                  label: "Home",
                  index: 0,
                  color: const Color(0xFF2D3436),
                ),
                _buildNavItem(
                  icon: Icons.history,
                  label: "History Absen",
                  index: 1,
                  color: const Color(0xFF636E72),
                ),
                _buildNavItem(
                  icon: Icons.person_rounded,
                  label: "Profile",
                  index: 2,
                  color: const Color(0xFF636E72),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color color,
  }) {
    final isSelected = _currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _iconControllers[index],
          builder: (context, child) {
            final animation = _iconControllers[index];
            final scale = 1.0 + (animation.value * 0.2);
            
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Animated background circle
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: isSelected ? 56 : 0,
                        height: isSelected ? 56 : 0,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                      ),
                      // Icon with scale animation
                      Transform.scale(
                        scale: scale,
                        child: Icon(
                          icon,
                          size: 26,
                          color: isSelected ? color : Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Label with fade and slide animation
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: isSelected ? 12 : 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? color : Colors.grey.shade400,
                    ),
                    child: Text(label),
                  ),
                  // Active indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.only(top: 4),
                    width: isSelected ? 24 : 0,
                    height: 3,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}