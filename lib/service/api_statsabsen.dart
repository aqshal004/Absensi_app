import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ppkd_absensi/constant/endpoint.dart';
import 'package:ppkd_absensi/models/attendance_stats.dart';

class AttendanceStatsApi {
  
  /// -----------------------------
  /// GET ATTENDANCE STATS
  /// -----------------------------
  static Future<AttendanceStatsModel?> getAttendanceStats({
    required String token,
  }) async {
    final url = Uri.parse(Endpoint.attendanceStats);

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return AttendanceStatsModel.fromJson(jsonDecode(response.body));
    } else {
      print("Gagal fetch attendance stats (${response.statusCode}): ${response.body}");
      return null;
    }
  }
}
