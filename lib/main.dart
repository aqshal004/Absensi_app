import 'package:flutter/material.dart';
import 'package:ppkd_absensi/views/login_screen.dart'; // halaman pertama aplikasi kamu


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'Absensi App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // initialRoute: '/splash',
      // routes: {
      //   '/splash': (context) => const SplashScreen(),
      //   '/login': (context) => const LoginPosyanduWidget(),
      //   '/register': (context) => const RegisterScreenWidget(),
      //   '/bottomnav': (context) => const BottomNav(), // Admin
      //   '/bottomuser': (context) => const BottomNavUser(), // User
      //   '/user': (context) => const DashboardWidget(),
      // },

      home: const LoginScreenWidget(), // halaman awal
    );
  }
}