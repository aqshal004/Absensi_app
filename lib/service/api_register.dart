import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:ppkd_absensi/constant/endpoint.dart';
import 'package:ppkd_absensi/models/login_model.dart';
import 'package:ppkd_absensi/models/register_model.dart';

class AuthAPI {
  static Future<LoginModel> loginUser({
  required String email,
  required String password,
}) async {
  final url = Uri.parse(Endpoint.login);

  final response = await http.post(
    url,
    headers: {"Accept": "application/json"},
    body: {
      "email": email,
      "password": password,
    },
  );

  log("LOGIN (${response.statusCode})");
  log(response.body);

  if (response.statusCode == 200) {
    return LoginModel.fromJson(json.decode(response.body));
  } else {
    final error = json.decode(response.body);
    throw Exception(error["message"] ?? "Login gagal");
  }
}
 static Future<RegisterModel> registerUser({
  required String email,
  required String name,
  required String password,
  required String jenisKelamin,
  required int batchId,
  required int trainingId,
}) async {
  final url = Uri.parse(Endpoint.register);

  final response = await http.post(
    url,
    headers: {"Accept": "application/json"},
    body: {
      "name": name,
      "email": email,
      "password": password,
      "jenis_kelamin": jenisKelamin,
      "batch_id": batchId.toString(),
      "training_id": trainingId.toString(),
    },
  );

  print(response.body);
  print(response.statusCode);

  if (response.statusCode == 200) {
    return RegisterModel.fromJson(json.decode(response.body));
  } else {
    final error = json.decode(response.body);
    throw Exception(error["message"]);
  }
}
}



class TrainingAPI {
  static Future<List<Training>> getTrainings() async {
    final url = Uri.parse(Endpoint.trainings);
    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    log('getTrainings: ${response.statusCode}');
    log(response.body);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List data = jsonBody['data'] as List;
      return data.map((e) => Training.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data pelatihan");
    }
  }

  static Future<List<Batch>> getTrainingBatches() async {
    final url = Uri.parse(Endpoint.batches);
    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    log('getTrainingBatches: ${response.statusCode}');
    log(response.body);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List data = jsonBody['data'] as List;
      return data.map((e) => Batch.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data batch pelatihan");
    }
  }
}