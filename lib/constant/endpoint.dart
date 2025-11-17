class Endpoint {
  static const String baseUrl = "https://appabsensi.mobileprojp.com";
  static const String register = "$baseUrl/api/register";
  static const String login = "$baseUrl/api/login";
  static const String profile = "$baseUrl/api/profile"; // GET - Mendapatkan data profile
  static const String updateProfile = "$baseUrl/api/profile"; // PUT/POST - Update profile
  static const String trainings = '$baseUrl/api/trainings';
  static const String batches = '$baseUrl/api/batches'; 
}