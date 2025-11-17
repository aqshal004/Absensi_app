import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class PreferenceHandler {
  static const String isLogin = "isLogin";
  static const String userName = "userName";
  static const String userEmail = "userEmail";
  static const String isToken = "isToken";

  static saveToken(String value) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(isToken, value);
    }
    
  static getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(isToken);
  }
  
  static saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLogin, value);
  }

  static getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin);
  }

  static removeLogin() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(isLogin);
    prefs.remove(userName);
    prefs.remove(userEmail);
  }

  // Simpan data user
  static saveUserData(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userName, name);
    prefs.setString(userEmail, email);
  }
  
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  // Ambil data user
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(userName),
      'email': prefs.getString(userEmail),
    };
  }
}