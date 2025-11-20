import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ppkd_absensi/preferences/preferences_handler.dart';
import 'package:ppkd_absensi/service/api_history.dart';
import 'package:ppkd_absensi/models/history_absen.dart';

class HistoryAbsensiScreen extends StatefulWidget {
  const HistoryAbsensiScreen({Key? key}) : super(key: key);

  @override
  State<HistoryAbsensiScreen> createState() => _HistoryAbsensiScreenState();
}

class _HistoryAbsensiScreenState extends State<HistoryAbsensiScreen> {
  bool isLoading = true;
  List<HistoryAbsen> list = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final token = await PreferenceHandler.getToken();
    final result = await HistoryAbsenApi.getHistory(token: token ?? "");
    
    if (mounted) {
      setState(() {
        list = result?.data ?? [];
        isLoading = false;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat("EEEE, d MMM yyyy", "id_ID").format(date);
  }

  String formatTime(String? time) {
    if (time == null || time == "") return "--:--";
    return time.substring(0, 5);
  }

  String normalizeStatus(String? status) {
  if (status == null || status.isEmpty) return "N/A";

  final s = status.toLowerCase();

  if (s == "masuk") return "Hadir";
  if (s == "hadir") return "Hadir";
  if (s == "izin") return "Izin";
  if (s == "alpha") return "Alpha";
  if (s == "terlambat") return "Terlambat";

  return status;
}

  Color getStatusColor(String? status) {
  status = normalizeStatus(status);

  switch (status) {
    case "Hadir":
      return Colors.green.shade600;
    case "Izin":
      return Colors.orange.shade600;
    case "Alpha":
      return Colors.red.shade600;
    case "Terlambat":
      return Colors.blue.shade600;
    default:
      return Colors.grey.shade600;
  }
}


 IconData getStatusIcon(String? status) {
  status = normalizeStatus(status);

  switch (status) {
    case "Hadir":
      return Icons.check_circle;
    case "Izin":
      return Icons.info;
    case "Alpha":
      return Icons.cancel;
    case "Terlambat":
      return Icons.access_time;
    default:
      return Icons.help;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Riwayat Absensi",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => isLoading = true);
              loadHistory();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade800),
              ),
            )
          : list.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async {
                    await loadHistory();
                  },
                  color: Colors.grey.shade800,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final item = list[i];
                      return _buildHistoryCard(item, i);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Belum ada riwayat absensi",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Riwayat absensi Anda akan muncul di sini",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(HistoryAbsen item, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
          children: [
            // Header dengan tanggal dan status
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatDate(item.attendanceDate),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor(item.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getStatusIcon(item.status),
                          color: getStatusColor(item.status),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                         normalizeStatus(item.status),
                          style: TextStyle(
                            color: getStatusColor(item.status),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body dengan waktu check in/out
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTimeCard(
                      "Check In",
                      formatTime(item.checkInTime),
                      Icons.login,
                      Colors.green.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 1,
                    height: 50,
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimeCard(
                      "Check Out",
                      formatTime(item.checkOutTime),
                      Icons.logout,
                      Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard(String label, String time, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
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
}