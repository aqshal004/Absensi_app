import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:ppkd_absensi/pages/dashboard.dart';
import 'package:ppkd_absensi/pages/profile_screen.dart';

class BottomNavWidget extends StatefulWidget {
  final int initialIndex;

  const BottomNavWidget({super.key, this.initialIndex = 0});

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    DashboardScreen(),
    Center(child: Text("Jadwal Posyandu")),
    Center(child: Text("Data Balita")),
    ProfileScreenWidget(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_getTitle(_currentIndex)),
      //   backgroundColor: Colors.teal.shade600,
      //   foregroundColor: Colors.white,
      //   elevation: 0,
      // ),

      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.dashboard),
            title: Text("Home"),
            activeColor: Colors.teal,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.calendar_month),
            title: Text("Jadwal"),
            activeColor: Colors.orange,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.child_care),
            title: Text("Balita"),
            activeColor: Colors.pink,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  // String _getTitle(int index) {
  //   switch (index) {
  //     case 0:
  //       return "Dashboard Absensi";
  //     case 1:
  //       return "Jadwal Posyandu";
  //     case 2:
  //       return "Data Balita";
  //     case 3:
  //       return "Profile";
  //     default:
  //       return "Posyandu";
  //   }
  // }
}
