import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:ppkd_absensi/constant/endpoint.dart';
import 'package:ppkd_absensi/models/attendance_today.dart';

class AbsenTodayAPI {
  /// ============================================================
  /// GET ABSEN HARI INI
  /// ============================================================
  static Future<AbsenTodayModel> getToday({
    required String token,
  }) async {
    final url = Uri.parse(Endpoint.attendanceToday);

    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    log("ABSEN TODAY RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
  return AbsenTodayModel.fromJson(json.decode(response.body));
} else if (response.statusCode == 404) {
  // Hari ini belum absen → Tidak error
  return AbsenTodayModel(data: null);
} else {
  throw Exception(json.decode(response.body)["message"]);
}

  }
}
