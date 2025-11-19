import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ppkd_absensi/constant/endpoint.dart';
import 'package:ppkd_absensi/models/history_absen.dart';


class HistoryAbsenApi {
  
  /// -----------------------------
  /// GET HISTORY ABSENSI
  /// -----------------------------
  static Future<HistoryAbsenModel?> getHistory({
    required String token,
  }) async {
    final url = Uri.parse(Endpoint.historyAbsen);

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return HistoryAbsenModel.fromJson(jsonDecode(response.body));
    } else {
      print("Gagal fetch history (${response.statusCode}): ${response.body}");
      return null;
    }
  }
}
