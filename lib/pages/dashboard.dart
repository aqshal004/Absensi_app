import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ppkd_absensi/pages/Location_Detail.dart';
import 'package:ppkd_absensi/preferences/preferences_handler.dart';
import 'package:ppkd_absensi/service/api_profile.dart';
import 'package:ppkd_absensi/views/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = "";
  bool isLoadingCheckIn = false;
  bool isLoadingCheckOut = false;
  
  // Dummy data absen hari ini
  String? checkInTime;
  String? checkOutTime;
  
  // Dummy statistik
  int totalHadir = 22;
  int totalIzin = 2;
  int totalAlpha = 1;
  int totalTerlambat = 3;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadTodayAttendance();
  }

  Future<void> _loadUserProfile() async {
  try {
    final profile = await ProfileAPI.getProfile();
    if (mounted) {
      setState(() {
        userName = profile.data?.name ?? "User";
      });
    }
  } catch (e) {
    print("Gagal memuat profil: $e");
  }
}
  void _loadTodayAttendance() {
    // Simulasi load data absen hari ini
    // TODO: Replace with actual API call
    setState(() {
      checkInTime = "08:15";
      checkOutTime = null; // Belum absen pulang
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  String _getCurrentDate() {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
  }

  Future<void> _handleCheckIn() async {
    setState(() => isLoadingCheckIn = true);

    try {
      // TODO: Implement Geolocator
      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.high,
      // );
      
      // Simulasi data
      double latitude = -6.2088;
      double longitude = 106.8456;
      
      // TODO: Implement API Call
      // final response = await http.post(
      //   Uri.parse('YOUR_API_URL/absen-check-in'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({
      //     'latitude': latitude,
      //     'longitude': longitude,
      //     'timestamp': DateTime.now().toIso8601String(),
      //   }),
      // );

      // Simulasi delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          checkInTime = DateFormat('HH:mm').format(DateTime.now());
          isLoadingCheckIn = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✓ Absen masuk berhasil!'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoadingCheckIn = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleCheckOut() async {
    setState(() => isLoadingCheckOut = true);

    try {
      // TODO: Implement Geolocator
      double latitude = -6.2088;
      double longitude = 106.8456;
      
      // TODO: Implement API Call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          checkOutTime = DateFormat('HH:mm').format(DateTime.now());
          isLoadingCheckOut = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✓ Absen pulang berhasil!'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoadingCheckOut = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _showLocationDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationDetailScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              
              const SizedBox(height: 24),

              // Absen Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildAbsenCard(),
                    const SizedBox(height: 20),
                    _buildAbsenButtons(),
                    const SizedBox(height: 24),
                    _buildStatisticsSection(),
                    const SizedBox(height: 20),
                    _buildTodayAttendance(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.grey.shade800,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(width: 8),
                Text(
                  _getCurrentDate(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTimeCard(
              'Masuk',
              checkInTime ?? '--:--',
              Icons.login,
              Colors.green.shade400,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildTimeCard(
              'Pulang',
              checkOutTime ?? '--:--',
              Icons.logout,
              Colors.orange.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(String label, String time, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildAbsenButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildAbsenButton(
            'Absen Masuk',
            Icons.login,
            Colors.green.shade600,
            isLoadingCheckIn,
            checkInTime == null,
            _handleCheckIn,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAbsenButton(
            'Absen Pulang',
            Icons.logout,
            Colors.orange.shade600,
            isLoadingCheckOut,
            checkInTime != null && checkOutTime == null,
            _handleCheckOut,
          ),
        ),
      ],
    );
  }

  Widget _buildAbsenButton(
    String label,
    IconData icon,
    Color color,
    bool isLoading,
    bool isEnabled,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Statistik Bulan Ini',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Lihat Detail',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Hadir',
                totalHadir.toString(),
                Icons.check_circle,
                Colors.green.shade400,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Izin',
                totalIzin.toString(),
                Icons.info,
                Colors.blue.shade400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Alpha',
                totalAlpha.toString(),
                Icons.cancel,
                Colors.red.shade400,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Terlambat',
                totalTerlambat.toString(),
                Icons.access_time,
                Colors.orange.shade400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayAttendance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Absen Hari Ini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              IconButton(
                onPressed: _showLocationDetail,
                icon: Icon(
                  Icons.location_on,
                  color: Colors.grey.shade600,
                ),
                tooltip: 'Lihat Lokasi',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAttendanceRow(
            'Check In',
            checkInTime ?? 'Belum absen',
            Icons.login,
            Colors.green.shade400,
          ),
          const SizedBox(height: 12),
          _buildAttendanceRow(
            'Check Out',
            checkOutTime ?? 'Belum absen',
            Icons.logout,
            Colors.orange.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(
    String label,
    String time,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}