import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ppkd_absensi/preferences/preferences_handler.dart';
import 'package:ppkd_absensi/service/api_attendance.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  GoogleMapController? mapController;
  LatLng? currentPosition;
  bool isLoading = true;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Kalau user tolak izin lokasi, jangan crash
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin lokasi ditolak")),
      );
      return;
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentPosition = LatLng(pos.latitude, pos.longitude);
      isLoading = false;
    });
  }

  Future<void> _handleCheckIn() async {
    if (currentPosition == null) return;

    setState(() => isSending = true);

    try {
      final token = await PreferenceHandler.getToken();

      await AttendanceApi.checkIn(
        token: token ?? "",
        lat: currentPosition!.latitude,
        lng: currentPosition!.longitude,
        address: "Lokasi Map",
      );

      if (!mounted) return;

      setState(() => isSending = false);

      // Sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✓ Check in berhasil")),
      );

      // Tutup halaman dan beritahu dashboard untuk refresh
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() => isSending = false);

      final msg = e.toString();

      // Kalau pesan dari backend: "Anda sudah melakukan absen pada tanggal ini"
      if (msg.contains("Anda sudah melakukan absen pada tanggal ini")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Anda sudah melakukan absen hari ini"),
            backgroundColor: Colors.orange,
          ),
        );

        // Opsional: boleh tutup halaman atau dibiarkan
        Navigator.pop(context, false);
      } else {
        // Error lain
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal check in: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check In"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: currentPosition!,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId("pos"),
                      position: currentPosition!,
                    ),
                  },
                ),

                // Tombol Check In
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: isSending ? null : _handleCheckIn,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: isSending
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Check In Sekarang",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                )
              ],
            ),
    );
  }
}
