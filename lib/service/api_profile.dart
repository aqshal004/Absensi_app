import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:ppkd_absensi/constant/endpoint.dart';
import 'package:ppkd_absensi/models/edit_profile.dart';
import 'package:ppkd_absensi/models/profile_model.dart';
import 'package:ppkd_absensi/preferences/preferences_handler.dart';

class ProfileAPI {
  /// ===============================
  /// 1. GET PROFILE
  /// ===============================
  static Future<ProfileModel> getProfile()async {
    final url = Uri.parse(Endpoint.profile);

    // Ambil token dari storage (shared preferences / secure storage)
    final token = await PreferenceHandler.getToken(); // Implement fungsi ini sesuai cara Anda menyimpan token
    print(token);
    final response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    log("GET PROFILE (${response.statusCode})");
    log(response.body);

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal memuat profil");
    }
  }

  /// ===============================
  /// 2. UPDATE PROFILE (EDIT)
  /// ===============================
  static Future<EditProfileModel> updateProfile({
    // required String token,
    required String name,
    required String email,
    required String jenisKelamin,
    required int batchId,
    required int trainingId,
  }) async {
    final url = Uri.parse(Endpoint.updateProfile);

     // Ambil token dari storage
    final token = await PreferenceHandler.getToken();

    final response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: {
        "name": name,
        "email": email,
        "jenis_kelamin": jenisKelamin,
        "batch_id": batchId.toString(),
        "training_id": trainingId.toString(),
      },
    );

    log("UPDATE PROFILE (${response.statusCode})");
    log(response.body);

    if (response.statusCode == 200) {
      return EditProfileModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal update profil");
    }
  }
}
