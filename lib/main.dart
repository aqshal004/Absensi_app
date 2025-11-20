import 'package:flutter/material.dart';
import 'package:ppkd_absensi/views/bottom_nav.dart';
import 'package:ppkd_absensi/views/login_screen.dart';
import 'package:ppkd_absensi/views/register_screen.dart';
import 'package:ppkd_absensi/views/splash_screen.dart'; // halaman pertama aplikasi kamu
import 'package:intl/date_symbol_data_local.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // Inisialisasi locale id_ID
  await initializeDateFormatting('id_ID', null);
  // Inisialisasi database untuk desktop
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;
  // lakukan inisialisasi yang diperlukan di sini
  // final isLoggedIn = await PreferencesHandler.isLogin(); // kalau kamu punya fungsi init SharedPreferences

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final bool isLoggedIn;
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CheckinGO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreenWidget(),
        '/login': (context) => const LoginScreenWidget(),
        '/register': (context) => const RegisterScreenWidget(),
        '/bottomnav': (context) => const BottomNavWidget(),
      },

      // home: const SplashScreenWidget(), // halaman awal
    );
  }
}