class Endpoint {
  static const String baseUrl = "https://appabsensi.mobileprojp.com";

  static const String register = "$baseUrl/api/register";
  static const String login = "$baseUrl/api/login";

  static const String profile = "$baseUrl/api/profile"; 
  static const String updateProfile = "$baseUrl/api/profile";

  static const String trainings = '$baseUrl/api/trainings';
  static const String batches = '$baseUrl/api/batches';

  // Attendance
  static const String checkIn = "$baseUrl/api/absen/check-in";
  static const String checkOut = "$baseUrl/api/absen/check-out";
  static const String attendanceToday = "$baseUrl/api/absen/today";
  static const String historyAbsen = "$baseUrl/api/absen/history";
  static const String attendanceStats = "$baseUrl/api/absen/stats";
}
