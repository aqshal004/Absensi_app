import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:ppkd_absensi/pages/checkin.dart';
import 'package:ppkd_absensi/pages/checkout.dart';
import 'package:ppkd_absensi/pages/editprofile_screen.dart';
import 'package:ppkd_absensi/preferences/preferences_handler.dart';
import 'package:ppkd_absensi/service/api_attendancetoday.dart';
import 'package:ppkd_absensi/service/api_profile.dart';
import 'package:ppkd_absensi/service/api_statsabsen.dart';

// --- DEFINISI WARNA (Tetap dipertahankan) ---
const Color _primaryBackgroundColor = Color(0xFFFFFFFF);
const Color _cardBackgroundColor = Color(0xFFFFFFFF);
const Color _darkTextColor = Color(0xFF212121);
const Color _mediumTextColor = Color(0xFF616161);
const Color _lightTextColor = Color(0xFF9E9E9E);
const Color _accentGray = Color(0xFF424242);
const Color _dividerColor = Color(0xFFE0E0E0);
const Color _successColor = Color(0xFF4CAF50);
const Color _warningColor = Color(0xFFFF9800);
const Color _dangerColor = Color(0xFFF44336);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = "";
  String userEmail = "";
  int userBatchId = 0;
  int userTrainingId = 0;
  String userGender = "";
  
  bool isLoadingCheckIn = false;
  bool isLoadingCheckOut = false;
  bool isLoadingStats = true;
  
  String? checkInTime = "--:--";
  String? checkOutTime = "--:--";
  
int totalHadir = 0;
int totalIzin = 0;
int totalAbsen = 0;
int totalTerlambat = 0;
bool sudahAbsenHariIni = false;

  // Live Time
  String currentTime = '';
  String currentDate = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
     fetchStats(); 
    _loadUserProfile();
    _loadTodayAttendance();
    Intl.defaultLocale = 'id';
    _updateTime();
    _startTimer();
    // _loadFromApi();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
        currentDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
      });
    }
  }

//   // --- FUNCTION INTACT (TIDAK DIUBAH) ---
//   Future<void> _loadFromApi() async {
//   final token = await PreferenceHandler.getToken();
//   final data = await AttendanceApi.getTodayAttendance(token: token ?? "");

//   if (mounted && data != null) {
//     setState(() {
//       checkInTime = data.checkInTime;
//       checkOutTime = data.checkOutTime;
//     });
//   }
// }

   // =============================
  // LOAD USER PROFILE
  // =============================
  Future<void> _loadUserProfile() async {
    try {
      final userData = await PreferenceHandler.getUserData();
      if (mounted) {
        setState(() {
          userName = userData['name'] ?? "";
          userEmail = userData['email'] ?? "";
        });
      }

      final profile = await ProfileAPI.getProfile();
      if (mounted) {
        setState(() {
          userName = profile.data?.name ?? userName;
        });
      }
    } catch (e) {
      print("Gagal memuat profil: $e");
    }
  }

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          name: userName,
          email: userEmail,
          batchId: userBatchId,
          trainingId: userTrainingId,
          gender: userGender,
        ),
      ),
    );

    if (result == true && mounted) {
      final userData = await PreferenceHandler.getUserData();
      setState(() {
        userName = userData['name'] ?? userName;
        userEmail = userData['email'] ?? userEmail;
      });
      _loadUserProfile();
    }
  }
// =============================
  // LOAD Stats Attendance
  // =============================
  Future<void> fetchStats() async {
  final token = await PreferenceHandler.getToken(); // jika token pakai preferences

  final result = await AttendanceStatsApi.getAttendanceStats(token: token);

  if (result != null && result.data != null) {
    setState(() {
      totalHadir = result.data!.totalMasuk ?? 0;
      totalIzin = result.data!.totalIzin ?? 0;
      totalAbsen = result.data!.totalAbsen ?? 0;

      // Jika backend punya field terlambat, tambahkan di model
      totalTerlambat = 0;

      sudahAbsenHariIni = result.data!.sudahAbsenHariIni ?? false;
      isLoadingStats = false;
    });
  } else {
    setState(() => isLoadingStats = false);
  }
}

  // =============================
  // LOAD TODAY ATTENDANCE
  // =============================
 Future<void> _loadTodayAttendance() async {
  final token = await PreferenceHandler.getToken();
  if (token == null) return;

  try {
    final result = await AbsenTodayAPI.getToday(token: token);

    setState(() {
      checkInTime = result.data?.checkInTime ?? "--:--";
      checkOutTime = result.data?.checkOutTime ?? "--:--";
    });

  } catch (e) {
    print("Error today attendance: $e");

    setState(() {
      checkInTime = "--:--";
      checkOutTime = "--:--";
    });
  }
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

 // =============================
  // CHECK IN
  // =============================
  Future<void> _handleCheckIn() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckInScreen()),
    );

    if (result == true) {
      await _loadTodayAttendance();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✓ Absen masuk berhasil!'),
          backgroundColor: _successColor,
        ),
      );
    }
  }

// =============================
  // CHECK OUT
  // =============================
   Future<void> _handleCheckOut() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CheckOutScreen()),
  );

  if (result == true) {
    await _loadTodayAttendance();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✓ Absen pulang berhasil!'),
        backgroundColor: _successColor,
      ),
    );
  }
}


    // =============================
  // CHECK RULES
  // =============================
  bool get canCheckIn {
  // Bisa check-in hanya jika BELUM ADA jam check-in
  return checkInTime == null ||
         checkInTime == "--:--" ||
         checkInTime!.trim().isEmpty;
}

bool get canCheckOut {
  // Bisa check-out jika SUDAH check-in DAN BELUM check-out
  final sudahCheckIn = checkInTime != null &&
                       checkInTime != "--:--" &&
                       checkInTime!.trim().isNotEmpty;

  final belumCheckOut = checkOutTime == null ||
                        checkOutTime == "--:--" ||
                        checkOutTime!.trim().isEmpty;

  return sudahCheckIn && belumCheckOut;
}


  // --- WIDGET BUILDER MODIFIKASI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildLiveTimeCard(),
                    const SizedBox(height: 20),
                    _buildQuickAbsenButtons(),
                    const SizedBox(height: 24),
                    _buildStatisticsGrid(),
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: TextStyle(
                    fontSize: 14,
                    color: _mediumTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _darkTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: _navigateToEditProfile,
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _accentGray.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(color: _dividerColor, width: 1),
              ),
              child: const Icon(
                Icons.person_outline,
                color: _accentGray,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveTimeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, size: 18, color: _mediumTextColor),
              const SizedBox(width: 8),
              Text(
                'Waktu Saat Ini',
                style: TextStyle(
                  fontSize: 14,
                  color: _mediumTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            currentTime,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: _accentGray,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currentDate,
            style: TextStyle(
              fontSize: 13,
              color: _mediumTextColor,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _dividerColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeStatus('Masuk', checkInTime ?? '--:--'),
                Container(width: 1, height: 30, color: _dividerColor),
                _buildTimeStatus('Pulang', checkOutTime ?? '--:--'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeStatus(String label, String time) {
    final isSet = time != '--:--';
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: _mediumTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSet ? _darkTextColor : _lightTextColor,
          ),
        ),
      ],
    );
  }


  Widget _buildQuickAbsenButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildAbsenButton(
          'Check In',
          Icons.login_rounded,
          _darkTextColor,
          isLoadingCheckIn,
          canCheckIn, // <-- SEKARANG SESUAI DENGAN API
          _handleCheckIn,
        ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildAbsenButton(
            'Check Out',
            Icons.logout_rounded,
            _mediumTextColor,
            isLoadingCheckOut,
            canCheckOut,
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
        disabledBackgroundColor: _dividerColor,
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
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 24),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatisticsGrid() {
  if (isLoadingStats) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

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
              color: _darkTextColor,
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Text(
                  'Detail',
                  style: TextStyle(
                    fontSize: 12,
                    color: _mediumTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.chevron_right, size: 16, color: _mediumTextColor),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),

      /// ROW 1 — Hadir & Izin
      Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Hadir',
              totalHadir.toString(),
              Icons.check_circle_outline,
              _successColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              'Izin',
              totalIzin.toString(),
              Icons.event_note_outlined,
              _mediumTextColor,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),

      /// ROW 2 — Alpha & Terlambat
      Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Absen',
              totalAbsen.toString(),
              Icons.bar_chart,
              _dangerColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              'Terlambat',
              totalTerlambat.toString(),
              Icons.access_time_outlined,
              _warningColor,
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
        color: _cardBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _dividerColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.04),
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
              color: _darkTextColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: _mediumTextColor,
            ),
          ),
        ],
      ),
    );
  }
}