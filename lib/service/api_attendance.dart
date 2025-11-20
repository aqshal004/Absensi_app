import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:ppkd_absensi/constant/endpoint.dart';
import 'package:ppkd_absensi/models/attendance_model.dart';

class AttendanceApi {
  /// -----------------------------
  /// CHECK IN
  /// -----------------------------
  static Future<AttendanceModel> checkIn({
  required String token,
  required double lat,
  required double lng,
  required String address,
}) async {
  final url = Uri.parse(Endpoint.checkIn);

  final now = DateTime.now();

  // yyyy-MM-dd
  final formattedDate =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  // H:i (HH:mm)
  final formattedTime =
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

  final response = await http.post(
    url,
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
    body: {
      "attendance_date": formattedDate,
      "check_in": formattedTime,            // <-- WAJIB FORMAT H:i
      "check_in_lat": lat.toString(),
      "check_in_lng": lng.toString(),
      "check_in_address": address,
    },
  );

  log(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    return AttendanceModel.fromJson(json.decode(response.body));
  } else {
    final error = json.decode(response.body);
    throw Exception(error["message"] ?? "Gagal check in");
  }
}



  /// -----------------------------
  /// CHECK OUT
  /// -----------------------------
  static Future<AttendanceModel> checkOut({
    required String token,
    required double lat,
    required double lng,
    required String address,
  }) async {
    final url = Uri.parse(Endpoint.checkOut);
     final now = DateTime.now();

      // yyyy-MM-dd
  final formattedDate =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  // H:i (HH:mm)
  final formattedTime =
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: {
        "attendance_date": formattedDate,
        "check_out": formattedTime,    
        "check_out_lat": lat.toString(),
        "check_out_lng": lng.toString(),
        "check_out_address": address,
      },
    );

    log(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AttendanceModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal check out");
    }
  }
}